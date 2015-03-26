//
//  LoginViewController.h
//  SH
//
//  Created by jwan on 3/20/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RSNetworkClient.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) RSNetworkClient *signUpClient;                // log in
@property (nonatomic, strong) RSNetworkClient *facebookLoginClient;         // log in with facebook


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UIView *busyView;

- (IBAction)onFacebookLogin:(id)sender;
- (IBAction)onTwitterLogin:(id)sender;
- (IBAction)onReturnKeyboard:(id)sender;
- (IBAction)onBack:(id)sender;

@end
