//
//  xxxDocTextView.m
//  xxxDoc
//
//  Created by Baishen Xu on 9/11/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import "xxxDocTextView.h"

@implementation xxxDocTextView

@synthesize inputText;

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

#pragma mark -
#pragma mark UIKeyInput Protocol Methods

- (BOOL)hasText {
    if (inputText.length > 0) {
        return YES;
    }
    return NO;
}

- (void)insertText:(NSString *)theText {
    [self.inputText appendString:theText];

    NSLog(@"Insert: %@\n", theText);

    [self setNeedsDisplay];
}

- (void)deleteBackward {
    NSRange theRange = NSMakeRange(self.inputText.length-1, 1);

    NSLog(@"Delete: %@\n", [inputText substringWithRange:theRange]);
    
    [self.inputText deleteCharactersInRange:theRange];
    [self setNeedsDisplay];
}

@end
