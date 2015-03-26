//
//  HomeViewController.h
//  SH
//
//  Created by jwan on 3/21/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *busyView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (weak, nonatomic) IBOutlet UIButton *btnNew;
@property (weak, nonatomic) IBOutlet UIButton *btnHot;
@property (weak, nonatomic) IBOutlet UIView *viewNew;
@property (weak, nonatomic) IBOutlet UITableView *tableNew;
@property (weak, nonatomic) IBOutlet UIView *viewHot;
@property (weak, nonatomic) IBOutlet UITableView *tableHot;
@property (weak, nonatomic) IBOutlet UIView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;

- (IBAction)onSetting:(id)sender;
- (IBAction)onSearch:(id)sender;
- (IBAction)onMenu:(id)sender;
- (IBAction)onNew:(id)sender;
- (IBAction)onHot:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;

- (IBAction)onSearchCancel:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *btnSoaps;
@property (weak, nonatomic) IBOutlet UIButton *btnYoung;
@property (weak, nonatomic) IBOutlet UIButton *btnGeneral;
@property (weak, nonatomic) IBOutlet UIButton *btnLives;
@property (weak, nonatomic) IBOutlet UIButton *btnBold;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnHideMenu;

- (IBAction)onCancelMenu:(id)sender;
- (IBAction)onBtnSocps:(id)sender;
- (IBAction)onBtnGeneral:(id)sender;
- (IBAction)onBtnYoung:(id)sender;
- (IBAction)onBtnLives:(id)sender;
- (IBAction)onBtnBold:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *searchResultView;
@property (weak, nonatomic) IBOutlet UITableView *searchTable;

@property (weak, nonatomic) IBOutlet UIView *searchBusyView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchActivity;

@end
