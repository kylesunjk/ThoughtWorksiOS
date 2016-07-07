//
//  CommonTools.h
//  iChangi Jbeacon
//
//  Created by Massive on 27/12/14.
//  Copyright (c) 2014 Massive Infinity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
@interface CommonTools : NSObject
+ (NSData *)toJSONData:(id)theData;

+ (id)toArrayOrNSDictionary:(NSData *)jsonData;

+(NSString *)toJSONString:(id)theData;

+(NSString *)generateCommonTime;

+(NSString *)generateTimePeriod:(NSString *)startTime endStampTime:(NSString *)endTime;

+(NSString *)getCurrentDate;

+(NSString *)getDateString:(NSString*)date ByInputDateformat:(NSString *)incomeFormatString byoutPutDateformat:(NSString *)outcomeFormatString;

+(BOOL)checkNetworkAccess;

+(CLLocationManager *)getCurrentLocaionManager:(id)controller;

+(BOOL)validForSuccessfulResponse:(id)response withError:(NSError *)error;

+ (UIImage *)fixOrientation:(UIImage *)oldImage withImageSize:(float)size;
@end
