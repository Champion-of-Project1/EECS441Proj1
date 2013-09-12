//
//  xxxDocOperation.h
//  xxxDoc
//
//  Created by chenditc on 9/12/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOCAL   0
#define SEND    1
#define GLOBAL  2

@interface xxxDocOperation : NSObject

// The range of text that need to be replaced.
@property NSRange range;

// The text to put on the replacement range.
@property NSString *replcaceString;

// Indicate the state of this operation.
// It could be: LOCAL, SEND, GLOBAL
@property int state;

// The unique identifier of operation.
// The format: 
@property int operationID;

@end
