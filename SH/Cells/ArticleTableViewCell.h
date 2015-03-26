//
//  ArticleTableViewCell.h
//  SH
//
//  Created by jwan on 3/22/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface ArticleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *thumbView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UILabel *categorieLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

- (IBAction)onReadMore:(id)sender;
- (IBAction)onComments:(id)sender;

- (void)loadImage:(Article *)art;

@end
