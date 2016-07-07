//
// Created by Yunarta Kartawahyudi on 29/12/14.
// Copyright (c) 2014 Massive Infinity. All rights reserved.
//

#import "NSDeserializationFailed.h"
#import "error_codes.h"

@implementation NSDeserializationFailed {

}

+ (instancetype)cause:(NSError *)cause {
    return [[NSDeserializationFailed alloc] init:cause];
}

- (instancetype)init:(NSError *)cause {
    NSDictionary *dict = cause ? @{
            NSLocalizedDescriptionKey : NSLocalizedStringFromTable(@"json_deserialization_failed", @"error_codes", @"json_deserialization_failed"),
            NSUnderlyingErrorKey : cause
    } : @{
            NSLocalizedDescriptionKey : NSLocalizedStringFromTable(@"json_deserialization_failed", @"error_codes", @"json_deserialization_failed"),
    };

    self = [super initWithDomain:@"User" code:JBeaconErrorNetworkFailed userInfo:dict];
    if (self) {
        self.cause = cause;
    }
    return self;
}

@end