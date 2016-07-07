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

+(NSString *)generateTimePeriod:(NSString *)startTime endStampTime:(NSString *)endTime{
    NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc] init];
    [startDateFormatter setDateFormat:@"dd MMM yyyy hh:mm"];
    NSDateFormatter *endDateFormatter = [[NSDateFormatter alloc] init];
    [endDateFormatter setDateFormat:@"hh:mm"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[startTime doubleValue]];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[endTime doubleValue]];

    NSString *startFormattedDateString = [startDateFormatter stringFromDate:startDate];
    NSString *endFormattedDateString = [endDateFormatter stringFromDate:endDate];

    return [NSString stringWithFormat:@"%@ - %@",startFormattedDateString,endFormattedDateString];
}

+(NSString *)getCurrentDate{
    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateString = [DateFormatter stringFromDate:[NSDate date]];
    return currentDateString;
}


+(NSString *)getDateString:(NSString*)date ByInputDateformat:(NSString *)incomeFormatString byoutPutDateformat:(NSString *)outcomeFormatString{
    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:incomeFormatString];
    NSDate *changeDate = [DateFormatter dateFromString:date];
    [DateFormatter setDateFormat:outcomeFormatString];
    NSString *currentDateString = [DateFormatter stringFromDate:changeDate];
    return currentDateString;
}

+(BOOL)checkNetworkAccess{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    }
    else{
        return YES;
    }
}

+(CLLocationManager *)getCurrentLocaionManager:(id)controller{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = controller;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        //[self.locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
        [locationManager startUpdatingLocation];

    if (locationManager) {
        return locationManager;
    }
    else{
        return nil;
    }

}

+(BOOL)validForSuccessfulResponse:(id)response withError:(NSError *)error{
    if ([[response valueForKey:@"status"] isEqualToString:@"success"] && !error) {
        return YES;
    }
    else if (![[response valueForKey:@"status"] isEqualToString:@"success"] && error){
        [SimpleAlertView showAlertViewWithMessage:[error localizedDescription]];
        return NO;
    }
    else{
        [SimpleAlertView showAlertViewWithMessage:[response valueForKey:@"message"]];
        return NO;
    }
    
}


+ (UIImage *)fixOrientation:(UIImage *)oldImage withImageSize:(float)size;{
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    float a = oldImage.size.width;
    float b = oldImage.size.height;
    float c = 1;
    if(a<=b){
        c = a/size;
    }else{
        c = b/size;
    }
    
    
    switch (oldImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, oldImage.size.width/c, oldImage.size.height/c);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, oldImage.size.width/c, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, oldImage.size.height/c);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (oldImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, oldImage.size.width/c, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, oldImage.size.height/c, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, oldImage.size.width/c, oldImage.size.height/c,
                                             CGImageGetBitsPerComponent(oldImage.CGImage), 0,
                                             CGImageGetColorSpace(oldImage.CGImage),
                                             CGImageGetBitmapInfo(oldImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (oldImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,oldImage.size.height/c,oldImage.size.width/c), oldImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,oldImage.size.width/c,oldImage.size.height/c), oldImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
