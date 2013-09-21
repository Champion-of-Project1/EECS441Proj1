//
//  xxxDocCollabrifyWorker.m
//  xxxDoc
//
//  Created by chenditc on 9/12/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import "xxxDocCollabrifyWorker.h"
#import "xxxDocBufferWorker.h"
#import "xxxDocStackManager.h"
#import "xxxDocOperation.h"

@interface xxxDocCollabrifyWorker () < CollabrifyClientDelegate, CollabrifyClientDataSource >

// Tags used for reference
@property (strong, nonatomic) NSArray *tags;

// The CollabrifyClient object
@property (strong, nonatomic) CollabrifyClient *client;
// Data for base file
@property (strong, nonatomic) NSData *data;

@end

@implementation xxxDocCollabrifyWorker

@synthesize sessionID = _sessionID;
@synthesize participantID = _participantID;
@synthesize tags = _tags;
@synthesize client = _client;
@synthesize data = _data;

- (int64_t) participantID
{
    return self.client.participantID;
}

//- (CollabrifyClient *) getCollabrifyClient
- (id)init
{
    self = [super init];
    if (self){
        NSError *error;
        [self setClient: [[CollabrifyClient alloc] initWithGmail:@"eecs441chenditc@gmail.com"
                                                     displayName:@"chen di"
                                                    accountGmail:@"441fall2013@umich.edu"
                                                     accessToken:@"XY3721425NoScOpE"
                                                  getLatestEvent:NO
                                                           error:&error]];
        [self setTags:@[@"TAG_Chenditc"]];
        [[self client] setDelegate:self];
        [[self client] setDataSource:self];
    }
    return self;
}

- (int64_t) createSession
{
    
    [[self client] createSessionWithBaseFileWithName:@"chenditcTestSession2"
                                                tags:self.tags
                                            password:nil
                                         startPaused:NO
                                   completionHandler:^(int64_t sessionID, CollabrifyError *error) {
                                       if (error)
                                       {
                                           NSLog(@"Error class = %@", [error class]);
                                           NSLog(@"Create Session Error = %@, %@, %@", error, [error domain], [error localizedDescription]);
                                       } else {
                                           _sessionID = sessionID;
                                           NSLog(@"Session ID = %lli", sessionID);
                                           NSLog(@"Session is protected = %i", [[self client] currentSessionIsPasswordProtected]);
                                       }
                                   }];


    return _sessionID;
}

- (NSData *)client:(CollabrifyClient *)client requestsBaseFileChunkForCurrentBaseFileSize:(NSInteger)baseFileSize
{
    if (![self data])
    {
        NSString *string = @"Initial Data";
        [self setData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSInteger length = [[self data] length] - baseFileSize;
    if (length == 0)
        return nil;
    return [NSData dataWithBytes:([[self data] bytes] + baseFileSize) length:length];
}

- (void) listSessions
{
    [[self client] listSessionsWithTags:[self tags]
                      completionHandler:^(NSArray *sessionList, CollabrifyError *error) {
                          NSLog(@"Available session: \n");
                          for (CollabrifySession *session in sessionList) {
                              NSLog(@"%@\n", session.sessionName);
                          }
                      }
     ];
}

- (void) joinSessionWithSessionID: (int64_t)sessionID
{
    [[self client] joinSessionWithID:sessionID
                            password:nil
                   completionHandler:^(int64_t maxOrderID, int32_t baseFileSize, CollabrifyError *error) {
                       if (error) {
                           NSLog(@"Error class = %@", [error class]);
                           NSLog(@"Create Session Error = %@, %@, %@", error, [error domain], [error localizedDescription]);
                       } else {
                           _sessionID = sessionID;
                           NSLog(@"Session ID = %lli", sessionID);
                           NSLog(@"Session is protected = %i", [[self client] currentSessionIsPasswordProtected]);
                           
                           int submissionID = [self.client broadcast:[@"test bc" dataUsingEncoding:NSUTF8StringEncoding] eventType:nil];
                           NSLog(@"%u",submissionID);
                       }
                   }];
}

/**
 * Called when the a chunk of base file is received or when all of the chunks have been received
 * When all data has been received, data is nil
 *
 * This method is not called on the main thread
 */
- (void) client:(CollabrifyClient *)client receivedBaseFileChunk:(NSData *)data
{
    if (data == nil) {
        NSLog(@"NIL data");
    } else {
        NSLog(@"Data = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
}

- (void)client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data
{
    // reassemble the data.
    xxxDocBufferWorker *bufferWorker = [[xxxDocBufferWorker alloc] init];
    xxxDocChangeSet *changeSet = [bufferWorker getChangeSetFromNSData:data];
    
    if (changeSet.operationArray.count != 0){
        NSLog(@"get %u operations from order ID:,%llu",changeSet.operationArray.count, orderID);
        [[xxxDocStackManager getStackManager] addNewChangeSet:changeSet globalID:orderID];
    }

}

- (int) broadcastChangeSet:(xxxDocChangeSet *)changeSet
{
    // Translate the change set.
    xxxDocBufferWorker *bufferWorker = [[xxxDocBufferWorker alloc] init];
    NSData *changeSetData = [bufferWorker getDataFromChangeSet:changeSet];
    
    // send the data.
    int64_t submissionID = [self.client broadcast:changeSetData eventType:nil];
    
    NSLog(@"broad cast finish");
    return submissionID;
}

@end
