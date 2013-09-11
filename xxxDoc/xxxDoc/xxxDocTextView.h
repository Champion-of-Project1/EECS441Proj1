//
//  xxxDocTextView.h
//  xxxDoc
//
//  Created by Baishen Xu on 9/11/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xxxDocTextView : UITextView <UIKeyInput> {
    NSMutableString *inputText;
}

@property (strong, atomic) NSMutableString *inputText;

@end
