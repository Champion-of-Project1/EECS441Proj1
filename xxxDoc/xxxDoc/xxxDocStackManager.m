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
    NSArray* result = [self.localStack copy];
    
    // create new stack.
    self.localStack = [[NSMutableArray alloc] init];
    
    xxxDocOperation *referOperation = self.globalStack.lastObject;
    // update the operation down to the global ID it refers to
    for (int j = result.count - 1; j > -1; j--) {
        xxxDocOperation *op = [result objectAtIndex:j];
        
        // get original index.
        int startIndex = op.range.location;
        int endIndex = op.range.location + op.range.length;
        
        // update the operation in local stack.
        for (int i = j - 1; i > -1; i--) {
            xxxDocOperation *tempOperation = [result objectAtIndex:i];
            startIndex = [self updateIndex:startIndex
                           BeforeOperation:tempOperation
                                  authorID:op.participantID];
            endIndex = [self updateIndex:endIndex
                         BeforeOperation:tempOperation
                                authorID:op.participantID];
        }
        
        // update the operation in the SEND stack.
        for (int i = self.sendStack.count - 1; i > -1; i--) {
            xxxDocOperation *tempOperation = [self.sendStack objectAtIndex:i];
            startIndex = [self updateIndex:startIndex
                           BeforeOperation:tempOperation
                                  authorID:op.participantID];
            endIndex = [self updateIndex:endIndex
                         BeforeOperation:tempOperation
                                authorID:op.participantID];
        }
        // since we refer to the last operation, there's no need to update the global stack.
        
        NSRange newRnage;
        newRnage.location = startIndex;
        newRnage.length = endIndex - startIndex;
        
        op.range = newRnage;
        op.referID = referOperation.globalID;
        // If this is the first event, use -1 as referID.
        if (referOperation == nil){
            op.referID = -1;
        }
    }

    return result;
}

// If op is happend before the index inserted. we need to update the index.
- (int) updateIndex:(int) index
    BeforeOperation:(xxxDocOperation*) op
           authorID: (int64_t) participantID;
{
    if (op.range.location > index){
        // If the change happen after this index, no need to do anything.
        return index;
    }
    else if (op.range.location + op.replcaceString.length < index){
        // If the index is not within the replace range
        return index - op.replcaceString.length + op.originalString.length;
    }
    else{
        // If the index is within the range of change, set it to the location of range
        // This is what google doc does.
        if (op.participantID == participantID){
            return op.range.location + op.range.length;
        }
        else{
            return op.range.location;
        }
    }
}


#pragma mark add New Change Set methods

// Add an changeSet from collabrify client.
- (void) addNewChangeSet: (xxxDocChangeSet *)changeSet
                globalID: (int) globalID
{
    for (int i = 0; i < changeSet.operationArray.count; i++) {
        xxxDocOperation *op = [changeSet.operationArray objectAtIndex:i];
        
        // update operation state to global.
        op.state = GLOBAL;
        // Assign the order ID to each operation.
        op.globalID = globalID;
        
        // If this operation is done by me, update state.
        if (self.clientWorker.participantID == op.participantID){
            [self updateOperationFromSendToGlobal:op];
            // Add operation as new come.
            [self addNewGlobalOperation:op];
        }
        else{
            // If this operation is not done by me, add as new.
            [self addNewGlobalOperation:op];
            // update the UI
            dispatch_async(dispatch_get_main_queue(), ^{
                // replace the string, this is UI action, must be done in main thread.
                self.inputTextView.text = [self.inputTextView.text stringByReplacingCharactersInRange:op.range withString:op.replcaceString];
            });
        }
    }
}

// update the operation state from SEND to GLOBAL
- (void) updateOperationFromSendToGlobal: (xxxDocOperation *)operation
{
    // remove operation from send stack.
    for (xxxDocOperation *op in self.sendStack) {
        if (op.operationID == operation.operationID && op.state == SEND){
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
    
    // update up through send stack.
    for (int i = 0; i < self.sendStack.count; i++) {
        xxxDocOperation *op = [self.sendStack objectAtIndex:i];
        
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
    
    // update up through local stack,
    for (int i = 0; i < self.localStack.count; i++) {
        xxxDocOperation *op = [self.localStack objectAtIndex:i];
        
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
    
    // replace the range and insert the operation.
    NSRange newRange;
    newRange.location = startIndex;
    newRange.length = endIndex - startIndex;
    operation.range = newRange;
    
    [self.globalStack addObject:operation];
}

// If op is happend before the index inserted. we need to update the index.
- (int) updateIndex:(int) index
     AfterOperation:(xxxDocOperation*) op
           authorID:(int64_t) participantID
{
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
        if (op.participantID == participantID){
            return op.range.location + op.replcaceString.length;
        }
        else{
            return op.range.location;
        }
    }
}
@end
