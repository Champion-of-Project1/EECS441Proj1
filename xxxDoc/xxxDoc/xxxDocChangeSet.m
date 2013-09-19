//
//  xxxDocChangeSet.m
//  xxxDoc
//
//  Created by chenditc on 9/12/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import "xxxDocChangeSet.h"

@implementation xxxDocChangeSet

@synthesize startGlobalID = _startGlobalID;
@synthesize operationArray = _operationArray;
@synthesize cursorLocation = _cursorLocation;

- (NSArray *) operationArray
{
    if (_operationArray == nil){
        _operationArray = [[NSArray alloc] init];
    }
    return _operationArray;
}

@end
