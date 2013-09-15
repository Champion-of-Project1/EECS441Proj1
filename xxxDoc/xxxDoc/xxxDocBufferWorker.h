//
//  xxxDocBufferWorker.h
//  xxxDoc
//
//  Created by chenditc on 9/12/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "xxxDocChangeSet.h"

@interface xxxDocBufferWorker : NSObject

- (NSData *) getDataFromChangeSet: (xxxDocChangeSet *) changeSet;
- (xxxDocChangeSet *) getChangeSetFromNSData: (NSData *) inputData;

@end
