//
//  Categorie.m
//  SH
//
//  Created by jwan on 3/22/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "Categorie.h"

@implementation Categorie

-(id)init {
    
    self.slug = @"";
    self.title = @"";
    self.desc = @"";
    self.categorieId = 0;
    self.parent = 0;
    self.postcount = 0;
    
    return self;
}

@end
