//
//  AppDelegate.m
//  SH
//
//  Created by jwan on 3/20/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import "AppDelegate.h"

#import "SplashViewController.h"
#import "Article.h"
#import "RSNetworkClient.h"
#import "Constant.h"

#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate ()

@property (nonatomic, strong) SplashViewController      *splashViewController;
@property (nonatomic, strong) UINavigationController    *navController;

@end

@implementation AppDelegate

@synthesize mIsNeedAll;
@synthesize mApiIndex;
@synthesize mAddApiIndex;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.deviceToken = @"";
    self.mIsStartedTimer = NO;
//    self.mIsActivityHome = NO;
    self.gotAll = NO;
    self.mSearch = [NSMutableArray array];
    self.mSoaps = [NSMutableArray array];
    self.mGenerals = [NSMutableArray array];
    self.mYoungs = [NSMutableArray array];
    self.mDays = [NSMutableArray array];
    self.mBold = [NSMutableArray array];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.splashViewController = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.splashViewController];
    
    [_navController setNavigationBarHidden:YES];
    
    self.window.rootViewController = _navController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* deviceTokenStr = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString: @"<>"]] stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"My token is: %@", deviceTokenStr);
    
    self.deviceToken = deviceTokenStr;
}

- (void)getSearchClientResponse:(NSDictionary *)response
{
    //    NSLog(@"Login-- RESPONSE %@",response);
    if(!response){
        [[NSNotificationCenter defaultCenter] postNotificationName:FAILD_RESPONSE object:nil];
    } else {
        NSString *status = [response objectForKey:@"status"];
        if(status && [status.lowercaseString isEqualToString:@"ok"]) {
            NSInteger count = [[response objectForKey:@"count"] integerValue];
            if(count == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_RESPONSE object:nil];
            } else {
                [self setSearchArticleList:response];
            }
        }
    }
}

- (void)addSearchClientResponse:(NSDictionary *)response
{
    //    NSLog(@"Login-- RESPONSE %@",response);
    if(!response){
        [[NSNotificationCenter defaultCenter] postNotificationName:FAILD_RESPONSE object:nil];
    } else {
        NSString *status = [response objectForKey:@"status"];
        if(status && [status.lowercaseString isEqualToString:@"ok"]) {
            
            NSInteger count = [[response objectForKey:@"count"] integerValue];
            if(count == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_RESPONSE object:nil];
            } else {
                [self addSearchArticleList:response];
            }
        }
    }
}

- (void)getClientResponse:(NSDictionary *)response
{
//    NSLog(@"Login-- RESPONSE %@",response);
    if(!response){
//        if(self.mIsActivityHome)
            [[NSNotificationCenter defaultCenter] postNotificationName:GOT_RESPONSE object:nil];
    } else {
        NSString *status = [response objectForKey:@"status"];
        if(status && [status.lowercaseString isEqualToString:@"ok"]) {
            
            if(mApiIndex == APIINDEX_CATEGORIE) {
                [self setCategorieList:response];
            } else {
                [self setArticleList:response];
            }
        }
        
        if(mIsNeedAll) {
            mApiIndex++;
            [self getArticlse:mApiIndex isNeedAll:mIsNeedAll isTimer:self.mIsStartedTimer];
        } else {
//            if(self.mIsActivityHome)
                [[NSNotificationCenter defaultCenter] postNotificationName:GOT_RESPONSE object:nil];
        }
        
    }
}

- (void)addClientResponse:(NSDictionary *)response
{
    //    NSLog(@"Login-- RESPONSE %@",response);
    if(!response){
        [[NSNotificationCenter defaultCenter] postNotificationName:FAILD_RESPONSE object:nil];
    } else {
        NSString *status = [response objectForKey:@"status"];
        if(status && [status.lowercaseString isEqualToString:@"ok"]) {
            
            NSInteger count = [[response objectForKey:@"count"] integerValue];
            if(count == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ADD_RESPONSE object:nil];
            } else {
                [self addArticleList:response];
            }
        }
    }
}

