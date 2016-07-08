//
//  TweetsCacheData.h
//  Moments
//
//  Created by MDT003MBP on 7/7/16.
//  Copyright © 2016 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetCoreDataModel.h"
#import "TweetModel.h"
#import <CoreData/CoreData.h>

@interface TweetsCacheData : NSObject
- (TweetModel *)dbLoad:(NSString *)uri;

- (void)dbSave:(NSString *)uri withContent:(NSString *)content withExpiry:(NSDate *)expiry;

- (TweetModel *)dbSave:(NSString *)uri withContent:(NSString *)content;

- (void)dbDelete:(NSString *)uri;

+ (TweetModel *)singleton;
@end
