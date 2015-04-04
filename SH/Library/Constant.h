//
//  Constant.h
//  NXTTS
//
//  Created by jwan on 3/16/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"

@interface Constant : NSObject

#define APP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate];

#define USERNAME                @"username"
#define USEREMAIL               @"useremail"

#define CATEGORIE_SOAPS         @"none"
#define CATEGORIE_GENERAL       @"general-hospital"
#define CATEGORIE_DAYS          @"days-of-our-lives"
#define CATEGORIE_BOLD          @"bold-and-the-beautiful"
#define CATEGORIE_YOUNG         @"young-and-the-restless"

#define CATEGORIE_NAME_GENERAL  @"General Hospital"
#define CATEGORIE_NAME_DAYS     @"Days of Our Lives"
#define CATEGORIE_NAME_BOLD     @"Bold And The Beautiful"
#define CATEGORIE_NAME_YOUNG    @"Young And The Restless"

#define API_CATEGORIES          @"http://www.soaphub.com/?json=get_category_index"
#define API_ARTICLES            @"http://www.soaphub.com/?json=get_category_posts&slug="
#define API_HOT                 @"http://www.soaphub.com/?json=get_category_posts&slug="

#define GOT_RESPONSE            @"GotResponse"
#define GO_HOME                 @"GoHomePage"
#define SEARCH_RESPONSE         @"SearchResponse"
#define ADD_RESPONSE            @"AddResponse"
#define FAILD_RESPONSE          @"ResponseFailed"

#define APIINDEX_CATEGORIE      0
#define APIINDEX_SOAPS          1
#define APIINDEX_HOT            2
#define APIINDEX_GENERAL        3
#define APIINDEX_DAYS           4
#define APIINDEX_BOLD           5
#define APIINDEX_YOUNG          6

#define NORMAL_BGCOLOR          [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1]
#define BUTTON_FONT             [UIFont fontWithName:@"Museo-300" size:16]
#define TITLE_FONT              [UIFont fontWithName:@"Museo-300" size:28]

#define ENABLE_NOTI             @"Enable_notification"

#define LINE_SPACING            4
#define NORMAL_FONT             [UIFont fontWithName:@"Arial" size:14]

@end
