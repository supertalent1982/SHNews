//
//  SplashViewController.m
//  SH
//
//  Created by jwan on 3/22/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "SplashViewController.h"
#import "HomeViewController.h"
#import "Constant.h"

@interface SplashViewController ()

@property (nonatomic, strong) AppDelegate   *appDelegate;
@property (nonatomic, assign) BOOL          goneHome;

@end

@implementation SplashViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.goneHome = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoHomePage) name:GO_HOME object:nil];
    appDelegate = APP_DELEGATE;
    
    [self.activity startAnimating];
    
    //Get All Font Name
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
    
    [appDelegate getArticlse:APIINDEX_SOAPS isNeedAll:YES isTimer:NO];
    
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


- (void)gotoHomePage {
    if(self.goneHome) return;

    self.goneHome = YES;
    [self.activity stopAnimating];
    HomeViewController *homeView = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:homeView animated:YES];
}


@end
