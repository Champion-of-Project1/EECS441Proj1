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

@interface xxxDocViewController ()

// Array store all operation done by all user, both global and local
@property (strong, nonatomic) NSMutableArray *operationArray;

// The stack store the operation that can be redo.
// Clear the stack once user have new input.
@property (strong, nonatomic) NSMutableArray *redoStack;

// The index of the last global operation.
@property (strong, nonatomic) NSNumber *globalOperationNumber;

// The user's session ID
@property (nonatomic) int sessionID;

// The user's input view.
@property (weak, nonatomic) UITextView *inputTextView;

@end

@implementation xxxDocViewController

@synthesize operationArray = _operationArray;
@synthesize globalOperationNumber = _globalOperationNumber;

- (NSMutableArray*) operationArray
{
    if (_operationArray == nil){
        _operationArray = [[NSMutableArray alloc] init];
    }
    return _operationArray;
}

- (NSMutableArray*) redoStack
{
    if (_redoStack == nil){
        _redoStack = [[NSMutableArray alloc] init];
    }
    return _redoStack;
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
    
    UIButton *replaceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *moveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *undoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *redoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [replaceButton addTarget:self action:@selector(replaceChars:) forControlEvents:UIControlEventTouchDown];
    [moveButton addTarget:self action:@selector(moveChars:) forControlEvents:UIControlEventTouchDown];
    [undoButton addTarget:self action:@selector(undoAct:) forControlEvents:UIControlEventTouchDown];
    [redoButton addTarget:self action:@selector(redoAct:) forControlEvents:UIControlEventTouchDown];
    
    [replaceButton setTitle:@"replace" forState:UIControlStateNormal];
    [replaceButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [moveButton setTitle:@"move" forState:UIControlStateNormal];
    [moveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [undoButton setTitle:@"undo" forState:UIControlStateNormal];
    [undoButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [redoButton setTitle:@"redo" forState:UIControlStateNormal];
    [redoButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [replaceButton setFrame:CGRectMake(buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    [moveButton setFrame:CGRectMake(width / 4 + buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    [undoButton setFrame:CGRectMake(width / 2 + buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    [redoButton setFrame:CGRectMake(width / 4 * 3 + buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    
    [buttonView addSubview:replaceButton];
    [buttonView addSubview:moveButton];
    [buttonView addSubview:undoButton];
    [buttonView addSubview:redoButton];
    [self.view addSubview:buttonView];
    
    double textViewOffset = 10.f;
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0.f, buttonViewHeight + textViewOffset, width, height - buttonViewHeight - textViewOffset)];
    textView.delegate = self;
    self.inputTextView = textView;
    [self.view addSubview:textView];
    
    // TODO: test code.
    self.sessionID = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)replaceChars: (UIButton *)replaceButton
{
    NSLog(@"Replace\n");
}

- (void)moveChars: (UIButton *)moveButton
{
    NSLog(@"Move\n");
}

- (void)undoAct: (UIButton *)undoButton
{
    // get last operation that is done by this user from operataion array.
    xxxDocOperation *op;
    for (int i = self.globalOperationNumber.intValue - 1; i >= 0 ; i--) {
        op = [self.operationArray objectAtIndex:i];
        // TODO: the state of op should be GLOBAL
        if (op.sessionID == self.sessionID && op.state != UNDO){
            break;
        }
    }
    
    // If no available operation, do nothing. TODO: user a more graceful response.
    if (op == nil){
        return;
    }
    
    // TODO: this should be done after the server confirmed, put into completion handler.
    // undo the operation.
    
    // Get the replace start and end point by translate the index.
    int startIndex = [self getLocalIndexByGlobalOperationID:op.operationID andGobalIndex:op.range.location];
    int endIndex = [self getLocalIndexByGlobalOperationID:op.operationID andGobalIndex:(op.range.location + op.replcaceString.length)];
    NSRange replaceRange;
    replaceRange.location = startIndex;
    replaceRange.length = endIndex - startIndex;
    // replace the string
    self.inputTextView.text = [self.inputTextView.text stringByReplacingCharactersInRange:replaceRange withString:op.originalString];
    
    // update the operation to redo stack, operation array and global counter
    [self.redoStack addObject:op];
    op.state = UNDO;
    self.globalOperationNumber = [NSNumber numberWithInt:(self.globalOperationNumber.intValue - 1)];
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
    
    // redo the operation.
    int startIndex = [self getLocalIndexByGlobalOperationID:op.operationID andGobalIndex:op.range.location];
    int endIndex = [self getLocalIndexByGlobalOperationID:op.operationID andGobalIndex:(op.range.location + op.range.length)];
    NSRange replaceRange;
    replaceRange.location = startIndex;
    replaceRange.length = endIndex - startIndex;
    // replace the string
    self.inputTextView.text = [self.inputTextView.text stringByReplacingCharactersInRange:replaceRange withString:op.replcaceString];

    // update the operation to redo stack, operation array and global counter
    [self.redoStack removeObject:op];
    op.state = LOCAL;
    self.globalOperationNumber = [NSNumber numberWithInt:(self.globalOperationNumber.intValue + 1)];
}


// creat an Change Set which contains all local operation user have made.
// Mark the operation state as sended.
- (xxxDocChangeSet*) getLocalChangeSet
{
    xxxDocChangeSet* result;
    
    return result;
}

// TODO: confirm a set of operation, detail to be determined.
- (void) confirmOperation
{


}

// apply a new change set to current operation array.
- (void) applyChangeSet: (xxxDocChangeSet*) newChangeSet
{
    
}

- (int) getLocalIndexByGlobalOperationID: (int) globalID
                           andGobalIndex: (int) index
{
    int result = 0;
    
    result = index;
    
    return result;
}


#pragma mark UITextViewDelegate Protocol Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 1. Create operation.
    xxxDocOperation* operation = [[xxxDocOperation alloc] init];
    
    // 2. Add replacement info into operation.
    operation.range = range;
    operation.replcaceString = text;
    operation.originalString = [textView.text substringWithRange:range];
    operation.state = LOCAL;
    
    // 3. put operation into operation array.
    [self.operationArray addObject:operation];
    
    // TODO: test code. Update global counter.
    // Broadcast all events.
    self.globalOperationNumber = [NSNumber numberWithInt: self.globalOperationNumber.intValue + 1];
    
    
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
