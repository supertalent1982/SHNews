//
//  HomeViewController.m
//  SH
//
//  Created by jwan on 3/21/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#define SEARCHVIEW_HEIGHT   45
#define MENUVIEW_HEIGHT     250


#import "HomeViewController.h"
#import "ArticleTableViewCell.h"
#import "Article.h"
#import "Constant.h"
#import "SettingViewController.h"
#import "ArticleViewController.h"
#import "SVPullToRefresh.h"

@interface HomeViewController ()

@property (nonatomic, assign) BOOL      isNew;
@property (nonatomic, assign) BOOL      isRefreshing;
@property (nonatomic, assign) BOOL      isSearchRefreshing;
@property (nonatomic, assign) NSInteger iCategorie;
@property (nonatomic, strong) NSMutableArray   *arrayNEW;
@property (nonatomic, strong) NSMutableArray   *arrayHOT;
@property (nonatomic, strong) NSMutableArray   *arraySearch;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) UIRefreshControl *refreshNew;
@property (nonatomic, strong) UIRefreshControl *refreshHot;
@property (nonatomic, strong) UIRefreshControl *refreshSearch;
@property (nonatomic, strong) NSTimer          *refreshTimer;

@end

@implementation HomeViewController

@synthesize appDelegate;
@synthesize arrayNEW;
@synthesize arrayHOT;
@synthesize arraySearch;
@synthesize refreshHot;
@synthesize refreshNew;
@synthesize refreshSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isRefreshing = NO;
    self.isSearchRefreshing = NO;
    [self.busyView setAlpha:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAllArticles) name:GOT_RESPONSE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAddedArticles) name:ADD_RESPONSE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotSearchArticles) name:SEARCH_RESPONSE object:nil];
    
    self.isNew = YES;
    self.iCategorie = APIINDEX_SOAPS;
    [self.btnSoaps setFont:BUTTON_FONT];
    [self.btnGeneral setFont:BUTTON_FONT];
    [self.btnLives setFont:BUTTON_FONT];
    [self.btnYoung setFont:BUTTON_FONT];
    [self.btnBold setFont:BUTTON_FONT];
    
    appDelegate = APP_DELEGATE;
    arrayNEW = [NSMutableArray arrayWithArray:appDelegate.mSoaps];
    arrayHOT = [NSMutableArray arrayWithArray:appDelegate.mHot];
    arraySearch = [NSMutableArray array];
    [appDelegate setMSearch:[NSMutableArray array]];
    
    
    __weak HomeViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableHot addPullToRefreshWithActionHandler:^{
        [weakSelf refreshHotArticle];
    }];
    
    // setup pull-to-refresh
    [self.searchTable addPullToRefreshWithActionHandler:^{
        [weakSelf refreshSearchArticle];
    }];
    
    // setup infinite scrolling
    [self.searchTable addInfiniteScrollingWithActionHandler:^{
        [weakSelf oldSearchArticle];
    }];
    
    // setup pull-to-refresh
    [self.tableNew addPullToRefreshWithActionHandler:^{
        [weakSelf refreshNewArticle];
    }];
    
    // setup infinite scrolling
    [self.tableNew addInfiniteScrollingWithActionHandler:^{
        [weakSelf oldNewArticle];
    }];
    
    [self initMenuButtons];
    [self.btnCancelMenu setAlpha:0];
    [self.btnHideMenu setAlpha:0];
    [self.activity startAnimating];
    [self.btnSoaps setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.iCategorie = APIINDEX_SOAPS;
    self.arrayNEW = [NSMutableArray arrayWithArray:appDelegate.mSoaps];
    [self reloadNewTableView];
    
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:3600.0
                                     target:self
                                   selector:@selector(refreshAllArticles)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    appDelegate.mIsActivityHome = YES;
    
    if(appDelegate.gotAll) {
        [self reloadTableView];
    }
    
    self.arraySearch = [NSMutableArray arrayWithArray:appDelegate.mSearch];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    appDelegate.mIsActivityHome = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshAllArticles {
    if(!self.isRefreshing) {
        self.isRefreshing = YES;
        [appDelegate backgroundGetArticles];
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

- (void)refreshSearchArticle {
    if(!self.isSearchRefreshing) {
        self.isSearchRefreshing = YES;
        [appDelegate getSearchArticlse:self.searchText.text];
    } else {
        __weak HomeViewController *weakSelf = self;
        [weakSelf.searchTable.pullToRefreshView stopAnimating];
    }
}

- (void)oldSearchArticle {
    if(!self.isSearchRefreshing) {
        self.isSearchRefreshing = YES;
        [appDelegate addSearchArticlse:self.searchText.text];
    } else {
        __weak HomeViewController *weakSelf = self;
        [weakSelf.searchTable.infiniteScrollingView stopAnimating];
    }
}

- (void)refreshHotArticle {
    self.isRefreshing = YES;
    [appDelegate getArticlse:APIINDEX_HOT isNeedAll:NO isTimer:NO];
}

- (void)refreshNewArticle {
    if(appDelegate.gotAll && !self.isRefreshing) {
        self.isRefreshing = YES;
        [appDelegate getArticlse:self.iCategorie isNeedAll:NO isTimer:NO];
    } else {
        __weak HomeViewController *weakSelf = self;
        [weakSelf.tableNew.pullToRefreshView stopAnimating];
    }
}

- (void)oldNewArticle {
    if(appDelegate.gotAll && !self.isRefreshing) {
        self.isRefreshing = YES;
        [appDelegate addArticles:self.iCategorie];
    } else {
        __weak HomeViewController *weakSelf = self;
        [weakSelf.tableNew.infiniteScrollingView stopAnimating];
    }
}

- (void)gotSearchArticles {
    [self.searchActivity stopAnimating];
    [self.searchBusyView setAlpha:0];
    self.isSearchRefreshing = NO;
    
    [self setArraySearch:[NSMutableArray arrayWithArray:appDelegate.mSearch]];
    [self.searchTable reloadData];
    __weak HomeViewController *weakSelf = self;
    [weakSelf.searchTable.infiniteScrollingView stopAnimating];
    [weakSelf.searchTable.pullToRefreshView stopAnimating];
}

- (void)gotAddedArticles {
    __weak HomeViewController *weakSelf = self;
    [weakSelf.tableNew.infiniteScrollingView stopAnimating];
    self.isRefreshing = NO;
    [self reloadTableView];
}

- (void)gotAllArticles {
    appDelegate.gotAll = YES;
    self.isRefreshing = NO;
    __weak HomeViewController *weakSelf = self;
    [weakSelf.tableNew.pullToRefreshView stopAnimating];
    [weakSelf.tableNew.infiniteScrollingView stopAnimating];
    [weakSelf.tableHot.pullToRefreshView stopAnimating];
    
    [self.activity removeFromSuperview];
    [self.busyView setAlpha:0];
    [self hideMenuView];
    
    [self reloadTableView];
}

- (void)reloadTableView {
    if(self.isNew) {
        switch (self.iCategorie) {
            case APIINDEX_SOAPS:
                [self setArrayNEW:[NSMutableArray arrayWithArray:appDelegate.mSoaps]];
                break;
                
            case APIINDEX_YOUNG:
                [self setArrayNEW:[NSMutableArray arrayWithArray:appDelegate.mYoungs]];
                break;
                
            case APIINDEX_BOLD:
                [self setArrayNEW:[NSMutableArray arrayWithArray:appDelegate.mBold]];
                break;
                
            case APIINDEX_DAYS:
                [self setArrayNEW:[NSMutableArray arrayWithArray:appDelegate.mDays]];
                break;
                
            case APIINDEX_GENERAL:
                [self setArrayNEW:[NSMutableArray arrayWithArray:appDelegate.mGenerals]];
                break;
                
            default:
                break;
        }
        
        [self.tableNew reloadData];
    } else {
        [self setArrayHOT:[NSMutableArray arrayWithArray:appDelegate.mHot]];
        [self.tableHot reloadData];
    }
}

- (void)hideMenuView {
    [self.btnMenu setBackgroundImage:[UIImage imageNamed:@"btn_menu_down.png"] forState:UIControlStateNormal];
    [self.btnCancelMenu setAlpha:0];
    [self.btnHideMenu setAlpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [self.menuView setFrame:CGRectMake(self.searchView.frame.origin.x, 0-MENUVIEW_HEIGHT, self.searchView.frame.size.width, MENUVIEW_HEIGHT)];
    }];
}

- (void)initMenuButtons {
    [self.btnSoaps setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnGeneral setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnYoung setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnLives setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnBold setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == 101)
        return arrayNEW.count;
    else if(tableView.tag == 102)
        return arrayHOT.count;
    else
        return arraySearch.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ArticleTableViewCell";
    Article *article;
    if(tableView.tag == 101)
        article = [arrayNEW objectAtIndex:indexPath.row];
    else if(tableView.tag == 102)
        article = [arrayHOT objectAtIndex:indexPath.row];
    else
        article = [arraySearch objectAtIndex:indexPath.row];
    
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    [cell loadImage:article];
    [cell.titleLabel setText:article.title];
    NSInteger commentCount = article.commentArray.count;
    NSString *commentStr = @"";
    if(commentCount == 0) {
        commentStr = @"No Comments";
    } else if (commentCount == 1) {
        commentStr = @"1 Comment";
    } else {
        commentStr = [NSString stringWithFormat:@"%d Comments", commentCount];
    }
    [cell.commentLabel setText:commentStr];
    [cell.categorieLabel setText:[self getCategorieName:article.categorieArray]];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 101) {
        ArticleViewController *artView = [[ArticleViewController alloc] initWithNibName:@"ArticleViewController" bundle:nil art:[arrayNEW objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:artView animated:YES];
    } else if(tableView.tag == 102){
        ArticleViewController *artView = [[ArticleViewController alloc] initWithNibName:@"ArticleViewController" bundle:nil art:[arrayHOT objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:artView animated:YES];
    } else {
        ArticleViewController *artView = [[ArticleViewController alloc] initWithNibName:@"ArticleViewController" bundle:nil art:[arraySearch objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:artView animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article;
    if(tableView.tag == 101)
        article = [arrayNEW objectAtIndex:indexPath.row];
    else if(tableView.tag == 102)
        article = [arrayHOT objectAtIndex:indexPath.row];
    else
        article = [arraySearch objectAtIndex:indexPath.row];
    
    float height = [self getCellHeight:article];
    return height;
}

- (CGFloat)getCellHeight:(Article *)art {
    
    CGFloat height = art.thumb.height * 320.0f / art.thumb.width;

    UILabel *calculationView = [[UILabel alloc] init];
    calculationView.numberOfLines = 0;
    [calculationView setFont:TITLE_FONT];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = LINE_SPACING;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:art.title];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, art.title.length)];
    
    [calculationView setAttributedText:attributedText];
    CGSize maximumLabelSize = CGSizeMake(270, 9999); // this width will be as per your requirement
    CGFloat titleHeight = [calculationView sizeThatFits:maximumLabelSize].height;
    
    height += (titleHeight + 110.0);

    return height;
}

-(float) getHeightForText:(NSString*) text withFont:(UIFont*) font andWidth:(float) width{
    CGSize constraint = CGSizeMake(width , 20000.0f);
    CGSize title_size;
    float totalHeight;
    
    SEL selector = @selector(boundingRectWithSize:options:attributes:context:);
    if ([text respondsToSelector:selector]) {
        title_size = [text boundingRectWithSize:constraint
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName : font }
                                        context:nil].size;
        
        totalHeight = ceil(title_size.height);
    } else {
        title_size = [text sizeWithFont:font
                      constrainedToSize:constraint
                          lineBreakMode:NSLineBreakByWordWrapping];
        totalHeight = title_size.height ;
    }
    
    CGFloat height = MAX(totalHeight, 32.0f);
    return height;
}

- (void)reloadNewTableView {
    self.isNew = YES;
    [self.btnNew setBackgroundColor:[UIColor whiteColor]];
    [self.btnHot setBackgroundColor:NORMAL_BGCOLOR];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.tableView setFrame:CGRectMake(0, 34, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    }];
    
    [self.tableNew reloadData];
    [self.tableNew scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self hideMenuView];
}

- (void)prepareSearchResult {
    [UIView animateWithDuration:0.5 animations:^{
        [self.searchResultView setFrame:CGRectMake(0, 0, self.searchResultView.frame.size.width, self.searchResultView.frame.size.height)];
    }];
    [self.searchBusyView setAlpha:1];
    [self.searchActivity startAnimating];
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if(textField.tag == 201) {
        [appDelegate setMSearch:[NSMutableArray array]];
        [self prepareSearchResult];
        [appDelegate getSearchArticlse:self.searchText.text];
    }
    return YES;
}

- (NSString *)getCategorieName:(NSMutableArray *)cArr {
    NSString *cName = @"";
    
    for(Categorie *c in cArr) {
        if([c.title isEqualToString:CATEGORIE_NAME_BOLD] ||
           [c.title isEqualToString:CATEGORIE_NAME_DAYS] ||
           [c.title isEqualToString:CATEGORIE_NAME_YOUNG] ||
           [c.title isEqualToString:CATEGORIE_NAME_GENERAL] ) {
            if(cName.length > 0) {
                cName = [NSString stringWithFormat:@"%@, %@", cName, c.title];
            } else {
                cName = c.title;
            }
        }
    }
    
    if(cName.length == 0) {
        Categorie *ca = [cArr objectAtIndex:0];
        cName = ca.title;
    }
    
    return [cName uppercaseString];
}

- (IBAction)onSetting:(id)sender {
    SettingViewController *settingView = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingView animated:YES];
}