- (void)getCategories:(BOOL)isNeedAll {
    
    mIsNeedAll = isNeedAll;
    mApiIndex = APIINDEX_CATEGORIE;
    RSNetworkClient *client = [[RSNetworkClient alloc] init];
    [client setDelegate:self];
    [client setSelector:@selector(getClientResponse:)];
    
    NSString *URLstring = API_CATEGORIES;
    URLstring = [URLstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    URLstring = [URLstring stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    [client sendRequest:URLstring];
}

- (void)backgroundGetArticles {
    self.mIsStartedTimer = YES;
    mAddApiIndex = APIINDEX_SOAPS;
    [self getArticlse:APIINDEX_SOAPS isNeedAll:YES isTimer:YES];
}

- (void)getArticlse:(NSInteger)apiIndex isNeedAll:(BOOL)isNeedAll isTimer:(BOOL)isTimer {
    
    if(!isTimer && self.mIsStartedTimer) {
//        if(self.mIsActivityHome)
            [[NSNotificationCenter defaultCenter] postNotificationName:GOT_RESPONSE object:nil];
        return;
    }

    mIsNeedAll = isNeedAll;
    mApiIndex = apiIndex;
    
    NSString *slug = @"";
    NSInteger count = 10;
    switch (mApiIndex) {
            
        case APIINDEX_SOAPS:
            slug = CATEGORIE_SOAPS;
            count = self.mSoaps.count;
            break;
        
        case APIINDEX_HOT:
            slug = @"HOT";
            count = self.mHot.count;
            break;
            
        case APIINDEX_GENERAL:
            slug = CATEGORIE_GENERAL;
            count = self.mGenerals.count;
            break;
            
        case APIINDEX_DAYS:
            slug = CATEGORIE_DAYS;
            count = self.mDays.count;
            break;
            
        case APIINDEX_YOUNG:
            slug = CATEGORIE_YOUNG;
            count = self.mYoungs.count;
            break;
            
        case APIINDEX_BOLD:
            slug = CATEGORIE_BOLD;
            count = self.mBold.count;
            break;
            
        default:
            break;
    }
    
    if(slug.length == 0) {
        NSLog(@"Invalide parameter ====== no such as API_INDEX");
//        if(self.mIsActivityHome)
            [[NSNotificationCenter defaultCenter] postNotificationName:GOT_RESPONSE object:nil];
        
        self.mIsStartedTimer = NO;
        self.gotAll = YES;
        return;
    }
    
    if(count == 0) count = 10;
    RSNetworkClient *client = [[RSNetworkClient alloc] init];
    [client setDelegate:self];
    [client setSelector:@selector(getClientResponse:)];
    
    NSString *URLstring = [NSString stringWithFormat:@"%@%@&count=%d&status=publish", API_ARTICLES, slug, count];
    if([slug isEqualToString:@"HOT"]) {
        URLstring = @"http://www.soaphub.com/api/get_hot_posts/";
    } else if([slug isEqualToString:CATEGORIE_SOAPS]) {
        URLstring = [NSString stringWithFormat:@"http://www.soaphub.com/?json=1&count=%d", count];
    }
        
    
    URLstring = [URLstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    URLstring = [URLstring stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    [client sendRequest:URLstring];
}

- (void)getSearchArticlse:(NSString *)key {
    
    NSInteger count = self.mSearch.count;
    if(count == 0) count = 10;
    RSNetworkClient *client = [[RSNetworkClient alloc] init];
    [client setDelegate:self];
    [client setSelector:@selector(getSearchClientResponse:)];
    
    NSString *URLstring = [NSString stringWithFormat:@"http://www.soaphub.com/?json=get_search_results&count=%d&search=%@", count, key];
    
    URLstring = [URLstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [client sendRequest:URLstring];
}

- (void)addSearchArticlse:(NSString *)key {
    
    NSInteger page = self.mSearch.count / 10;
    page++;
    if((self.mSearch.count % 10) != 0) page++;
    
    RSNetworkClient *client = [[RSNetworkClient alloc] init];
    [client setDelegate:self];
    [client setSelector:@selector(addSearchClientResponse:)];
    
    NSString *URLstring = [NSString stringWithFormat:@"http://www.soaphub.com/?json=get_search_results&count=10&search=%@&page=%d", key, page];
    
    URLstring = [URLstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [client sendRequest:URLstring];
}

- (void)addArticles:(NSInteger)apiIndex {
    
    mAddApiIndex = apiIndex;
    
    NSString *slug = @"";
    NSInteger pageCount = 1;
    switch (mAddApiIndex) {
            
        case APIINDEX_SOAPS:
            slug = CATEGORIE_SOAPS;
            pageCount = self.mSoaps.count / 10;
            if((self.mSoaps.count % 10) != 0) pageCount++;
            break;
            
        case APIINDEX_GENERAL:
            slug = CATEGORIE_GENERAL;
            pageCount = self.mGenerals.count / 10;
            if((self.mGenerals.count % 10) != 0) pageCount++;
            break;
            
        case APIINDEX_DAYS:
            slug = CATEGORIE_DAYS;
            pageCount = self.mDays.count / 10;
            if((self.mDays.count % 10) != 0) pageCount++;
            break;
            
        case APIINDEX_YOUNG:
            slug = CATEGORIE_YOUNG;
            pageCount = self.mYoungs.count / 10;
            if((self.mYoungs.count % 10) != 0) pageCount++;
            break;
            
        case APIINDEX_BOLD:
            slug = CATEGORIE_BOLD;
            pageCount = self.mBold.count / 10;
            if((self.mBold.count % 10) != 0) pageCount++;
            break;
            
        default:
            break;
    }
    pageCount++;
    
    RSNetworkClient *client = [[RSNetworkClient alloc] init];
    [client setDelegate:self];
    [client setSelector:@selector(addClientResponse:)];
    
    NSString *URLstring = [NSString stringWithFormat:@"%@%@&count=10&status=publish&page=%d", API_ARTICLES, slug, pageCount];
    if(mAddApiIndex == APIINDEX_SOAPS) {
        URLstring = [NSString stringWithFormat:@"http://www.soaphub.com/?json=1&page=%d", pageCount];
    }
    
    URLstring = [URLstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    URLstring = [URLstring stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    [client sendRequest:URLstring];
}

- (void)setCategorieList:(NSDictionary *)response {
    
    [self setMCategories:[NSMutableArray array]];
    NSArray *categories = [response objectForKey:@"categories"];
    for(NSDictionary *categore in categories) {
        Categorie *c = [[Categorie alloc] init];
        NSString *slug = [categore objectForKey:@"slug"];
        if(!slug) continue;
        
        if([slug isEqualToString:CATEGORIE_BOLD] ||
           [slug isEqualToString:CATEGORIE_DAYS] ||
           [slug isEqualToString:CATEGORIE_SOAPS] ||
           [slug isEqualToString:CATEGORIE_GENERAL] ||
           [slug isEqualToString:CATEGORIE_YOUNG]) {
            
            c.parent = [[categore objectForKey:@"parent"] integerValue];
            c.categorieId = [[categore objectForKey:@"id"] integerValue];
            c.slug = slug;
            c.title = [categore objectForKey:@"title"];
            c.desc = [categore objectForKey:@"description"];
            c.postcount = [[categore objectForKey:@"post_count"] integerValue];
            
            [self.mCategories addObject:c];
        }
    }
    
}

- (void)setSearchArticleList:(NSDictionary *)response {
    [self setMSearch:[self getArticleArray:response]];
    [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_RESPONSE object:nil];
}

- (void)addSearchArticleList:(NSDictionary *)response {
    [self.mSearch addObjectsFromArray:[self getArticleArray:response]];
    [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_RESPONSE object:nil];
}

- (void)setArticleList:(NSDictionary *)response {

    NSMutableArray *array = [self getArticleArray:response];
    
    switch (mApiIndex) {
            
        case APIINDEX_SOAPS:
            self.mSoaps = [NSMutableArray arrayWithArray:array];
            break;
            
        case APIINDEX_GENERAL:
            self.mGenerals = [NSMutableArray arrayWithArray:array];
            break;
            
        case APIINDEX_DAYS:
            self.mDays = [NSMutableArray arrayWithArray:array];
            break;
            
        case APIINDEX_YOUNG:
            self.mYoungs = [NSMutableArray arrayWithArray:array];
            break;
            
        case APIINDEX_BOLD:
            self.mBold = [NSMutableArray arrayWithArray:array];
            break;
            
        case APIINDEX_HOT:
            self.mHot = [NSMutableArray arrayWithArray:array];
            break;
            
        default:
            break;
    }
    
    if(mIsNeedAll && (mApiIndex == APIINDEX_HOT) ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_HOME object:nil];
    }
}

- (void)addArticleList:(NSDictionary *)response {
    
    
    NSMutableArray *array = [self getArticleArray:response];
    
    switch (mAddApiIndex) {
            
        case APIINDEX_SOAPS:
            [self.mSoaps addObjectsFromArray:array];
            break;
            
        case APIINDEX_GENERAL:
            [self.mGenerals addObjectsFromArray:array];
            break;
            
        case APIINDEX_DAYS:
            [self.mDays addObjectsFromArray:array];
            break;
            
        case APIINDEX_YOUNG:
            [self.mYoungs addObjectsFromArray:array];
            break;
            
        case APIINDEX_BOLD:
            [self.mBold addObjectsFromArray:array];
            break;
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ADD_RESPONSE object:nil];
}

- (NSMutableArray *)getArticleArray:(NSDictionary *)response {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *responseArray = [response objectForKey:@"posts"];
    
    for(NSDictionary *article in responseArray) {
        
        Article *a = [[Article alloc] init];
        NSDictionary *author = [article objectForKey:@"author"];
        a.author.slug = [author objectForKey:@"slug"];
        a.author.url = [author objectForKey:@"url"];
        a.author.authorId = [[author objectForKey:@"id"] integerValue];
        a.author.nickname = [author objectForKey:@"nickname"];
        a.author.lastname = [author objectForKey:@"last_name"];
        a.author.desc = [author objectForKey:@"description"];
        a.author.name = [author objectForKey:@"name"];
        a.author.firstname = [author objectForKey:@"first_name"];
        
        a.modified = [article objectForKey:@"modified"];
        a.slug = [article objectForKey:@"slug"];
        a.thumbnail = [article objectForKey:@"thumbnail"];
        NSString *title = [article objectForKey:@"title"];
        a.title = [self replaceSpecialCharators:title];
        a.url = [article objectForKey:@"url"];
        
        for(NSDictionary *tag in [article objectForKey:@"tags"]) {
            Tag *t = [[Tag alloc] init];
            t.tagId = [[tag objectForKey:@"id"] integerValue];
            t.slug = [tag objectForKey:@"slug"];
            NSString *title = [tag objectForKey:@"title"];
            t.title = [self replaceSpecialCharators:title];
            t.desc = [tag objectForKey:@"description"];
            t.postcount = [[tag objectForKey:@"post_count"] integerValue];
            
            [a.tagArray addObject:t];
        }
        
        a.commentstatus = [article objectForKey:@"comment_status"];
        a.status = [article objectForKey:@"status"];
        a.thumbnailsize = [article objectForKey:@"thumbnail_size"];
        a.type = [article objectForKey:@"type"];
        a.articleId = [[article objectForKey:@"id"] integerValue];
        a.date = [article objectForKey:@"date"];
        a.titleplain = [article objectForKey:@"title_plain"];
        
        for(NSDictionary *comment in [article objectForKey:@"comments"]) {
            Comment *c = [[Comment alloc] init];
            c.date = [comment objectForKey:@"date"];
            c.commentId = [[comment objectForKey:@"id"] integerValue];
            c.content = [comment objectForKey:@"content"];
            c.name = [comment objectForKey:@"name"];
            c.url = [comment  objectForKey:@"url"];
            c.parent = [[comment objectForKey:@"parent"] integerValue];
            c.authorUrl = [comment objectForKey:@"author_pic"];
            
            [a.commentArray addObject:c];
        }
        
        a.excerpt = [article objectForKey:@"excerpt"];
        a.content = [article objectForKey:@"content"];
        
        for(NSDictionary *categore in [article objectForKey:@"categories"]) {
            
            Categorie *c  = [[Categorie alloc] init];
            c.parent = [[categore objectForKey:@"parent"] integerValue];
            c.categorieId = [[categore objectForKey:@"id"] integerValue];
            c.slug = [categore objectForKey:@"slug"];
            NSString *title = [categore objectForKey:@"title"];
            c.title = [self replaceSpecialCharators:title];
            c.desc = [categore objectForKey:@"description"];
            c.postcount = [[categore objectForKey:@"post_count"] integerValue];
            
            [a.categorieArray addObject:c];
        }
        
        NSDictionary *thumbnail_images = [article objectForKey:@"thumbnail_images"];
        if(![thumbnail_images isEqual:[NSNull null]]) {
            NSDictionary *thumbDic = [thumbnail_images objectForKey:@"thumbnail"];
            if(thumbDic) {
                a.thumb.url = [thumbDic objectForKey:@"url"];
                a.thumb.width = [[thumbDic objectForKey:@"width"] integerValue];
                a.thumb.height = [[thumbDic objectForKey:@"height"] integerValue];
            }
        }
        
        [array addObject:a];
    }
    
    return array;
}

- (NSString *)replaceSpecialCharators:(NSString *)inputStr {
    NSString *ret = [[[[[[[[inputStr stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"] stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"-"] stringByReplacingOccurrencesOfString:@"&#8221;" withString:@"\""] stringByReplacingOccurrencesOfString:@"&#8220;" withString:@"\""] stringByReplacingOccurrencesOfString:@"&#8216;" withString:@"'"] stringByReplacingOccurrencesOfString:@"&#038;" withString:@"&"] stringByReplacingOccurrencesOfString:@"&#8230;" withString:@"..."] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    return ret;
}

@end
