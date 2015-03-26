//
//  NewCommentViewController.m
//  SH
//
//  Created by jwan on 3/24/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "NewCommentViewController.h"
#import "LoginViewController.h"
#import "RSNetworkClient.h"
#import "Article.h"
#import "Constant.h"

@interface NewCommentViewController ()

@property (nonatomic, strong) Article *mArt;
@property (nonatomic, assign) BOOL      isPosting;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation NewCommentViewController

@synthesize mArt;
@synthesize appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil article:(Article*)article {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        mArt = article;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = APP_DELEGATE;
    self.isPosting = NO;
    [self.busyView setAlpha:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    if(self.isPosting) {
//        [self.activity startAnimating];
//        [self.busyView setAlpha:1];
//        [self postComment];
//    } else {
        [self startEditingComment];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getClientResponse:(NSDictionary *)response
{
    [self.activity stopAnimating];
    [self.busyView setAlpha:0];
    self.isPosting = NO;
    //    NSLog(@"Login-- RESPONSE %@",response);
    if(!response){
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Duplicate comment detected; it looks as though you’ve already said that!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    } else {
        
        NSString *error = [response objectForKey:@"status"];
        if([error.lowercaseString isEqualToString:@"ok"]) {
            Comment *c = [[Comment alloc] init];
            c.date = [response objectForKey:@"date"];
            c.commentId = [[response objectForKey:@"id"] integerValue];
            c.content = [response objectForKey:@"content"];
            c.name = [response objectForKey:@"name"];
            c.url = [response  objectForKey:@"url"];
            c.parent = [[response objectForKey:@"parent"] integerValue];
            c.authorUrl = [response objectForKey:@"author_pic"];
            
            [mArt.commentArray addObject:c];
//            [self addCommentToArray:c];
            
            UIAlertView *postAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Posting Success" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            postAlert.tag = 202;
            [postAlert show];
        } else {
            NSString *trimmedString = [self.commentText.text stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceCharacterSet]];
            if(trimmedString.length > 0) {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Duplicate comment detected, it looks as though you’ve already said that!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please include a message" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
        }
    }    
}

- (void)addCommentToArray:(Comment *)comment {
    for(Article *art in appDelegate.mSoaps) {
        if(art.articleId == mArt.articleId) {
            [art.commentArray addObject:comment];
        }
    }
    
    for(Article *art in appDelegate.mGenerals) {
        if(art.articleId == mArt.articleId) {
            [art.commentArray addObject:comment];
        }
    }
    
    for(Article *art in appDelegate.mYoungs) {
        if(art.articleId == mArt.articleId) {
            [art.commentArray addObject:comment];
        }
    }
    
    for(Article *art in appDelegate.mDays) {
        if(art.articleId == mArt.articleId) {
            [art.commentArray addObject:comment];
        }
    }
    
    for(Article *art in appDelegate.mBold) {
        if(art.articleId == mArt.articleId) {
            [art.commentArray addObject:comment];
        }
    }
    
    for(Article *art in appDelegate.mHot) {
        if(art.articleId == mArt.articleId) {
            [art.commentArray addObject:comment];
        }
    }
    
    
    for(Article *art in appDelegate.mSearch) {
        if(art.articleId == mArt.articleId) {
            [art.commentArray addObject:comment];
        }
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

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 201) {
        if(buttonIndex == 0) {
            LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:loginView animated:YES];
        } else {
            [self.activity stopAnimating];
            [self.busyView setAlpha:0];
        }
    } else if(alertView.tag == 202) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return;
}

#pragma UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self.commentText setFrame:CGRectMake(self.commentText.frame.origin.x, self.commentText.frame.origin.y, self.commentText.frame.size.width, 170.0)];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self endEditingComment];
    
    return YES;
}

- (void)startEditingComment {
    [self.commentText becomeFirstResponder];
    [self.commentText setFrame:CGRectMake(self.commentText.frame.origin.x, self.commentText.frame.origin.y, self.commentText.frame.size.width, 170.0)];
}

- (void)endEditingComment {
    [self.commentText resignFirstResponder];
    [self.commentText setFrame:CGRectMake(self.commentText.frame.origin.x, self.commentText.frame.origin.y, self.commentText.frame.size.width, 423.0)];
}

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPost:(id)sender {
    
    NSString *trimmedString = [self.commentText.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    if(trimmedString.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please input a comment and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    
    self.isPosting = YES;
    [self endEditingComment];
    [self postComment];
}

- (IBAction)onReturnKeyboard:(id)sender {
    [self endEditingComment];
}

- (void)postComment {
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
    NSString *useremail = [[NSUserDefaults standardUserDefaults] objectForKey:USEREMAIL];
    if(username && useremail && (useremail.length > 0) && (useremail.length > 0)) {
    
        [self.activity startAnimating];
        [self.busyView setAlpha:1];
        
        RSNetworkClient *client = [[RSNetworkClient alloc] init];
        [client setDelegate:self];
        [client setSelector:@selector(getClientResponse:)];
        
        NSString *URLstring = [NSString stringWithFormat:@"http://www.soaphub.com/?json=submit_comment&post_id=%d&name=%@&email=%@&content=%@", mArt.articleId, username, useremail, self.commentText.text];
        
        URLstring = [URLstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        URLstring = [URLstring stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        [client sendRequest:URLstring];
    } else {
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You did not join it yet. Are you want to join for now?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        loginAlert.tag =201;
        [loginAlert show];
    }
}
@end
