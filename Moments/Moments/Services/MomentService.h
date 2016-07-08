//
//  MomentService.h
//  Moments
//
//  Created by MDT003MBP on 7/7/16.
//  Copyright © 2016 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFTask.h"
#import "BFTaskCompletionSource.h"
@interface MomentService : NSObject

+ (BFTask *)loadDataFromPath:(NSString *)path withRange:(NSRange)range;
+ (BFTask *)loadUserInfo:(NSString *)path;
+ (BFTask *)getTweetsByUser:(NSString *)userName;
+ (BFTask *)getUserInfoByUserName:(NSString *)userName;

@end
