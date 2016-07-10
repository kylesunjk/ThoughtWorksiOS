//
//  MomentService.m
//  Moments
//
//  Created by MDT003MBP on 7/7/16.
//  Copyright © 2016 abc. All rights reserved.
//

#import "MomentService.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "CDCache.h"
#import "MICacheData.h"
#import "CommonTools.h"
#import "TweetModel.h"
@implementation MomentService

/*!
 * @discussion load data from service or local database if have.
 * @param path The url path for service
 * @warning
 * @return The whole function package as a task
 */
+ (BFTask *)loadDataFromPath:(NSString *)path withRange:(NSRange)range{
    return [[BFTask taskWithResult:path] continueWithBlock:^id(BFTask *task) {
        NSMutableArray *tweetsArray = [[NSMutableArray alloc] init];
        NSInteger count = 0;
        CDCache *objectCache = [[MICacheData singleton] dbLoadWithIndex:range.location + count];
        
        if (objectCache == nil) {

            BFTaskCompletionSource *source = [BFTaskCompletionSource taskCompletionSource];
            NSString *postingUrl = [MOMENTS_DOMAIN stringByAppendingString:path];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            NSMutableArray *tasks = [NSMutableArray array];
            
            [manager GET:postingUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [source setResult:responseObject];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [source setError:error];
            }];
            
            return [[source task] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
                NSMutableArray<TweetModel*> *array = [[NSMutableArray<TweetModel *> alloc] init];
                NSInteger index = 0;

                for (NSDictionary *tweetDic in t.result) {

                    NSError *parseError = nil;
                    TweetModel *tweetModel = [[TweetModel alloc] initWithDictionary:tweetDic error:&parseError];
                    if (!parseError && [tweetModel isValidTweet]) {
                        [array addObject:tweetModel];
                        [tasks addObject:[self savingIntoDatabaseWithIndex:index withContents:tweetDic]];
                        index = index+1;
                    }
                }
                [source setResult:[array subarrayWithRange:range]];
                return [source task];
            }];
            

        }
        else {
            while (tweetsArray.count < range.length) {
                
                CDCache *objectCache = [[MICacheData singleton] dbLoadWithIndex:range.location + count];
                TweetModel *tweetModel = [[TweetModel alloc] initWithDictionary:objectCache.contents error:nil];
                [tweetsArray addObject:tweetModel];
                count = count + 1;
                
            }
            return [BFTask taskWithResult:tweetsArray];
        }
    }];
}



+ (BFTask *)loadUserInfo:(NSString *)path{
    return [[BFTask taskWithResult:path] continueWithBlock:^id(BFTask *task) {
       CDCache *objectCache = [[MICacheData singleton] dbLoad:path];
        if (objectCache == nil || (double) [[NSDate date] timeIntervalSince1970] - [objectCache.timestamp doubleValue] > 60) {
            
            BFTaskCompletionSource *source = [BFTaskCompletionSource taskCompletionSource];
            NSString *postingUrl = [MOMENTS_DOMAIN stringByAppendingString:path];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            [manager GET:postingUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSData *data = [CommonTools toJSONData:responseObject];
                NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                CDCache *cache = [[MICacheData singleton] dbSave:[MOMENTS_DOMAIN stringByAppendingString:path] withContent:json];
                [source setResult:cache];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [source setError:error];
            }];
            
            return [source task];
        }
        else {
            return [BFTask taskWithResult:objectCache];
        }
    }];
}



+ (BFTask *)savingIntoDatabaseWithIndex:(NSInteger) index withContents:(NSDictionary *)dic{
    
    return [[BFTask taskWithResult:nil] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
        [[MICacheData singleton] dbSaveWithIndex:index withContent:dic];
        return [BFTaskCompletionSource taskCompletionSource].task;
    }];
}


+ (BFTask *)checkInternetAccess{
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        return [[BFTaskCompletionSource taskCompletionSource] setResult:[NSNumber numberWithInteger:status]];
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return [BFTaskCompletionSource taskCompletionSource].task;
    
}


+ (BFTask *)getTweetsByUser:(NSString *)userName withRange:(NSRange)range{
    
    return [MomentService loadDataFromPath:[NSString stringWithFormat:@"%@/%@",userName,@"tweets"] withRange:range];
}

+ (BFTask *)getUserInfoByUserName:(NSString *)userName{
    
    return [MomentService loadUserInfo:userName];
    
}
@end
