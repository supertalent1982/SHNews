//
//  Article.m
//  SH
//
//  Created by jwan on 3/22/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "Article.h"

@implementation Article

-(id)init {
    
    self.author = [[Author alloc] init];
    self.modified = @"";
    self.slug = @"";
    self.thumbnail = @"";
    self.title = @"";
    self.url = @"";
    self.tagArray = [NSMutableArray array];
    self.commentstatus = @"";
    self.status = @"";
    self.thumbnailsize = @"";
    self.type = @"";
    self.articleId = 0;
    self.date = @"";
    self.titleplain = @"";
    self.commentArray = [NSMutableArray array];
    self.excerpt = @"";
    self.content = @"";
    self.categorieArray = [NSMutableArray array];
    self.thumb = [[Thumbnail alloc] init];
    self.apiIndex = 1;
    
    return self;
}

@end
