//
//  Comment.m
//  SH
//
//  Created by jwan on 3/22/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "Comment.h"

@implementation Comment

-(id)init {
    
    self.date = @"";
    self.content = @"";
    self.name = @"";
    self.url = @"";
    self.authorUrl = @"";
    self.commentId = 0;
    self.parent = 0;
    
    return self;
}

@end
