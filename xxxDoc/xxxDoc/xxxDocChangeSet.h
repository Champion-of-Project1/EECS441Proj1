//
//  xxxDocChangeSet.h
//  xxxDoc
//
//  Created by chenditc on 9/12/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xxxDocChangeSet : NSObject

// Array store the operation in this set of changes. sort by the modified time.
@property (strong, nonatomic) NSArray *operationArray;

// The cursor location of the user who send this change set.
// This integer refers to the index of the left charactor + 1.
// If the cursor is at the starting point, set to 0;
@property int cursorLocation;

// The ID of the operation that would start
@property int startGlobalID;

@end
