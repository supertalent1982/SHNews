//
//  ArticleCell.m
//  SH
//
//  Created by jwan on 3/24/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "ArticleCell.h"
#import "WebServiceAPI.h"
#import "UIImageView+AFNetworking.h"
#import "Thumbnail.h"
#import "Constant.h"

@implementation ArticleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadImage:(Thumbnail *)thumbnail
{
    __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    CGFloat orgWidth = thumbnail.width;
    CGFloat orgHeight = thumbnail.height;
    
    CGFloat width = 320;
    CGFloat height = orgHeight * 320 / orgWidth;
    
    UIImageView *thumbImage = [[UIImageView alloc] init];
    [thumbImage setFrame:CGRectMake(0, 0, width, height)];
    [self.thumbView setFrame:CGRectMake(0, 0, width, height)];
    [self.thumbView addSubview:thumbImage];
    
    activityIndicatorView.center = self.thumbView.center;
    [thumbImage addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    NSURL *profilePicUrl=[NSURL URLWithString:thumbnail.url];
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

@end
