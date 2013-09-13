//
//  xxxDocAppDelegate.h
//  xxxDoc
//
//  Created by Baishen Xu on 9/10/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Collabrify/Collabrify.h>

@interface xxxDocAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Singleton Collabrify client
@property (strong, nonatomic) CollabrifyClient *collabrifyClient;

@end
