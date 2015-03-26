//
//  NetworkClient.h
//
//
//  Created by Yang Zhang on 27/1/14.
//  Copyright (c) 2014 Zhang Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WEBSERVICE_GET_ALLIMAGES  @"http://blrserver.com/media/getAllAlbumPhotos.php"
#define WEBSERVICE_GET_ALLNEWS  @"http://blrserver.com/media/getAllNews.php"
#define WEBSERVICE_GET_ALLVIDEOS @"http://blrserver.com/media/getAllVideos.php"
#define IMAGE_URL @"http://blrserver.com/media/images/"

@interface WebServiceAPI : NSObject

+ (WebServiceAPI *)sharedInstance;

//image requests
+ (NSMutableURLRequest *)imageRequestWithURL:(NSURL *)url;

- (NSMutableArray *) getAllImages;
- (NSMutableArray *) getAllNews;
- (NSMutableArray *) getAllVideos;

@end