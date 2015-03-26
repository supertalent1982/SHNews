//
//  SettingViewController.h
//  SH
//
//  Created by jwan on 3/22/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController


@property (weak, nonatomic) IBOutlet UISwitch *notiSwitch;

- (IBAction)onDone:(id)sender;
- (IBAction)onSetting:(id)sender;
- (IBAction)onNewslatter:(id)sender;
- (IBAction)onCommenting:(id)sender;
- (IBAction)onSendFeedback:(id)sender;
- (IBAction)onDisclaimer:(id)sender;
- (IBAction)onPrivacy:(id)sender;
- (IBAction)changeSwitch:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@end
