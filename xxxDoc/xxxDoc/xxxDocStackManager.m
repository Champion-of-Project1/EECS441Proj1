//
//  xxxDocStackManager.m
//  xxxDoc
//
//  Created by chenditc on 9/17/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import "xxxDocStackManager.h"
#import "xxxDocOperation.h"

@interface xxxDocStackManager()


@end

@implementation xxxDocStackManager

static xxxDocStackManager* stackManager;
dispatch_queue_t queue = nil;

@synthesize globalStack = _globalStack;
@synthesize sendStack = _sendStack;
@synthesize localStack = _localStack;
@synthesize redoStack = _redoStack;



+ (xxxDocStackManager *) getStackManager
{
    if (stackManager == nil){
        stackManager = [[xxxDocStackManager alloc] init];
    }
    return stackManager;
}

- (dispatch_queue_t) queue
{
    if (queue == nil){
        queue = dispatch_queue_create("com.xxxDoc.stackQueue", NULL);
    }
    return queue;
}

- (NSMutableArray*) globalStack;
{
    if (_globalStack == nil) {
        _globalStack = [[NSMutableArray alloc] init];
    }
    return _globalStack;
}

- (NSMutableArray*) sendStack
{
    if (_sendStack == nil){
        _sendStack = [[NSMutableArray alloc] init];
    }
    return _sendStack;
}

- (NSMutableArray*) localStack
{
    if (_localStack == nil){
        _localStack = [[NSMutableArray alloc] init];
    }
    return _localStack;
}

- (void) setLocalStack:(NSMutableArray *)localStack
{
    _localStack = localStack;
}

- (NSMutableArray*) redoStack
{
    if (_redoStack == nil) {
        _redoStack = [[NSMutableArray alloc] init];
    }
    return _redoStack;
}

#pragma mark get Local Change Set methods

// return the local operations, clear the local stack.
- (NSArray*) getLocalOperations
{
    NSArray* result = self.localStack;
    
    // atomic create new stack.
    self.localStack = [[NSMutableArray alloc] init];
    
    xxxDocOperation *referOperation = self.globalStack.lastObject;
    // update the operation's global ID it refers to
    for (xxxDocOperation *op in result) {
        op.referID = referOperation.globalID;
        // If this is the first event, use -1 as referID.
        if (referOperation == nil){
            op.referID = -1;
        }
    }

    return result;
}

#pragma mark add local change set methods
- (void) addChangeSetToLocal: (xxxDocChangeSet*) changeSet
{
    dispatch_async(queue, ^{
        NSMutableArray* tempArray = [changeSet.operationArray mutableCopy];
        [tempArray addObjectsFromArray:self.localStack];
        self.localStack = tempArray;
    });
}



#pragma mark add New Change Set methods

// Add an changeSet from collabrify client.
- (void) addNewChangeSet: (xxxDocChangeSet *)changeSet
                globalID: (int) globalID
{
    dispatch_async(self.queue, ^{
        for (int i = 0; i < changeSet.operationArray.count; i++) {
            xxxDocOperation *op = [changeSet.operationArray objectAtIndex:i];
            
            // update operation state to global.
            op.state = GLOBAL;
            // Assign the order ID to each operation.
            op.globalID = globalID;
            
            // If this operation is done by me, update state.
            if (self.clientWorker.participantID == op.participantID){
                [self updateOperationFromSendToGlobal:op];
            }
            else{
                // If this operation is not done by me, add as new.
                [self addNewGlobalOperation:op];
            }
        }
    });
}

// update the operation state from SEND to GLOBAL
- (void) updateOperationFromSendToGlobal: (xxxDocOperation *)operation
{
    // remove operation from send stack.
    for (xxxDocOperation *op in self.sendStack) {
        if (op.operationID == operation.operationID && op.state == SEND){
            op.globalID = operation.globalID;
            op.state = operation.state;
            [self.globalStack addObject:op];
            [self.sendStack removeObject:op];
            break;
        }
    }
}

