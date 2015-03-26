//
//  XMLReader.h
//  NXTTS
//
//  Created by jwan on 3/18/15.
//  Copyright (c) 2015 jwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLReader : NSObject
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *errorPointer;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;

@end
