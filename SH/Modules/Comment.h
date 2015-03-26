//
//  Comment.h
//  SH
//
//  Created by jwan on 3/22/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, strong) NSString          *date;
@property (nonatomic, strong) NSString          *content;
@property (nonatomic, strong) NSString          *name;
@property (nonatomic, strong) NSString          *url;
@property (nonatomic, strong) NSString          *authorUrl;
@property (nonatomic, assign) NSInteger         commentId;
@property (nonatomic, assign) NSInteger         parent;

@end
