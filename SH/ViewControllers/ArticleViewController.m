//
//  ArticleViewController.m
//  SH
//
//  Created by jwan on 3/23/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "ArticleViewController.h"
#import "ArticleTableViewCell.h"
#import "ShowCommentViewController.h"
#import "RSNetworkClient.h"
#import "WebServiceAPI.h"
#import "Article.h"
#import "Constant.h"
#import "XMLReader.h"
#import "SVPullToRefresh.h"

#import "UIImageView+AFNetworking.h"

#define LABELWIDTH          270.0
#define SEARCHVIEW_HEIGHT   45

@interface ArticleViewController ()

@property (nonatomic, strong) Article       *mArt;

@property (nonatomic, strong) ADInterstitialAd *interstitialAd;

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) NSMutableArray *arraySearch;

@property (nonatomic, assign) BOOL          isSearchRefreshing;

@property (nonatomic, strong) UIView *paraView;

@property (nonatomic, strong) UIImageView *thumbImage;

@end

@implementation ArticleViewController

@synthesize mArt;
@synthesize appDelegate;
@synthesize paraView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil art:(Article *)art {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        mArt = art;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotSearchArticles) name:SEARCH_RESPONSE object:nil];
    
    self.arraySearch = [NSMutableArray array];
    [self.titleLabel setFont:TITLE_FONT];
    appDelegate = APP_DELEGATE;
    self.isSearchRefreshing = NO;
    
    __weak ArticleViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableview addPullToRefreshWithActionHandler:^{
        [weakSelf refreshSearchArticle];
    }];
    
    // setup infinite scrolling
    [self.tableview addInfiniteScrollingWithActionHandler:^{
        [weakSelf oldSearchArticle];
    }];
    
    [self loadArticle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.arraySearch = [NSMutableArray arrayWithArray:appDelegate.mSearch];
    [self.tableview reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)loadArticle {
    
    
    [paraView removeFromSuperview];
    
    /*
     ADS Rectangle screen
     */
    NSArray *pArr = [mArt.content componentsSeparatedByString:@"</p>"];
    NSMutableArray *paraArr = [NSMutableArray array];
    for(NSString *pStr in pArr) {
        if([pStr containsString:@">"]) {
            NSArray * tagArr = [pStr componentsSeparatedByString:@">"];
            NSString *p = [tagArr objectAtIndex:tagArr.count-1];
            if(![p containsString:@"<"] && ![p containsString:@"&nbsp"] && (p.length > 1)) {
                
                if([[p substringToIndex:1] isEqualToString:@" "] ||
                   [[p substringToIndex:1] isEqualToString:@"\n"])
                    p = [p substringFromIndex:1];
                
                NSString *c = [p stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
                
                NSString *s = [appDelegate replaceSpecialCharators:c];
                if(s.length > 2)
                    [paraArr addObject:s];
            }
        }
    }
    
    CGFloat profileHeight = [self getProfileViewHeight];
    [self.profileView setFrame:CGRectMake(0, 0, 320, profileHeight+1)];
    
    paraView = [[UIView alloc] init];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, LABELWIDTH, 1.0)];
    [lineLabel setText:@""];
    [lineLabel setBackgroundColor:[UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:1.0]];
    [paraView addSubview:lineLabel];
    
    UIFont *paraFont = [UIFont fontWithName:@"Arial" size:17];
    UIColor *paraColor = [UIColor colorWithRed:84.0f/255.0f green:84.0f/255.0f blue:84.0f/255.0f alpha:1.0];
    CGFloat yPoint = 20.0;
    CGFloat xPoint = 15.0;
    
    for(int i = 0; i < paraArr.count; i++) {
        NSString *para = [paraArr objectAtIndex:i];
        
        UILabel *pLabel = [[UILabel alloc] init];
        [pLabel setNumberOfLines:0];
        [pLabel setFont:paraFont];
        [pLabel setTextColor:paraColor];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7;
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:para];
        [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, para.length)];
        [pLabel setAttributedText:attributedText];
        
        CGSize maximumLabelSize = CGSizeMake(LABELWIDTH, 9999); // this width will be as per your requirement
        CGFloat labelHeight = [pLabel sizeThatFits:maximumLabelSize].height;
        
        pLabel.numberOfLines = 100;
        [pLabel setFrame:CGRectMake(xPoint, yPoint, LABELWIDTH, labelHeight)];
        [pLabel setAttributedText:attributedText];
        
        [paraView addSubview:pLabel];
        
        yPoint += (labelHeight + 36.0);
        
        if(i == (paraArr.count - 1)) {
            yPoint += 0.0;
            [self.btnSee setFrame:CGRectMake(0, yPoint, self.btnSee.frame.size.width, self.btnSee.frame.size.height)];
            [paraView addSubview:self.btnSee];
            
            yPoint += (self.btnSee.frame.size.height + 28);
            
            [self.btnShowComment setFrame:CGRectMake(0, yPoint, self.btnShowComment.frame.size.width, self.btnShowComment.frame.size.height)];
            [paraView addSubview:self.btnShowComment];
            
            yPoint += (self.btnShowComment.frame.size.height + 34);
        } else {
            ADBannerView *adView = [[ADBannerView alloc] initWithAdType:ADAdTypeMediumRectangle];
            adView.delegate = self;
            [adView setFrame:CGRectMake(0, yPoint, 300, 250)];
            [adView setBackgroundColor:[UIColor clearColor]];
            [paraView addSubview:adView];
            
            yPoint += 288;
        }
    }
    
    ADBannerView *adView = [[ADBannerView alloc] initWithAdType:ADAdTypeMediumRectangle];
    adView.delegate = self;
    [adView setFrame:CGRectMake(0, yPoint, 300, 250)];
    [adView setBackgroundColor:[UIColor clearColor]];
    [paraView addSubview:adView];
    
    yPoint += 250;
    
    [paraView setFrame:CGRectMake(10, profileHeight, 300, yPoint+10)];
    [self.scrollView addSubview:paraView];
    [self.scrollView setContentSize:CGSizeMake(320, (profileHeight + yPoint + 20))];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)refreshSearchArticle {
    if(!self.isSearchRefreshing) {
        self.isSearchRefreshing = YES;
        [appDelegate getSearchArticlse:self.searchText.text];
    } else {
        __weak ArticleViewController *weakSelf = self;
        [weakSelf.tableview.pullToRefreshView stopAnimating];
    }
}

