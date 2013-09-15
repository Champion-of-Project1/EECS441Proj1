//
//  xxxDocTextView.m
//  xxxDoc
//
//  Created by chenditc on 9/15/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import "xxxDocTextView.h"

@implementation xxxDocTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    else if (action == @selector(copy:))
        return NO;
    else if (action == @selector(cut:))
        return NO;
    else if (action == @selector(select:))
        return NO;
    else if (action == @selector(selectAll:))
        return NO;
    
    return [super canPerformAction:action withSender:sender];
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        [(UITapGestureRecognizer *)gestureRecognizer setNumberOfTapsRequired:1];
    }
    
    [super addGestureRecognizer:gestureRecognizer];
}

@end
