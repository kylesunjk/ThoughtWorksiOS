//
//  CommonTools.m
//  iChangi Jbeacon
//
//  Created by Massive on 27/12/14.
//  Copyright (c) 2014 Massive Infinity. All rights reserved.
//

#import "CommonTools.h"

@implementation CommonTools
#pragma mark - data exchange

+ (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

+ (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}

+(NSString *)toJSONString:(id)theData{
    NSString *jsonString = [[NSString alloc] initWithData:[self toJSONData:theData]
                                                 encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    return [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
}

+(NSString *)generateCommonTime{
    double date = [[NSDate date] timeIntervalSince1970] *1000;
    return  [NSString stringWithFormat:@"%f",date];
}

@end
