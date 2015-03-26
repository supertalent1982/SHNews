//
//  Article.h
//  SH
//
//  Created by jwan on 3/22/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Comment.h"
#import "Author.h"
#import "Categorie.h"
#import "Thumbnail.h"
#import "Tag.h"

@interface Article : NSObject

@property (nonatomic, strong) Author            *author;
@property (nonatomic, strong) NSString          *modified;
@property (nonatomic, strong) NSString          *slug;
@property (nonatomic, strong) NSString          *thumbnail;
@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) NSString          *url;
@property (nonatomic, strong) NSMutableArray    *tagArray;
@property (nonatomic, strong) NSString          *commentstatus;
@property (nonatomic, strong) NSString          *status;
@property (nonatomic, strong) NSString          *thumbnailsize;
@property (nonatomic, strong) NSString          *type;
@property (nonatomic, assign) NSInteger         articleId;
@property (nonatomic, strong) NSString          *date;
@property (nonatomic, strong) NSString          *titleplain;
@property (nonatomic, strong) NSMutableArray    *commentArray;
@property (nonatomic, strong) NSString          *excerpt;
@property (nonatomic, strong) NSString          *content;
@property (nonatomic, strong) NSMutableArray    *categorieArray;
@property (nonatomic, strong) Thumbnail         *thumb;
@property (nonatomic, assign) NSInteger         apiIndex;

@end
