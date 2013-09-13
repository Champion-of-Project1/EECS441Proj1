//
//  xxxDocCollabrifyWorker.m
//  xxxDoc
//
//  Created by chenditc on 9/12/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import "xxxDocCollabrifyWorker.h"

@implementation xxxDocCollabrifyWorker

static CollabrifyClient* _collabrifyClient;

+ (CollabrifyClient *) getCollabrifyClient
{
    if (_collabrifyClient == nil){
        _collabrifyClient = [[CollabrifyClient alloc] initWithGmail:@"eecs441chenditc@gmail.com"
                                                        displayName:@"chen di"
                                                       accountGmail:@"441fall2013@umich.edu"
                                                        accessToken:@"XY3721425NoScOpE"
                                                     getLatestEvent:TRUE
                                                              error:nil];
    }
    return _collabrifyClient;
}

@end
