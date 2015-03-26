//
//  CommentCell.h
//  SH
//
//  Created by jwan on 3/24/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

- (void)loadImage:(Comment *)comment;
- (void)layoutRefresh:(Comment *)comment;

@end
