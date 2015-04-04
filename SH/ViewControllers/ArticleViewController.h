//
//  ArticleViewController.h
//  SH
//
//  Created by jwan on 3/23/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class Article;

@interface ArticleViewController : UIViewController <UIWebViewDelegate, ADBannerViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil art:(Article *)art;

@property (weak, nonatomic) IBOutlet UIView *thumbView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btnSee;
@property (strong, nonatomic) IBOutlet UIButton *btnShowComment;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIView *searchResultView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *busyView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;


- (IBAction)onShareBtn:(id)sender;
- (IBAction)onSearchBtn:(id)sender;
- (IBAction)onSearchCancel:(id)sender;
- (IBAction)onShowComment:(id)sender;
- (IBAction)onBtnSeeAlso:(id)sender;
- (IBAction)onBack:(id)sender;
@end
