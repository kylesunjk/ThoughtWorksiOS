//
// Created by Ethan Hunt on 4/4/14.
// Copyright (c) 2014 Massive Infinity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDCache.h"

@interface MICacheData : NSObject {
}

- (CDCache *)dbLoad:(NSString *)uri;

- (CDCache *)dbLoadWithIndex:(NSInteger)index;

- (void)dbSave:(NSString *)uri withContent:(NSString *)content withExpiry:(NSDate *)expiry;

- (CDCache *)dbSaveWithIndex:(NSInteger)index withContent:(NSDictionary *)content;

- (CDCache *)dbSave:(NSString *)uri withContent:(NSString *)content;

- (void)dbDelete:(NSString *)uri;

+ (MICacheData *)singleton;
@end