// Add a new global operation to stack.
- (void) addNewGlobalOperation: (xxxDocOperation *)operation
{
    // Add object to global stack.
    int startIndex = operation.range.location;
    int endIndex = operation.range.location + operation.range.length;
    // update each operation up stack.
    BOOL getOp = false;
    
    // update up through global stack
    for (int i = 0; i < self.globalStack.count; i++) {
        xxxDocOperation *op = [self.globalStack objectAtIndex:i];
        // Operation could be not accurate at this time, so get an updated Operation to count new index.
        // for example: insert 1,2,3,4. insert 2,3,4,5.
        //              in this case, insert 2,3,4,5 should be updated to insert 6,7,8,9
        op = [self updateOperation:op ThroughGlobalStackFromIndex:i];
        
        if (operation.referID == op.globalID){
            getOp = true;
            continue;
        }
        
        // already get the refer place or refer to ground
        if (getOp || operation.referID == -1){
            // Modify the range according to the change set.
            startIndex = [self updateIndex:startIndex
                            AfterOperation:op
                                  authorID:operation.participantID];
            endIndex = [self updateIndex:endIndex
                          AfterOperation:op
                                authorID:operation.participantID];
        }
    }
    
    NSRange newRange;
    newRange.location = startIndex;
    newRange.length = endIndex - startIndex;
    operation.range = newRange;
    // Add to global stack, since it's the accurate operation if happen at that order in global stack.
    [self.globalStack addObject:operation];
    
    // Get the accurate operation taking send and local stack into account.
    // update up through send stack.
    for (int i = 0; i < self.sendStack.count; i++) {
        xxxDocOperation *op = [self.sendStack objectAtIndex:i];
        
        // Modify the range according to the change set.
        startIndex = [self updateIndex:startIndex
                        AfterOperationV2:op
                              authorID:operation.participantID];
        endIndex = [self updateIndex:endIndex
                      AfterOperationV2:op
                            authorID:operation.participantID];
    }
    
    // update up through local stack,
    for (int i = 0; i < self.localStack.count; i++) {
        xxxDocOperation *op = [self.localStack objectAtIndex:i];

        // Modify the range according to the change set.
        startIndex = [self updateIndex:startIndex
                        AfterOperationV2:op
                              authorID:operation.participantID];
        endIndex = [self updateIndex:endIndex
                      AfterOperationV2:op
                            authorID:operation.participantID];
    }
    
    // replace the range and insert the operation.
    newRange.location = startIndex;
    newRange.length = endIndex - startIndex;
    xxxDocOperation *tempOperation = [[xxxDocOperation alloc] initWithOperation:operation];
    tempOperation.range = newRange;
    [self updateLocalStackAndSendStackWithOperation:tempOperation];
    [self updateInputViewForOperation:tempOperation];
}

// update the UI
- (void) updateInputViewForOperation:(xxxDocOperation*) operation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // replace the string, this is UI action, must be done in main thread.
        NSLog(@"replace range:%u,%u with %@",operation.range.location, operation.range.length,operation.replcaceString);
        // remember the cursor location.
        NSRange tempRange = self.inputTextView.selectedRange;
        self.inputTextView.text = [self.inputTextView.text stringByReplacingCharactersInRange:operation.range withString:operation.replcaceString];
        
        // update cursor place.
        int startIndex = tempRange.location;
        int endIndex = tempRange.location + tempRange.length;
        startIndex = [self updateIndex:startIndex
                      AfterOperation:operation
                              authorID:-1];
        endIndex = [self updateIndex:endIndex
                    AfterOperation:operation
                            authorID:-1];
        tempRange.location = startIndex;
        tempRange.length = endIndex - startIndex;
        // set the cursor location back.
        self.inputTextView.selectedRange = tempRange;
    });
}

