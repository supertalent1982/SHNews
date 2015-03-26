//
//  SignupViewController.h
//  SH
//
//  Created by jwan on 3/20/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UIButton *btndone;

- (IBAction)onReturnkeyboard:(id)sender;
- (IBAction)onConfirmBtn:(id)sender;
- (IBAction)onBack:(id)sender;
@end
