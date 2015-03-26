//
//  Tag.m
//  SH
//
//  Created by jwan on 3/22/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "Tag.h"

@implementation Tag

-(id)init {
    
    self.tagId = 0;
    self.slug = @"";
    self.title = @"";
    self.desc = @"";
    self.postcount = 0;
    
    return self;
}

@end
