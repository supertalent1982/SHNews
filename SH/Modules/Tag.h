//
//  Tag.h
//  SH
//
//  Created by jwan on 3/22/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject

@property (nonatomic, assign) NSInteger     tagId;
@property (nonatomic, strong) NSString      *slug;
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, strong) NSString      *desc;
@property (nonatomic, assign) NSInteger     postcount;

@end
