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
#define UNDO    3

@interface xxxDocOperation : NSObject

// The range of text that need to be replaced.
@property (nonatomic) NSRange range;

// The original String content, save for undo use
@property (strong, nonatomic) NSString *originalString;

// The text to put on the replacement range.
@property (strong, nonatomic) NSString *replcaceString;

// Indicate the state of this operation.
// It could be: LOCAL, SEND, GLOBAL
@property (nonatomic) int state;

// The local unique identifier of operation.
@property (nonatomic) int operationID;

// The global unique ID for change set.
@property (nonatomic) int globalID;

// The global ID this operation refers to.
@property (nonatomic) int referID;

// The ID of the user who make this operation.
// -1 means not assigned.
@property (nonatomic) int64_t participantID;

// initialize an operation but no set the operationID
- (xxxDocOperation *) initWithNoOperationID;

// Get an globally unique ID
+ (int) getOperationID;

@end