- (void)oldSearchArticle {
    if(!self.isSearchRefreshing) {
        self.isSearchRefreshing = YES;
        [appDelegate addSearchArticlse:self.searchText.text];
    } else {
        __weak ArticleViewController *weakSelf = self;
        [weakSelf.tableview.infiniteScrollingView stopAnimating];
    }
}

- (void)gotSearchArticles {
    [self.activity stopAnimating];
    [self.busyView setAlpha:0];
    
    [self setArraySearch:[NSMutableArray arrayWithArray:appDelegate.mSearch]];
    [self.tableview reloadData];
    self.isSearchRefreshing = NO;
    __weak ArticleViewController *weakSelf = self;
    [weakSelf.tableview.infiniteScrollingView stopAnimating];
    [weakSelf.tableview.pullToRefreshView stopAnimating];
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
    
    return [cName uppercaseString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)getProfileViewHeight {
    
    CGFloat imageHeight = [self loadImage:mArt.thumb];
    
    CGFloat pHeight = 202 + 17.0;
    if(mArt.thumb.height == 1) {
        pHeight = 17.0;
        [self.thumbView setFrame:CGRectMake(0, 0, 320, 0)];
    }
    
    [self.titleLabel setFont:TITLE_FONT];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = LINE_SPACING;
    
    [self.titleLabel setNumberOfLines:0];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:mArt.title];
    [attrText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, mArt.title.length)];
//    [self.titleLabel setAttributedText:attrText];

    [self.titleLabel setText:mArt.title];
    CGSize maximumLabelSize = CGSizeMake(LABELWIDTH, 9999); // this width will be as per your requirement
    CGFloat titleHeight = [self.titleLabel sizeThatFits:maximumLabelSize].height;
//    titleHeight = [self getHeightForText:mArt.title withFont:TITLE_FONT andWidth:LABELWIDTH];
    
    [self.titleLabel setFrame:CGRectMake(self.titleLabel.frame.origin.x, pHeight, LABELWIDTH, titleHeight)];
    
    pHeight += (titleHeight + 6);
    
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0],
                              NSFontAttributeName: [UIFont fontWithName:@"Arial" size:10.0]
                              };
    NSString *authorString = [[NSString stringWithFormat:@"BY %@ / %@", mArt.author.name, [self getCategorieName:mArt.categorieArray]] uppercaseString];
    NSString *subString = [NSString stringWithFormat:@"BY %@", mArt.author.name];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:authorString attributes:attribs];
    NSRange selectedRange = NSMakeRange(0, subString.length); // 4 characters, starting at index 22
    
    [attributedText setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0],                                   NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:10.0]} range:selectedRange];
    