- (IBAction)onSearch:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        [self.searchView setFrame:CGRectMake(self.searchView.frame.origin.x, 17, self.searchView.frame.size.width, SEARCHVIEW_HEIGHT)];
    } completion:^(BOOL finished) {
        [self.searchText becomeFirstResponder];
    }];
}

- (IBAction)onMenu:(id)sender {
    if(self.menuView.frame.origin.y < 0) {
        [self.btnMenu setBackgroundImage:[UIImage imageNamed:@"btn_menu_up.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            [self.menuView setFrame:CGRectMake(self.searchView.frame.origin.x, 0, self.searchView.frame.size.width, MENUVIEW_HEIGHT)];
        }];
        [self.btnCancelMenu setAlpha:1];
        [self.btnHideMenu setAlpha:1];
    } else {
        [self.btnMenu setBackgroundImage:[UIImage imageNamed:@"btn_menu_down.png"] forState:UIControlStateNormal];
        [self hideMenuView];
    }
}

- (IBAction)onNew:(id)sender {
    if(!self.isNew) {
        self.isNew = YES;
        [self.btnNew setBackgroundColor:[UIColor whiteColor]];
        [self.btnHot setBackgroundColor:NORMAL_BGCOLOR];
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.tableView setFrame:CGRectMake(0, 34, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        }];
    }
}

