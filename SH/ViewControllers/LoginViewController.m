//
//  LoginViewController.m
//  SH
//
//  Created by jwan on 3/20/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "LoginViewController.h"
#import "Constant.h"
#import "HomeViewController.h"

#import <FacebookSDK/FacebookSDK.h>
#import <TwitterKit/TwitterKit.h>
#import <Social/Social.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.busyView setAlpha:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)goLogin {
    [[NSUserDefaults standardUserDefaults] setObject:self.nameText.text forKey:USERNAME];
    [[NSUserDefaults standardUserDefaults] setObject:self.emailText.text forKey:USEREMAIL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoHome {
    HomeViewController *homeView = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:homeView animated:YES];
}

- (void)signUpClientResponse:(NSDictionary *)response
{
    if(!response){
        UIAlertView *simpleAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning",nil) message:NSLocalizedString(@"Failed to connect to the server.", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [simpleAlert show];
    } else {
        if ([[response objectForKey:@"success"] boolValue] == YES) {
        }
    }
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if(textField.tag == 102) {
        [self goLogin];
    }
    return YES;
}

/*
 ** get facebook account
 */
- (void)onFbLogin
{

    [self.busyView setAlpha:1];
    [self.activity startAnimating];
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", @"user_friends", @"public_profile", nil];
    
    // If the session state is any of the two "open" states when the button is clicked
    NSLog(@"FBsession ActiveSession state =  %i", FBSession.activeSession.state);
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        [ FBRequestConnection startForMeWithCompletionHandler: ^( FBRequestConnection* _connection, id < FBGraphUser > _facebookUser, NSError* _error ) {
            if( _error )
            {
                // Hide ;
                [self.activity stopAnimating];
                [self.busyView setAlpha:0];
                return;
            }
            
            /*
            NSString *accessToken = [[FBSession activeSession] accessToken];
            NSDate *expirationDate = [[FBSession activeSession] expirationDate];
            [DELEGATE setFacebookAccessToken:accessToken];
             */
            
            NSString *fullName = [_facebookUser objectForKey:@"name"];
            NSString *email = [_facebookUser objectForKey:@"email"];
            NSString *birthDay = [_facebookUser objectForKey:@"birthday"];
            NSString *userID = [_facebookUser objectForKey:@"id"];
            
            [[NSUserDefaults standardUserDefaults] setObject:fullName forKey:USERNAME];
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:USEREMAIL];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.activity stopAnimating];
            [self.busyView setAlpha:0];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            /*
            [DELEGATE setFacebookID:userID];
            
            
            [loadingView setAlpha:1];
            if([DELEGATE cityName].length > 0) {
                
            } else {
                [DELEGATE setCityName:@"Unknown"];
            }
            
            if(birthDay.length > 0) {
                
            } else {
                birthDay = @"1990/01/01";
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
            [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:@"expirationDate"];
            [[NSUserDefaults standardUserDefaults] setObject:fullName forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"useremail"];
            [[NSUserDefaults standardUserDefaults] setObject:birthDay forKey:@"userbirthday"];
            [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self registerUserInfo:fullName :email :birthDay :userID :accessToken];
             */
            
        } ] ;
        
        // If the session state is not any of the two "open" states when the button is clicked
    } /*else if(FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
        NSString *fullName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"useremail"];
        NSString *birthDay = [[NSUserDefaults standardUserDefaults] objectForKey:@"userbirthday"];
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        
        [[NSUserDefaults standardUserDefaults] setObject:fullName forKey:USERNAME];
        [[NSUserDefaults standardUserDefaults] setObject:email forKey:USEREMAIL];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.activity stopAnimating];
        [self.busyView setAlpha:0];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }*/ else {
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          [self sessionStateChanged:session state:status error:error];
                                      }];
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    NSLog(@"User logged out");
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    [self onFbLogin];
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
        
        //hide
        [self.activity stopAnimating];
        [self.busyView setAlpha:0];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [[[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"User cancelled login" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [[[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [[[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    
        //hide
        [self.activity stopAnimating];
        [self.busyView setAlpha:0];
    }
}

- (void)loginWithTwitter {
    [self.activity startAnimating];
    [self.busyView setAlpha:1];
    
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error) {
         if (session) {
             NSLog(@"signed in as %@, %@", [session userName], [session userID]);
             [[[Twitter sharedInstance] APIClient] loadUserWithID:[session userID]
                                                       completion:^(TWTRUser *user,
                                                                    NSError *error)
              {
                  // handle the response or error
                  if (!error){
                      [[NSUserDefaults standardUserDefaults] setObject:user.screenName forKey:USERNAME];
                      [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:USEREMAIL];
                      [[NSUserDefaults standardUserDefaults] synchronize];
                      
                      [self.activity stopAnimating];
                      [self.busyView setAlpha:0];
                      
                      [self.navigationController popViewControllerAnimated:YES];
                  }
                  else{
                      [self.activity stopAnimating];
                      [self.busyView setAlpha:0];
                      
                      [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Login Error : %@", error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                  }
              }];
         } else {
             [self.activity stopAnimating];
             [self.busyView setAlpha:0];
             
             [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Login Error : %@", error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
         }
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onFacebookLogin:(id)sender {
    [self onFbLogin];
}

- (IBAction)onTwitterLogin:(id)sender {
    [self loginWithTwitter];
}

- (IBAction)onReturnKeyboard:(id)sender {
    [self.nameText resignFirstResponder];
    [self.emailText resignFirstResponder];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
