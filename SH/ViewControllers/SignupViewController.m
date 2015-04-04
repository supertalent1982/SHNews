//
//  SignupViewController.m
//  SH
//
//  Created by jwan on 3/20/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "SignupViewController.h"
#import "RSNetworkClient.h"
#import "Constant.h"

@interface SignupViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation SignupViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = APP_DELEGATE;
    [self.btndone setAlpha:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getClientResponse:(NSDictionary *)response
{
    //    NSLog(@"Login-- RESPONSE %@",response);
    if(!response){
        NSLog(@"Response failed");
    } else {
        BOOL isSuccess = [[response objectForKey:@"success"] boolValue];
        if(isSuccess) {
            [self.btndone setAlpha:1];
        } else {
            NSString *error = [response objectForKey:@"error"];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onReturnkeyboard:(id)sender {
    [self.nameText resignFirstResponder];
    [self.emailText resignFirstResponder];
}

- (IBAction)onConfirmBtn:(id)sender {
    if(self.nameText.text.length == 0 || self.emailText.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Invalid user name or email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    } else {
        RSNetworkClient *client = [[RSNetworkClient alloc] init];
        [client setDelegate:self];
        [client setSelector:@selector(getClientResponse:)];
        
        appDelegate.deviceToken = @"2234232341234132";
        NSString *URLstring = [NSString stringWithFormat:@"http://soaphub.com/api.php?cmd=signup&username=%@&usermail=%@&usertoken=%@", self.nameText.text, self.emailText.text, appDelegate.deviceToken];
        
        URLstring = [URLstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        URLstring = [URLstring stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        [client sendRequest:URLstring];
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
