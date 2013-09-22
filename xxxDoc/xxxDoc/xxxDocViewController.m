//
//  xxxDocViewController.m
//  xxxDoc
//
//  Created by Baishen Xu on 9/10/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import "xxxDocViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "xxxDocChangeSet.h"
#import "xxxDocOperation.h"
#import "xxxDocCollabrifyWorker.h"
#import "xxxDocTextView.h"
#import "xxxDocBufferWorker.h"
#import "xxxDocStackManager.h"

@interface xxxDocViewController ()


@property (weak, nonatomic) xxxDocStackManager *stackManager;

// The stack store the operation that can be redo.
// Clear the stack once user have new input.
@property (strong, nonatomic) NSMutableArray *redoStack;

// The index of the last global operation.
@property (nonatomic) int recentGlobalID;

// The user's session ID
@property (nonatomic) int64_t participantID;

// The user's input view.
@property (weak, nonatomic) UITextView *inputTextView;

// The CollabrifyClient worker to use the API
@property (strong, nonatomic) xxxDocCollabrifyWorker *clientWorker;

// Add a timer that update change set every n sec.
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation xxxDocViewController

@synthesize stackManager = _stackManager;
@synthesize recentGlobalID = _recentGlobalID;
@synthesize participantID = _participantID;
@synthesize timer = _timer;

- (xxxDocStackManager*) stackManager
{
    if (_stackManager == nil){
        _stackManager = [xxxDocStackManager getStackManager];
    }
    return _stackManager;
}

- (NSMutableArray*) redoStack
{
    return [xxxDocStackManager getStackManager].redoStack;
}

- (int64_t) participantID
{
    return self.clientWorker.participantID;
}

