//
//  xxxDocCollabrifyWorker.m
//  xxxDoc
//
//  Created by chenditc on 9/12/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import "xxxDocCollabrifyWorker.h"

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
                                                  getLatestEvent:TRUE
                                                           error:&error]];
        [self setTags:@[@"TAG_Chenditc"]];
        [[self client] setDelegate:self];
        [[self client] setDataSource:self];
    }
    return self;
}

- (int64_t) createSession
{
    [[self client] createSessionWithBaseFileWithName:@"chenditcTestSession"
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

- (int32_t) joinSessionWithSessionID: (int64_t)sessionID
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
                       }
                   }];
}

- (void) client:(CollabrifyClient *)client receivedBaseFileChunk:(NSData *)data
{
    if (data == nil) {
        NSLog(@"NIL data");
    } else {
        NSLog(@"Data = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
}

@end
