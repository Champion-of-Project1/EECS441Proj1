//
//  xxxDocOperation.m
//  xxxDoc
//
//  Created by chenditc on 9/12/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import "xxxDocOperation.h"

@implementation xxxDocOperation

@synthesize originalString = _originalString;
@synthesize replcaceString = _replcaceString;
@synthesize range = _range;
@synthesize state = _state;
@synthesize participantID = _participantID;
@synthesize operationID = _operationID;

static int nextID = 0;
 
- (NSString *) originalString
{
    if (_originalString == nil){
        _originalString = @"";
    }
    return _originalString;
}

- (NSString *) replcaceString
{
    if (_replcaceString == nil){
        _replcaceString = @"";
    }
    return _replcaceString;
}

- (xxxDocOperation *) init
{
    self = [super init];
    // get a unique operation ID
    self.state = LOCAL;
    self.operationID = [self.class getOperationID];
    
    return self;
}

- (xxxDocOperation *) initWithNoOperationID
{
    self = [super init];
    // get a unique operation ID
    self.state = LOCAL;
    self.globalID = -1;
    self.referID = -1;
    
    return self;
}

- (xxxDocOperation *) initWithOperation: (xxxDocOperation*) operation
{
    self = [super init];

    // copy the operation.
    self.range = operation.range;
    self.originalString = operation.originalString;
    self.replcaceString = operation.replcaceString;
    self.state = operation.state;
    self.operationID = operation.operationID;
    self.globalID = operation.globalID;
    self.referID = operation.referID;
    self.participantID = operation.participantID;
    
    return self;
}

// Get an globally unique operation ID
+ (int) getOperationID
{
    return nextID++;
}
   
@end
