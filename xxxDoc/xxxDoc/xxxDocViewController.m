//
//  xxxDocViewController.m
//  xxxDoc
//
//  Created by Baishen Xu on 9/10/13.
//  Copyright (c) 2013 Baishen Xu. All rights reserved.
//

#import "xxxDocViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "xxxDocChangeSet.h"

@interface xxxDocViewController ()

// Array store all operation done by all user, both global and local
@property NSMutableArray *operationArray;
// The index of the last global operation.
@property NSNumber *globalOperationNumber;

@end

@implementation xxxDocViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    double width = self.view.frame.size.width;
    double height = self.view.frame.size.height;
    double buttonViewHeight = 40.f;
    double buttonOffset = 3.f;
	// Do any additional setup after loading the view, typically from a nib.
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, width, buttonViewHeight)];
    [buttonView setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton *replaceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *moveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *undoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *redoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [replaceButton addTarget:self action:@selector(replaceChars:) forControlEvents:UIControlEventTouchDown];
    [moveButton addTarget:self action:@selector(moveChars:) forControlEvents:UIControlEventTouchDown];
    [undoButton addTarget:self action:@selector(undoAct:) forControlEvents:UIControlEventTouchDown];
    [redoButton addTarget:self action:@selector(redoAct:) forControlEvents:UIControlEventTouchDown];
    
    [replaceButton setTitle:@"replace" forState:UIControlStateNormal];
    [replaceButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [moveButton setTitle:@"move" forState:UIControlStateNormal];
    [moveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [undoButton setTitle:@"undo" forState:UIControlStateNormal];
    [undoButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [redoButton setTitle:@"redo" forState:UIControlStateNormal];
    [redoButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [replaceButton setFrame:CGRectMake(buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    [moveButton setFrame:CGRectMake(width / 4 + buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    [undoButton setFrame:CGRectMake(width / 2 + buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    [redoButton setFrame:CGRectMake(width / 4 * 3 + buttonOffset, buttonOffset, width / 4 - 2 * buttonOffset, buttonViewHeight - 2 * buttonOffset)];
    
    [buttonView addSubview:replaceButton];
    [buttonView addSubview:moveButton];
    [buttonView addSubview:undoButton];
    [buttonView addSubview:redoButton];
    [self.view addSubview:buttonView];
    
    double textViewOffset = 10.f;
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0.f, buttonViewHeight + textViewOffset, width, height - buttonViewHeight - textViewOffset)];
    textView.delegate = self;
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)replaceChars: (UIButton *)replaceButton
{
    NSLog(@"Replace\n");
}

- (void)moveChars: (UIButton *)moveButton
{
    NSLog(@"Move\n");
}

- (void)undoAct: (UIButton *)undoButton
{
    NSLog(@"Undo\n");
}

- (void)redoAct: (UIButton *)redoButton
{
    NSLog(@"Redo\n");
}


// creat an Change Set which contains all local operation user have made.
// Mark the operation state as sended.
- (xxxDocChangeSet*) getLocalChangeSet
{
    xxxDocChangeSet* result;
    
    return result;
}

// TODO: confirm a set of operation, detail to be determined.
- (void) confirmOperation
{


}

// apply a new change set to current operation array.
- (void) applyChangeSet: (xxxDocChangeSet*) newChangeSet
{
    
}


#pragma mark UITextViewDelegate Protocol Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 1. Create operation.
    // 2. Add replacement info into operation.
    // 3. put operation into operation array.
    if (text.length == 0){
        NSLog(@"Delete: %@", [textView.text substringWithRange:range]);

    }
    else if (range.length == 0){
        NSLog(@"Insert: %@", text);
    }
    else{
        NSLog(@"replace %@ by %@",[textView.text substringWithRange:range],text);
    }
    return YES;
}

@end
