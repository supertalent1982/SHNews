//
//  Author.h
//  SH
//
//  Created by jwan on 3/22/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Author : NSObject

@property (nonatomic, strong) NSString  *slug;
@property (nonatomic, strong) NSString  *url;
@property (nonatomic, strong) NSString  *nickname;
@property (nonatomic, strong) NSString  *lastname;
@property (nonatomic, strong) NSString  *firstname;
@property (nonatomic, strong) NSString  *desc;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, assign) NSInteger authorId;

@end
