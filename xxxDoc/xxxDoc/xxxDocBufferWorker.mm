//
//  xxxDocBufferWorker.mm
//  xxxDoc
//
//  Created by chenditc on 9/12/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import "xxxDocBufferWorker.h"
#import "xxxDocOperation.h"
#include "changeSet.pb.h"

@implementation xxxDocBufferWorker

- (NSData *) getDataFromChangeSet: (xxxDocChangeSet *) changeSet
{
    NSData *result;
    
    xxxDoc::ChangeSet *bufferObject = new xxxDoc::ChangeSet();
    bufferObject->set_cursor_location(changeSet.cursorLocation);
    bufferObject->set_startoperation_id(changeSet.startOperationID);
    
    // Add all operations
    for (xxxDocOperation *op in changeSet.operationArray) {
        xxxDoc::Operation *operationBufferObject = bufferObject->add_operations();

        std::string originalCStr = [op.originalString cStringUsingEncoding:[NSString defaultCStringEncoding]];
        std::string replaceCStr = [op.replcaceString cStringUsingEncoding:[NSString defaultCStringEncoding]];
        xxxDoc::NSRange range;
        range.set_length(op.range.length);
        range.set_location(op.range.location);
        
        operationBufferObject->set_allocated_original_string(&originalCStr);
        operationBufferObject->set_allocated_replace_string(&replaceCStr);
        operationBufferObject->set_allocated_range(&range);
    }
    
    // Serialize as NSData
    std::string stringFormat = bufferObject->SerializeAsString();
    result = [NSData dataWithBytes:stringFormat.c_str() length:stringFormat.size()];
    
    free(bufferObject);
    
    return result;
}

- (xxxDocChangeSet *) getChangeSetFromNSData: (NSData *) inputData
{
    xxxDocChangeSet *result = [[xxxDocChangeSet alloc] init];
    
    xxxDoc::ChangeSet *bufferObject = new xxxDoc::ChangeSet();
    bufferObject->ParseFromArray([inputData bytes], [inputData length]);
    
    result.cursorLocation = bufferObject->cursor_location();
    result.startOperationID = bufferObject->startoperation_id();
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < bufferObject->operations_size(); i++) {
        xxxDoc::Operation op = bufferObject->operations(i);
        xxxDocOperation *operation = [[xxxDocOperation alloc] init];
        
        // get range object.
        NSRange tempRange;
        xxxDoc::NSRange inputRange = op.range();
        tempRange.length = inputRange.length();
        tempRange.location = inputRange.location();
        
        // Get operation object
        operation.range = tempRange;
        operation.originalString = [NSString stringWithCString:op.original_string().c_str() encoding:[NSString defaultCStringEncoding]];
        operation.replcaceString = [NSString stringWithCString:op.replace_string().c_str() encoding:[NSString defaultCStringEncoding]];
        operation.state = op.state();
        operation.operationID = op.operation_id();
        operation.participantID = operation.participantID;
        
        // Put operation object into array.
        [tempArray addObject:operation];
    }
    result.operationArray = [tempArray copy];

    return result;
}



@end
