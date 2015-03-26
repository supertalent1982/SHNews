//
//  ShowCommentViewController.h
//  SH
//
//  Created by jwan on 3/24/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface ShowCommentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil article:(Article *)article;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)onBack:(id)sender;
- (IBAction)onNewComment:(id)sender;

@end
