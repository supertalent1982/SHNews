//
//  ShowCommentViewController.m
//  SH
//
//  Created by jwan on 3/24/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "ShowCommentViewController.h"
#import "NewCommentViewController.h"
#import "Article.h"
#import "CommentCell.h"
#import "Constant.h"
#import "SVPullToRefresh.h"
#import "RSNetworkClient.h"

NSString *const CommentTableViewCellIdentifier = @"CommentCell";

@interface ShowCommentViewController ()

@property (nonatomic, strong) Article       *mArt;
@property (nonatomic, strong) CommentCell *referenceCell;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation ShowCommentViewController

@synthesize mArt;
@synthesize appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil article:(Article *)article
{
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
    self.referenceCell = [[NSBundle mainBundle] loadNibNamed:CommentTableViewCellIdentifier owner:self options:nil][0];
    
    __weak ShowCommentViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableview addPullToRefreshWithActionHandler:^{
        [weakSelf refreshComment];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)refreshComment {
    RSNetworkClient *client = [[RSNetworkClient alloc] init];
    [client setDelegate:self];
    [client setSelector:@selector(getCommentClientResponse:)];
    
    NSString *URLstring = [NSString stringWithFormat:@"http://www.soaphub.com/api/get_post/?id=%d", mArt.articleId];
    
    URLstring = [URLstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [client sendRequest:URLstring];
}

- (void)getCommentClientResponse:(NSDictionary *)response
{
    //    NSLog(@"Login-- RESPONSE %@",response);
    if(!response){
        
    } else {
        NSString *status = [response objectForKey:@"status"];
        if(status && [status.lowercaseString isEqualToString:@"ok"]) {
            NSDictionary *article = [response objectForKey:@"post"];

            mArt.commentArray = [NSMutableArray array];
            for(NSDictionary *comment in [article objectForKey:@"comments"]) {
                Comment *c = [[Comment alloc] init];
                c.date = [comment objectForKey:@"date"];
                c.commentId = [[comment objectForKey:@"id"] integerValue];
                c.content = [comment objectForKey:@"content"];
                c.name = [comment objectForKey:@"name"];
                c.url = [comment  objectForKey:@"url"];
                c.parent = [[comment objectForKey:@"parent"] integerValue];
                c.authorUrl = [comment objectForKey:@"author_pic"];
                
                [mArt.commentArray addObject:c];
            }
        }
    }
    
    __weak ShowCommentViewController *weakSelf = self;
    [weakSelf.tableview.pullToRefreshView stopAnimating];
    [self.tableview reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mArt.commentArray count];
}

- (void)configureLabelsForCell:(CommentCell *)cell inTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentTableViewCellIdentifier];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CommentTableViewCellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    // Add support for tapping the username text and navigating to the associated profile
    Comment *comment = [mArt.commentArray objectAtIndex:indexPath.row];
    [cell layoutRefresh:comment];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [mArt.commentArray objectAtIndex:indexPath.row];
    CGFloat yPoint = 20.0f;
    // Name label
    CGFloat nameHeight = [self getHeightForText:comment.name.uppercaseString withFont:[UIFont fontWithName:@"Arial" size:17.0] andWidth:228.0];
    yPoint += (nameHeight + 9 + 18 + 16);

    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.numberOfLines = 0;
    [commentLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
    NSString *commentTemp = [[comment.content stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>\n" withString:@""];
    NSString *commentStr = [appDelegate replaceSpecialCharators:commentTemp];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7.6;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:commentStr];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, commentStr.length)];
    [commentLabel setAttributedText:attributedText];
    
    CGSize maximumLabelSize = CGSizeMake(228.0, 9999); // this width will be as per your requirement
    CGFloat labelHeight = [commentLabel sizeThatFits:maximumLabelSize].height;
    
    yPoint += (labelHeight + 20);

    return yPoint;
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
    
    CGFloat height = MAX(totalHeight, 10.0f);
    return height;
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNewComment:(id)sender {
    NewCommentViewController *createView = [[NewCommentViewController alloc] initWithNibName:@"NewCommentViewController" bundle:nil article:mArt];
    [self.navigationController pushViewController:createView animated:YES];
}
@end
