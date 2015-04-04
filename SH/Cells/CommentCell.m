//
//  CommentCell.m
//  SH
//
//  Created by jwan on 3/24/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"
#import "WebServiceAPI.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    [self.avatarImage.layer setCornerRadius:20.5];
    [self.avatarImage setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadImage:(Comment *)comment
{
    __block UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    activityIndicatorView.center = CGPointMake(20.5, 20.5);
    [self.avatarImage addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    NSURL *profilePicUrl=[NSURL URLWithString:comment.authorUrl];
    [self.avatarImage setImageWithURLRequest:[WebServiceAPI imageRequestWithURL:profilePicUrl]
                      placeholderImage:nil
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                   if (image) {
                                       self.avatarImage.image = image;
                                   }
                                   [activityIndicatorView removeFromSuperview];
                               }
                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                   [activityIndicatorView removeFromSuperview];
                               }];
    
}

- (void)layoutRefresh:(Comment *)comment {
    
    if(comment.authorUrl.length > 0) {
        [self loadImage:comment];
    }
    CGFloat yPoint = self.nameLabel.frame.origin.y;
    // Name label
    [self.nameLabel setText:comment.name.uppercaseString];
    CGFloat nameHeight = [self getHeightForText:comment.name.uppercaseString withFont:[UIFont fontWithName:@"Arial" size:17.0] andWidth:228.0];
    [self.nameLabel setFrame:CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y, 228.0, nameHeight)];
    
    yPoint += (nameHeight + 9);
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:comment.date];
    // Convert to new Date Format
    [dateFormat setDateFormat:@"LLLL d, yyyy"];
    NSString *newDate = [dateFormat stringFromDate:date];
    [dateFormat setDateFormat:@"hh:mm a"];
    NSString *newTime = [dateFormat stringFromDate:date];
    [self.dateLabel setText:[NSString stringWithFormat:@"%@ at %@", newDate, newTime]];
    [self.dateLabel setFrame:CGRectMake(self.dateLabel.frame.origin.x, yPoint, 228.0, self.dateLabel.frame.size.height)];
    
    yPoint += (self.dateLabel.frame.size.height + 16);
    
    [self.commentLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
    [self.commentLabel setNumberOfLines:0];
    NSString *commentTemp = [[comment.content stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>\n" withString:@""];
    NSString *commentStr = [(AppDelegate *)[[UIApplication sharedApplication] delegate] replaceSpecialCharators:commentTemp];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7.6;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:commentStr];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, commentStr.length)];
    [self.commentLabel setAttributedText:attributedText];
    
    CGSize maximumLabelSize = CGSizeMake(228.0, 9999); // this width will be as per your requirement
    CGFloat labelHeight = [self.commentLabel sizeThatFits:maximumLabelSize].height;
    [self.commentLabel setFrame:CGRectMake(self.commentLabel.frame.origin.x, yPoint, 228.0, labelHeight)];
    
    yPoint += (labelHeight + 19);
    [self.line setFrame:CGRectMake(self.line.frame.origin.x, yPoint, 288, 1)];
    
    //    if(comment.url.length > 0) {
    //        [self loadImage:comment];
    //    }
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

@end
