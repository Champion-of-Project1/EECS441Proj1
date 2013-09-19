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

// Array store all operation done by all user, both global and local
@property (strong, nonatomic) NSMutableArray *operationArray;

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

@synthesize operationArray = _operationArray;
@synthesize stackManager = _stackManager;
@synthesize recentGlobalID = _recentGlobalID;
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
    [[self clientWorker]joinSessionWithSessionID:(int64_t)2295005];
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
    for (int i = self.operationArray.count - 1; i >= 0 ; i--) {
        op = [self.operationArray objectAtIndex:i];
        if (op.participantID == self.participantID && op.state == GLOBAL){
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
// The operation will be mark as UNDO, but ot delete from stack.
- (void)undoOperation: (xxxDocOperation *) op
{
    // TODO: this should be done after the server confirmed, put into completion handler.
    // undo the operation.
    
    // Get the replace start and end point by translate the index.
    int startIndex = [self getLocalIndexByGlobalOperationID:op.operationID andGlobalIndex:op.range.location];
    int endIndex = [self getLocalIndexByGlobalOperationID:op.operationID andGlobalIndex:(op.range.location + op.replcaceString.length)];
    NSRange replaceRange;
    replaceRange.location = startIndex;
    replaceRange.length = endIndex - startIndex;
    // replace the string
    self.inputTextView.text = [self.inputTextView.text stringByReplacingCharactersInRange:replaceRange withString:op.originalString];
    
    // update the operation to redo stack, operation array and global counter
    [self.redoStack addObject:op];
    op.state = UNDO;
}


- (void)redoAct: (UIButton *)redoButton
{
    // get last operation that is done by this user from redo stack.
    xxxDocOperation *op;
    if (self.redoStack.count == 0){
        return;
    }
    else{
        op = [self.redoStack lastObject];
    }
    
    [self redoOperation:op];
}

// Take an operation as input, redo the operation, the operation must have been done before (exist in the stack)
- (void)redoOperation:(xxxDocOperation *)op
{
    // redo the operation.
    int startIndex = [self getLocalIndexByGlobalOperationID:op.operationID andGlobalIndex:op.range.location];
    int endIndex = [self getLocalIndexByGlobalOperationID:op.operationID andGlobalIndex:(op.range.location + op.range.length)];
    NSRange replaceRange;
    replaceRange.location = startIndex;
    replaceRange.length = endIndex - startIndex;
    // replace the string
    self.inputTextView.text = [self.inputTextView.text stringByReplacingCharactersInRange:replaceRange withString:op.replcaceString];
    
    // update the operation to redo stack, operation array and global counter
    [self.redoStack removeObject:op];
    op.state = GLOBAL;
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

// get the change set and broadcast to all user.
- (void) updateChangeSetToAllUser
{
    xxxDocChangeSet* changeSet = [self getLocalChangeSet];
    if (changeSet.operationArray.count != 0){
        [self.clientWorker broadcastChangeSet:changeSet];
    }
}

- (int) getLocalIndexByGlobalOperationID: (int) operationID
                          andGlobalIndex: (int) index
{
    // indicate if we find the operation or not.
    BOOL getOp = false;
    for (int i = 0; i < self.operationArray.count; i++) {
        xxxDocOperation* operation = [self.operationArray objectAtIndex:i];
        if (operation.operationID == operationID){
            getOp = true;
        }
        // If this operation is done after the operation we are looking for, and not the same one
        // Update the index
        // Igonore UNDO action.
        if (operation.state == UNDO){
            continue;
        }
        if (getOp && operation.operationID != operationID){
            if (operation.range.location > index){
                // If the change happen after this index, no need to do anything.
                continue;
            }
            else if (operation.range.location + operation.range.length < index){
                // If the index is not within the replace range
                index = index + operation.replcaceString.length - operation.originalString.length;
            }
            else{
                // If the index is within the range of change, set it to the location of range
                // This is what google doc does.
                index = operation.range.location;
            }
        }
    }
    
    
    return index;
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