//    [attributedText beginEditing];
//    
//    [attributedText addAttribute:NSFontAttributeName
//                       value:[UIFont fontWithName:@"Arial-Bold" size:9.0]
//                       range:selectedRange];
//    
//    [attributedText endEditing];
    
    self.authorLabel.attributedText = attributedText;
    
    CGFloat authorHeight = [self getHeightForText:authorString withFont:[UIFont fontWithName:@"Arial" size:10.0] andWidth:LABELWIDTH];
    [self.authorLabel setFrame:CGRectMake(self.authorLabel.frame.origin.x, pHeight, self.authorLabel.frame.size.width, authorHeight)];
    
    pHeight += (authorHeight + 12);
    
    return pHeight;
}

- (CGFloat)loadImage:(Thumbnail *)thumbnail
{
    NSLog(@"aaaaaa %@", thumbnail.url);
    
    __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    CGFloat orgWidth = thumbnail.width;
    CGFloat orgHeight = thumbnail.height;
    
    CGFloat width = 320;
    CGFloat height = orgHeight * 320.0f / orgWidth;
    if(height < 202) {
        height = 202.0f;
        width = orgWidth * 202.0f / orgHeight;
    }
    
    self.thumbImage = [[UIImageView alloc] init];
    [self.thumbImage setFrame:CGRectMake((320.0-width)/2.0f, 0, width, height)];
    //    [self.thumbView setFrame:CGRectMake(0, 0, width, height)];
    [self.thumbView addSubview:self.thumbImage];
    
//    [self.thumbnailImage setFrame:CGRectMake(0, 0, width, height)];
    
    activityIndicatorView.center = self.thumbImage.center;
    [self.thumbImage addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    
    NSURL *profilePicUrl=[NSURL URLWithString:thumbnail.url];
    [self.thumbImage setImageWithURLRequest:[WebServiceAPI imageRequestWithURL:profilePicUrl]
                           placeholderImage:nil
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        if (image) {
                                            self.thumbImage.image = image;
                                        }
                                        [activityIndicatorView removeFromSuperview];
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                        [activityIndicatorView removeFromSuperview];
                                    }];
    
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

- (void)prepareSearchResult {
    [UIView animateWithDuration:0.5 animations:^{
        [self.searchResultView setFrame:CGRectMake(0, 64, self.searchResultView.frame.size.width, self.searchResultView.frame.size.height)];
    }];
    [self.busyView setAlpha:1];
    [self.activity startAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arraySearch.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ArticleTableViewCell";
    
    Article *article = [self.arraySearch objectAtIndex:indexPath.row];
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
        commentStr = [NSString stringWithFormat:@"%lu Comments", commentCount];
    }
    [cell.commentLabel setText:commentStr];
    
    [cell.categorieLabel setText:[self getCategorieName:article.categorieArray]];
    
    return cell;
    
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.mArt = [self.arraySearch objectAtIndex:indexPath.row];
    [self onSearchCancel:nil];
    [self loadArticle];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = [self.arraySearch objectAtIndex:indexPath.row];
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

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if(textField.tag == 301) {
        [appDelegate setMSearch:[NSMutableArray array]];
        [self prepareSearchResult];
        [appDelegate getSearchArticlse:self.searchText.text];
    }
    return YES;
}

- (IBAction)onShareBtn:(id)sender {
    NSString* text = mArt.title;
    UIImage* image = self.thumbImage.image;
    NSURL *url = [NSURL URLWithString:mArt.url];
    
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[text, url, image] applicationActivities:nil];
    activityViewController.completionHandler = ^(NSString* activityType, BOOL completed) {
        // do whatever you want to do after the activity view controller is finished
    };
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)onSearchBtn:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        [self.searchView setFrame:CGRectMake(self.searchView.frame.origin.x, 17, self.searchView.frame.size.width, SEARCHVIEW_HEIGHT)];
    } completion:^(BOOL finished) {
        [self.searchText becomeFirstResponder];
    }];
}

- (IBAction)onSearchCancel:(id)sender {
    [self.searchText resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.searchResultView setFrame:CGRectMake(320, 64, self.searchResultView.frame.size.width, self.searchResultView.frame.size.height)];
        [self.searchView setFrame:CGRectMake(self.searchView.frame.origin.x, 0-SEARCHVIEW_HEIGHT, self.searchView.frame.size.width, SEARCHVIEW_HEIGHT)];
    } completion:^(BOOL finished) {
        [self.searchText setText:@""];
        [appDelegate setMSearch:[NSMutableArray array]];
        self.arraySearch = [NSMutableArray array];
        [self.tableview reloadData];
    }];
}

- (IBAction)onShowComment:(id)sender {
    ShowCommentViewController *commentView = [[ShowCommentViewController alloc] initWithNibName:@"ShowCommentViewController" bundle:nil article:mArt];
    [self.navigationController pushViewController:commentView animated:YES];
}

- (IBAction)onBtnSeeAlso:(id)sender {
    
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
