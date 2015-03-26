//
//  ArticleTableViewCell.m
//  SH
//
//  Created by jwan on 3/22/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "ArticleTableViewCell.h"
#import "WebServiceAPI.h"
#import "UIImageView+AFNetworking.h"
#import "Article.h"
#import "Constant.h"

@implementation ArticleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.titleLabel setFont:TITLE_FONT];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadImage:(Article *)art
{
    __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    CGFloat yPoint = 0.0;
    CGFloat xPoint = 25.0;
    CGFloat labelWidth = 270.0;
    
    CGFloat orgWidth = art.thumb.width;
    CGFloat orgHeight = art.thumb.height;
    
    CGFloat width = 320;
    CGFloat height = orgHeight * 320 / orgWidth;
    yPoint = height;
    
    UIImageView *thumbImage = [[UIImageView alloc] init];
    [thumbImage setFrame:CGRectMake(0, 0, width, height)];
    [self.thumbView setFrame:CGRectMake(0, 0, width, height)];
    [self.thumbView addSubview:thumbImage];
    
    yPoint += 15.0;
    [self.categorieLabel setFrame:CGRectMake(25, yPoint, labelWidth, 15.0)];
    
    yPoint += (15.0 + 15.0);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = LINE_SPACING;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:art.title];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, art.title.length)];
    [self.titleLabel setAttributedText:attributedText];
    
    CGSize maximumLabelSize = CGSizeMake(labelWidth, 9999); // this width will be as per your requirement
    CGFloat titleHeight = [self.titleLabel sizeThatFits:maximumLabelSize].height;
    
    [self.titleLabel setFrame:CGRectMake(xPoint, yPoint, labelWidth, titleHeight)];
    
    yPoint += (15.0 + titleHeight);
    
    [self.optionView setFrame:CGRectMake(xPoint, yPoint, labelWidth, 25.0)];
    
    activityIndicatorView.center = self.thumbView.center;
    [thumbImage addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    NSURL *profilePicUrl=[NSURL URLWithString:art.thumb.url];
    [thumbImage setImageWithURLRequest:[WebServiceAPI imageRequestWithURL:profilePicUrl]
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       if (image) {
                                           thumbImage.image = image;
                                       }
                                       [activityIndicatorView removeFromSuperview];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                       [activityIndicatorView removeFromSuperview];
                                   }];
    
}

- (IBAction)onReadMore:(id)sender {
}

- (IBAction)onComments:(id)sender {
}
@end
