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
@synthesize sessionID = _sessionID;
@synthesize operationID = _operationID;

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
    
    
    return self;
}
   
@end
