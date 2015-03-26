//
//  ArticleCell.h
//  SH
//
//  Created by jwan on 3/24/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Thumbnail;

@interface ArticleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *thumbView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UILabel *categorieLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

- (void)loadImage:(Thumbnail *)thumbnail;

@end
