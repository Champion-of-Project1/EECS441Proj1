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

@interface xxxDocViewController ()

// Array store all operation done by all user, both global and local
@property (strong, nonatomic) NSMutableArray *operationArray;

// The stack store the operation that can be redo.
// Clear the stack once user have new input.
@property (strong, nonatomic) NSMutableArray *redoStack;

// The index of the last global operation.
@property (strong, nonatomic) NSNumber *globalOperationNumber;

// The user's session ID
@property (nonatomic) int64_t participantID;

// The user's input view.
@property (weak, nonatomic) UITextView *inputTextView;

// NOT SURE
@property (strong, nonatomic) NSString *selectedText;

@end

@implementation xxxDocViewController

@synthesize operationArray = _operationArray;
@synthesize globalOperationNumber = _globalOperationNumber;
@synthesize selectedText = _selectedText;

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
    
    UIButton *undoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *redoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [undoButton addTarget:self action:@selector(undoAct:) forControlEvents:UIControlEventTouchDown];
    [redoButton addTarget:self action:@selector(redoAct:) forControlEvents:UIControlEventTouchDown];
    

    [undoButton setTitle:@"undo" forState:UIControlStateNormal];
    [undoButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [redoButton setTitle:@"redo" forState:UIControlStateNormal];
    [redoButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [undoButton setFrame:CGRectMake(width / 2 + buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    [redoButton setFrame:CGRectMake(width / 4 * 3 + buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    
    [buttonView addSubview:undoButton];
    [buttonView addSubview:redoButton];
    [self.view addSubview:buttonView];
    
    double textViewOffset = 10.f;
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0.f, buttonViewHeight + textViewOffset, width, height - buttonViewHeight - textViewOffset)];
    textView.delegate = self;
    self.inputTextView = textView;
    [self.view addSubview:textView];
    
    // TODO: test code.
    self.participantID = [xxxDocCollabrifyWorker getCollabrifyClient].participantID;
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
    for (int i = self.globalOperationNumber.intValue - 1; i >= 0 ; i--) {
        op = [self.operationArray objectAtIndex:i];
        if (op.participantID == self.participantID && op.state == GLOBAL){
            break;
        }
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

// Add an operation to operation stack and make sure the consistency
- (void) addOperationToOperationArray: (xxxDocOperation*)operation
{
    // TODO: test code, should not change to global
    if (self.operationArray.count < 10)     operation.state = GLOBAL;
    
    [self.operationArray addObject:operation];
    
    // TODO: test code. Update global counter.
    // Broadcast all events.
    self.globalOperationNumber = [NSNumber numberWithInt: self.globalOperationNumber.intValue + 1];
}

#pragma mark UITextViewDelegate Protocol Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 1. Create operation.
    xxxDocOperation* operation = [[xxxDocOperation alloc] init];
    
    // 2. Add replacement info into operation.
    operation.range = range;
    operation.participantID = self.participantID;
    operation.replcaceString = text;
    operation.originalString = [textView.text substringWithRange:range];
    operation.state = LOCAL;
    
    // 3. put operation into operation array.
    [self addOperationToOperationArray:operation];
    
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
