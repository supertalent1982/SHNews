//
//  AppDelegate.h
//  SH
//
//  Created by jwan on 3/20/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL           mIsNeedAll;
@property (assign, nonatomic) BOOL           mIsStartedTimer;
//@property (assign, nonatomic) BOOL           mIsActivityHome;
@property (assign, nonatomic) BOOL           gotAll;
@property (assign, nonatomic) NSInteger      mApiIndex;
@property (assign, nonatomic) NSInteger      mAddApiIndex;

@property (strong, nonatomic) NSMutableArray *mCategories;
@property (strong, nonatomic) NSMutableArray *mSoaps;
@property (strong, nonatomic) NSMutableArray *mYoungs;
@property (strong, nonatomic) NSMutableArray *mGenerals;
@property (strong, nonatomic) NSMutableArray *mDays;
@property (strong, nonatomic) NSMutableArray *mBold;
@property (strong, nonatomic) NSMutableArray *mHot;
@property (strong, nonatomic) NSMutableArray *mSearch;

@property (strong, nonatomic) NSString       *deviceToken;

- (void)getAllCategories:(BOOL)isNeedAll;
- (void)getCategories:(BOOL)isNeedAll;
- (void)getArticlse:(NSInteger)apiIndex isNeedAll:(BOOL)isNeedAll isTimer:(BOOL)isTimer;
- (NSString *)replaceSpecialCharators:(NSString *)inputStr;

- (void)addArticles:(NSInteger)apiIndex;
- (void)getSearchArticlse:(NSString *)key;
- (void)addSearchArticlse:(NSString *)key;

- (void)backgroundGetArticles;

@end

