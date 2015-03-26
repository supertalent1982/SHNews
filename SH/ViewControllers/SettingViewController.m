//
//  SettingViewController.m
//  SH
//
//  Created by jwan on 3/22/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "Constant.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
    NSString *userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:USEREMAIL];
    
    if(userName && userEmail && (userEmail.length > 0) && (userName.length > 0)) {
        [self.loginLabel setText:@"Log Out"];
        self.loginLabel.tag = 401;
    } else {
        [self.loginLabel setText:@"Log In"];
        self.loginLabel.tag = 402;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onDone:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSetting:(id)sender {
}

- (IBAction)onNewslatter:(id)sender {
    SignupViewController *signupView = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
    [self.navigationController pushViewController:signupView animated:YES];
}

- (IBAction)onCommenting:(id)sender {
    if(self.loginLabel.tag == 401) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USERNAME];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USEREMAIL];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.loginLabel setText:@"Log In"];
        self.loginLabel.tag = 402;
    } else {
        LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginView animated:YES];
    }
}

- (IBAction)onSendFeedback:(id)sender {
}

- (IBAction)onDisclaimer:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.soaphub.com/disclaimer/"]];
}

- (IBAction)onPrivacy:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.soaphub.com/privacy-policy/"]];
}

- (IBAction)changeSwitch:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:self.notiSwitch.isOn forKey:ENABLE_NOTI];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
