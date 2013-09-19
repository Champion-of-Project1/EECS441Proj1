//
//  xxxDocCollabrifyWorker.h
//  xxxDoc
//
//  Created by chenditc on 9/12/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Collabrify/Collabrify.h>
#import "xxxDocChangeSet.h"

@interface xxxDocCollabrifyWorker : NSObject

@property int64_t sessionID;

// unique identifier for the user in this session.
@property (nonatomic) int64_t participantID;

- (int64_t) createSession;

- (void) listSessions;

- (void) joinSessionWithSessionID: (int64_t)sessionID;

- (int) broadcastChangeSet:(xxxDocChangeSet *)changeSet;


@end
