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
    
    CGFloat yPoint = 203.0;
    CGFloat xPoint = 25.0;
    CGFloat labelWidth = 270.0;
    
    CGFloat orgWidth = art.thumb.width;
    CGFloat orgHeight = art.thumb.height;
    
    CGFloat width = 320;
    CGFloat height = orgHeight * 320.0f / orgWidth;
    if(height < 202) {
        height = 202.0f;
        width = orgWidth * 202.0f / orgHeight;
    }
    
    
    UIImageView *thumbImage = [[UIImageView alloc] init];
    [thumbImage setFrame:CGRectMake((320.0-width)/2.0f, 0, width, height)];
//    [self.thumbView setFrame:CGRectMake(0, 0, width, height)];
    [self.thumbView addSubview:thumbImage];
    
    if(art.thumb.height == 1) {
        [self.thumbView setFrame:CGRectMake(0, 0, 320, 0)];
        yPoint = 1;
    } else {
        [self.thumbView setFrame:CGRectMake(0, 0, 320, 202)];
    }
    
    yPoint += 15.0;
    [self.categorieLabel setFrame:CGRectMake(25, yPoint, labelWidth, 9.0)];
    
    yPoint += (9.0 + 6.0);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = LINE_SPACING;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:art.title];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, art.title.length)];
    [self.titleLabel setAttributedText:attributedText];
    
    CGSize maximumLabelSize = CGSizeMake(labelWidth, 9999); // this width will be as per your requirement
    CGFloat titleHeight = [self getHeightForText:art.title withFont:TITLE_FONT andWidth:labelWidth];//= [self.titleLabel sizeThatFits:maximumLabelSize].height;
    
    [self.titleLabel setFrame:CGRectMake(xPoint, yPoint, labelWidth, titleHeight)];
    
    yPoint += (22.0 + titleHeight);
    
    [self.optionView setFrame:CGRectMake(xPoint, yPoint, labelWidth, 9.0)];
    
    activityIndicatorView.center = self.thumbView.center;
    [thumbImage addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    

        NSLog(@"Width = %d, Height = %d", width, height);
    
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

- (IBAction)onReadMore:(id)sender {
}

- (IBAction)onComments:(id)sender {
}
@end