// get the accurate opertion if there's operation cross refer,
- (xxxDocOperation*) updateOperation:(xxxDocOperation*) operation
         ThroughGlobalStackFromIndex: (int) index
{
    xxxDocOperation* tempOperation = [[xxxDocOperation alloc] initWithOperation:operation];
    
    int startIndex = operation.range.location;
    int endIndex = operation.range.location + operation.range.length;
    for (int i = index + 1; i < self.globalStack.count; i++) {
        xxxDocOperation *op = [self.globalStack objectAtIndex:i];
        
        // Modify the range according to the change set.
        startIndex = [self updateIndex:startIndex
                        AfterOperation:op
                              authorID:operation.participantID];
        endIndex = [self updateIndex:endIndex
                      AfterOperation:op
                            authorID:operation.participantID];
    }
    NSRange newRange;
    newRange.location = startIndex;
    newRange.length = endIndex - startIndex;
    operation.range = newRange;

    return tempOperation;
}

// When a new global operation is added to the global stack, the range in local stack and send stack is not available.
// So we should update them.
- (void) updateLocalStackAndSendStackWithOperation: (xxxDocOperation *) operation
{
    // update up through send stack.
    for (int i = 0; i < self.sendStack.count; i++) {
        xxxDocOperation *op = [self.sendStack objectAtIndex:i];
        int startIndex = op.range.location;
        int endIndex = op.range.location + op.range.length;
        // Modify the range according to the change set.
        startIndex = [self updateIndex:startIndex
                        AfterOperation:operation
                              authorID:op.participantID];
        endIndex = [self updateIndex:endIndex
                      AfterOperation:operation
                            authorID:op.participantID];
        NSRange newRange;
        newRange.location = startIndex;
        newRange.length = endIndex - startIndex;
        op.range = newRange;
    }
    
    // update up through local stack,
    for (int i = 0; i < self.localStack.count; i++) {
        xxxDocOperation *op = [self.localStack objectAtIndex:i];
        int startIndex = op.range.location;
        int endIndex = op.range.location + op.range.length;
        // Modify the range according to the change set.
        startIndex = [self updateIndex:startIndex
                        AfterOperation:operation
                              authorID:op.participantID];
        endIndex = [self updateIndex:endIndex
                      AfterOperation:operation
                            authorID:op.participantID];
        NSRange newRange;
        newRange.location = startIndex;
        newRange.length = endIndex - startIndex;
        op.range = newRange;
    }
}

// If op is happend before the index inserted. we need to update the index.
- (int) updateIndex:(int) index
     AfterOperation:(xxxDocOperation*) op
           authorID:(int64_t) participantID
{
    // not update user's operation, already included.
    if (op.participantID == participantID){
        return index;
    }
    
    if (op.range.location > index){
        // If the change happen after this index, no need to do anything.
        return index;
    }
    else if (op.range.location + op.range.length < index){
        // If the index is not within the replace range
        return index + op.replcaceString.length - op.originalString.length;
    }
    else{
        // If the index is within the range of change, set it to the location of range
        // This is what google doc does.
        // If the author is the same, set to the end of replaced string.
        return op.range.location;

    }
}

// version 2 of update, use for send and local stack. Since this two stack's change already show on the UI.
// If op is happend before the index inserted. we need to update the index.
- (int) updateIndex:(int) index
     AfterOperationV2:(xxxDocOperation*) op
           authorID:(int64_t) participantID
{
    // not update user's operation, already included.
    if (op.participantID == participantID){
        return index;
    }
    
    if (op.range.location > index){
        // If the change happen after this index, no need to do anything.
        return index;
    }
    else if (op.range.location + op.range.length < index){
        // If the index is not within the replace range
        return index + op.replcaceString.length - op.originalString.length;
    }
    else{
        // If the index is within the range of change, set it to the location of range
        // This is what google doc does.
        // If the author is the same, set to the end of replaced string.
        return op.range.location + op.replcaceString.length;
        
    }
}
@end
