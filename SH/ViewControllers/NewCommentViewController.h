//
//  NewCommentViewController.h
//  SH
//
//  Created by jwan on 3/24/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface NewCommentViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil article:(Article*)article;

- (IBAction)onCancel:(id)sender;
- (IBAction)onPost:(id)sender;
- (IBAction)onReturnKeyboard:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *commentText;
@property (weak, nonatomic) IBOutlet UIView *busyView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
