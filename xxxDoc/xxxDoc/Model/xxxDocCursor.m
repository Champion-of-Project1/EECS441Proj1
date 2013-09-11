//
//  xxxDocCursor.m
//  xxxDoc
//
//  Created by Baishen Xu on 9/11/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import "xxxDocCursor.h"

@implementation xxxDocCursor

static int cursorLoc = 0;

+ (int) cursorLoc {return cursorLoc;}
+ (void) setCursorLoc: (int)newLoc {cursorLoc = newLoc;}

@end