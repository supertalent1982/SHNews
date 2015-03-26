//
//  ImpelWebServiceAPI.m
//  Impel
//
//  Created by menghu on 11/2/14.
//  Copyright (c) 2014 menghu. All rights reserved.
//

#import "WebServiceAPI.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "SBJsonParser.h"

static WebServiceAPI *instance = nil;

@implementation WebServiceAPI

+ (WebServiceAPI *)sharedInstance
{
    if (instance == nil) {
        instance = [[WebServiceAPI alloc] init];
    }
    
    return instance;
}

+ (NSMutableURLRequest *)imageRequestWithURL:(NSURL *)url {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad; //NSURLRequestUseProtocolCachePolicy
    request.HTTPShouldHandleCookies = NO;
    request.HTTPShouldUsePipelining = YES;
    request.timeoutInterval = 10;
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    return request;
}

- (void)loadActivity:(UIView*)view
{
    //    LoadingView *loadingView = [[LoadingView alloc] init];
    //    [loadingView setFrame:view.bounds];
    //    [loadingView setAlpha:1.0];
    //    [view addSubview:loadingView];
}

- (void)removeActivity:(UIView*)parent
{
    //    LoadingView *loadView;
    //
    //    for(UIView *view in parent.subviews)
    //    {
    //        if([view isKindOfClass:[LoadingView class]])
    //        {
    //            loadView = (LoadingView*)view;
    //            [loadView removeFromSuperview];
    //        }
    //    }
}

- (NSMutableArray *) getAllImages
{
    NSString *url_string = [[NSString alloc] initWithFormat:@"%@",
                            WEBSERVICE_GET_ALLIMAGES
                            ];
    
    url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_string]];
    
    if(data) {
        NSDictionary *myJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"RESPONSE %@", myJson);        
        NSInteger result = [[myJson valueForKey:@"success"] integerValue];
        if (result == 1) {
            NSMutableArray *array = [myJson objectForKey:@"data"];
            return array;
        }
        else
        {
            return nil;
        }
    }
    
    return nil;
}

- (NSMutableArray *) getAllNews
{
    NSString *url_string = [[NSString alloc] initWithFormat:@"%@",
                            WEBSERVICE_GET_ALLNEWS
                            ];
    
    url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_string]];
    
    if(data) {
        NSDictionary *myJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"RESPONSE %@", myJson);
        
        NSInteger result = [[myJson valueForKey:@"success"] integerValue];
        if (result == 1) {
            NSMutableArray *array = [myJson objectForKey:@"data"];
            return array;
        }
        else
        {
            return nil;
        }
    }
    
    return nil;
}

- (NSMutableArray *) getAllVideos
{
    NSString *url_string = [[NSString alloc] initWithFormat:@"%@",
                            WEBSERVICE_GET_ALLVIDEOS
                            ];
    
    url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_string]];
    
    if(data) {
        NSDictionary *myJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"RESPONSE %@", myJson);
        
        NSInteger result = [[myJson valueForKey:@"success"] integerValue];
        if (result == 1) {
            NSMutableArray *array = [myJson objectForKey:@"data"];
            return array;
        }
        else
        {
            return nil;
        }
    }
    
    return nil;
}

@end