- (IBAction)onHot:(id)sender {
    if(self.isNew) {
        self.isNew = NO;
        [self.btnHot setBackgroundColor:[UIColor whiteColor]];
        [self.btnNew setBackgroundColor:NORMAL_BGCOLOR];
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.tableView setFrame:CGRectMake(-320, 34, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        }];
    }
}
- (IBAction)onSearchCancel:(id)sender {
    [self.searchText resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.searchResultView setFrame:CGRectMake(320, 0, self.searchResultView.frame.size.width, self.searchResultView.frame.size.height)];
        [self.searchView setFrame:CGRectMake(self.searchView.frame.origin.x, 0-SEARCHVIEW_HEIGHT, self.searchView.frame.size.width, SEARCHVIEW_HEIGHT)];
    } completion:^(BOOL finished) {
        [self.searchText setText:@""];
        [appDelegate setMSearch:[NSMutableArray array]];
        self.arraySearch = [NSMutableArray array];
        [self.searchTable reloadData];
    }];
    
}

- (IBAction)onCancelMenu:(id)sender {
    [self hideMenuView];
}

- (IBAction)onBtnSocps:(id)sender {
    if(self.iCategorie == APIINDEX_SOAPS) {
        [self hideMenuView];
        return;
    }
    
    [self initMenuButtons];
    [self.btnSoaps setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.iCategorie = APIINDEX_SOAPS;
    if(appDelegate.gotAll) {
        self.arrayNEW = [NSMutableArray arrayWithArray:appDelegate.mSoaps];
        [self reloadNewTableView];
    } else {
        [self.busyView setAlpha:1];
    }
}

- (IBAction)onBtnGeneral:(id)sender {
    if(self.iCategorie == APIINDEX_GENERAL) {
        [self hideMenuView];
        return;
    }
    
    [self initMenuButtons];
    [self.btnGeneral setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.iCategorie = APIINDEX_GENERAL;
    if(appDelegate.gotAll) {
        self.arrayNEW = [NSMutableArray arrayWithArray:appDelegate.mGenerals];
        [self reloadNewTableView];
    } else {
        [self.busyView setAlpha:1];
    }
}

- (IBAction)onBtnYoung:(id)sender {
    if(self.iCategorie == APIINDEX_YOUNG) {
        [self hideMenuView];
        return;
    }
    
    [self initMenuButtons];
    [self.btnYoung setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.iCategorie = APIINDEX_YOUNG;
    if(appDelegate.gotAll) {
        self.arrayNEW = [NSMutableArray arrayWithArray:appDelegate.mYoungs];
        [self reloadNewTableView];
    } else {
        [self.busyView setAlpha:1];
    }
}

- (IBAction)onBtnLives:(id)sender {
    if(self.iCategorie == APIINDEX_DAYS) {
        [self hideMenuView];
        return;
    }
    
    [self initMenuButtons];
    [self.btnLives setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.iCategorie = APIINDEX_DAYS;
    if(appDelegate.gotAll) {
        self.arrayNEW = [NSMutableArray arrayWithArray:appDelegate.mDays];
        [self reloadNewTableView];
    } else {
        [self.busyView setAlpha:1];
    }
}

- (IBAction)onBtnBold:(id)sender {
    if(self.iCategorie == APIINDEX_BOLD) {
        [self hideMenuView];
        return;
    }
    
    [self initMenuButtons];
    [self.btnBold setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.iCategorie = APIINDEX_BOLD;
    if(appDelegate.gotAll) {
        self.arrayNEW = [NSMutableArray arrayWithArray:appDelegate.mBold];
        [self reloadNewTableView];
    } else {
        [self.busyView setAlpha:1];
    }
}

@end