- (NSTimer*) timer
{
    if (_timer == nil){
        _timer = [[NSTimer alloc] init];
    }
    return _timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    double width = self.view.frame.size.width;
    double height = self.view.frame.size.height;
    double buttonViewHeight = 40.f;
    double buttonOffset = 3.f;
	// Do any additional setup after loading the view, typically from a nib.
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, width, buttonViewHeight)];
    [buttonView setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton *undoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *redoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *createButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [undoButton addTarget:self action:@selector(undoAct:) forControlEvents:UIControlEventTouchDown];
    [redoButton addTarget:self action:@selector(redoAct:) forControlEvents:UIControlEventTouchDown];
    [createButton addTarget:self action:@selector(createSess:) forControlEvents:UIControlEventTouchDown];
    [joinButton addTarget:self action:@selector(joinSess:) forControlEvents:UIControlEventTouchDown];
    
    [undoButton setTitle:@"undo" forState:UIControlStateNormal];
    [undoButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [redoButton setTitle:@"redo" forState:UIControlStateNormal];
    [redoButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [createButton setTitle:@"create" forState:UIControlStateNormal];
    [createButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [joinButton setTitle:@"join" forState:UIControlStateNormal];
    [joinButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [undoButton setFrame:CGRectMake(width / 2 + buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    [redoButton setFrame:CGRectMake(width / 4 * 3 + buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    [createButton setFrame:CGRectMake(buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    [joinButton setFrame:CGRectMake(width / 4 + buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    
    [buttonView addSubview:undoButton];
    [buttonView addSubview:redoButton];
    [buttonView addSubview:createButton];
    [buttonView addSubview:joinButton];
    [self.view addSubview:buttonView];
    
    double textViewOffset = 10.f;
    xxxDocTextView *textView = [[xxxDocTextView alloc]initWithFrame:CGRectMake(0.f, buttonViewHeight + textViewOffset, width, height - buttonViewHeight - textViewOffset)];
    [textView setDelegate:self];
    [textView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textView setScrollEnabled:YES];
    
    [xxxDocStackManager getStackManager].inputTextView = textView;
    [self setInputTextView:textView];
    [self.view addSubview:textView];
    
    // Add a timer that update change set every n sec.
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateChangeSetToAllUser) userInfo:nil repeats:YES];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self clientWorker]) {
        [self setClientWorker:[[xxxDocCollabrifyWorker alloc]init]];
        [xxxDocStackManager getStackManager].clientWorker = self.clientWorker;
    }
}

- (void)createSess: (UIButton *)createButton
{
    [[self clientWorker]createSession];
}

- (void)joinSess: (UIButton *)joinButton
{
    [[self clientWorker]joinSessionWithSessionID:(int64_t)2299149];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)undoAct: (UIButton *)undoButton
{
    // get last operation that is done by this user from operataion array.
    xxxDocOperation *op;
    
    // count the total number of undo operation, so we don't get the same operation to undo every time.
    // get global -1, get undo +1.
    int undoCounter = 0;
    
    for (int i = self.stackManager.globalStack.count - 1; i >= 0 ; i--) {
        op = [self.stackManager.globalStack objectAtIndex:i];
        // undo can only operate this user's operation.
        if (op.participantID == self.participantID && (op.state == GLOBAL || op.state == REDO)){
            undoCounter--;
        }
        else if (op.participantID == self.participantID && op.state == UNDO){
            undoCounter++;
        }
        
        if (undoCounter < 0){
            break;
        }
        op = nil;
    }
    
    // If no available operation, do nothing. TODO: user a more graceful response.
    if (op == nil){
        return;
    }
    
    [self undoOperation:op];
}

// Undo an operation, take an operation as input.
// The operation must exist in the stack.
- (void)undoOperation: (xxxDocOperation *) op
{
    xxxDocOperation* undOperation = [[xxxDocOperation alloc] init];
    NSRange newRange;
    newRange.location = op.range.location;
    newRange.length = op.replcaceString.length;
    undOperation.range = newRange;
    
    undOperation.originalString = op.replcaceString;
    undOperation.replcaceString = op.originalString;
    undOperation.state = UNDO;
    
    undOperation.referID = op.globalID;
    undOperation.participantID = self.participantID;
    
    [[xxxDocStackManager getStackManager].undoStack addObject:undOperation];
}


- (void)redoAct: (UIButton *)redoButton
{
    // get last operation that is done by this user from operataion array.
    xxxDocOperation *op;
    
    // count the total number of redo operation, so we don't get the same operation to redo every time.
    // get global -1, get redo +1.
    int redoCounter = 0;
    
    for (int i = self.stackManager.globalStack.count - 1; i >= 0 ; i--) {
        op = [self.stackManager.globalStack objectAtIndex:i];
        // undo can only operate this user's operation.
        if (op.participantID == self.participantID && op.state == REDO){
            redoCounter--;
        }
        else if (op.participantID == self.participantID && op.state == UNDO){
            redoCounter++;
        }
        
        if (redoCounter > 0){
            break;
        }
        op = nil;
    }
    
    // If no available operation, do nothing. TODO: use a more graceful response.
    if (op == nil){
        return;
    }
        
    [self redoOperation:op];
}

// Take an operation as input, redo the operation, the operation must have been done before (exist in the stack)
- (void)redoOperation:(xxxDocOperation *)op
{
    xxxDocOperation* redoOperation = [[xxxDocOperation alloc] init];
    NSRange newRange;
    newRange.location = op.range.location;
    newRange.length = op.replcaceString.length;
    redoOperation.range = newRange;
    
    redoOperation.originalString = op.replcaceString;
    redoOperation.replcaceString = op.originalString;
    redoOperation.state = REDO;
    
    redoOperation.referID = op.globalID;
    redoOperation.participantID = self.participantID;
    
    [[xxxDocStackManager getStackManager].redoStack addObject:redoOperation];
}


// creat an Change Set which contains all local operation user have made.
// Mark the operation state as sended.
- (xxxDocChangeSet*) getLocalChangeSet
{
    xxxDocChangeSet* result = [[xxxDocChangeSet alloc] init];
    
    result.cursorLocation = self.inputTextView.selectedRange.location;
    result.startGlobalID = self.recentGlobalID;
    result.operationArray = [self.stackManager getLocalOperations];
    
    return result;
}

- (xxxDocChangeSet*) getUndoAndRedoChangeSet
{
    xxxDocChangeSet* result = [[xxxDocChangeSet alloc] init];
    
    result.cursorLocation = self.inputTextView.selectedRange.location;
    result.startGlobalID = self.recentGlobalID;
    
    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:[self.stackManager getUndoOperations]];
    [tempArray addObjectsFromArray:[self.stackManager getRedoOperations]];
    result.operationArray = tempArray;
    return result;
}

// get the change set and broadcast to all user.
- (void) updateChangeSetToAllUser
{
    xxxDocChangeSet* localChangeSet = [self getLocalChangeSet];
    if (localChangeSet.operationArray.count != 0){
        int submissionID = [self.clientWorker broadcastChangeSet:localChangeSet];
        // If the data if successfully send, move them into send stack, otherwise return them to local stack.
        // TODO: verify atomic here.
        if (submissionID == -1){
            [self.stackManager addChangeSetToLocal:localChangeSet];
        }
        else{
            // mark the operations as SEND, then place them to send stack.
            for (xxxDocOperation *op in localChangeSet.operationArray) {
                op.state = SEND;
            }
            // put the operations into SEND stack.
            [self.stackManager.sendStack addObjectsFromArray:localChangeSet.operationArray];
        }
    }
    
    xxxDocChangeSet* undoAndRedoChangeSet = [self getUndoAndRedoChangeSet];
    if (undoAndRedoChangeSet.operationArray.count != 0){
        int submissionID = [self.clientWorker broadcastChangeSet:undoAndRedoChangeSet];
        // If the data if not successfully send, return them to undo and redo stack.
        if (submissionID == -1){
            [self.stackManager addChangeSetToUndoAndRedo:undoAndRedoChangeSet];
        }
    }
}

#pragma mark UITextViewDelegate Protocol Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.length > 1 || text.length > 1)
    {
        return NO;
    }
    
    // 1. Create operation.
    xxxDocOperation* operation = [[xxxDocOperation alloc] init];
    
    // 2. Add replacement info into operation.
    operation.range = range;
    operation.participantID = self.participantID;
    operation.replcaceString = text;
    operation.originalString = [textView.text substringWithRange:range];
    operation.state = LOCAL;
    
    // 3. put operation into operation array.
    [self.stackManager.localStack addObject:operation];
    
    /* TODO: test code */
    if (text.length == 0){
        NSLog(@"Delete: %@", [textView.text substringWithRange:range]);
    }
    else if (range.length == 0){
        NSLog(@"Insert: %@", text);
    }
    else{
        NSLog(@"replace %@ by %@",[textView.text substringWithRange:range],text);
    }
    
    return YES;
}


@end
