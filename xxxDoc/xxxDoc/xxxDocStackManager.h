//
//  xxxDocStackManager.h
//  xxxDoc
//
//  Created by chenditc on 9/17/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "xxxDocChangeSet.h"
#import "xxxDocCollabrifyWorker.h"

@interface xxxDocStackManager : NSObject

// Singleton class, since we need to operate the same stacks from different view controller and class.
+ (xxxDocStackManager *) getStackManager;

// All operation must come from clientWorker
@property (strong, nonatomic) NSMutableArray *globalStack;

// The operations that wait for confirm.
@property (strong, nonatomic) NSMutableArray *sendStack;

// The local operations.
@property (strong, atomic) NSMutableArray *localStack;

// The stack that can redo.
@property (strong, nonatomic) NSMutableArray *redoStack;

// The stack that contains pending undo operation.
@property (strong, nonatomic) NSMutableArray *undoStack;

// text view delegate that need to update when new change set comes.
@property (weak, nonatomic) UITextView *inputTextView;

// shared collabrify worker.
@property (weak, nonatomic) xxxDocCollabrifyWorker *clientWorker;

- (void) addNewChangeSet: (xxxDocChangeSet *)changeSet
                globalID: (int) globalID;

- (NSArray*) getLocalOperations;

- (void) addChangeSetToLocal: (xxxDocChangeSet*) changeSet;

- (void) addChangeSetToUndoAndRedo: (xxxDocChangeSet*) changeSet;

- (NSArray*) getUndoOperations;


@end
