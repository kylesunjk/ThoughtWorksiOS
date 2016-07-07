//
// Created by Yunarta Kartawahyudi on 29/12/14.
// Copyright (c) 2014 Massive Infinity. All rights reserved.
//

#import "NSNetworkFailed.h"
#import "error_codes.h"

@implementation NSNetworkFailed {

}

+ (instancetype)cause:(NSError *)cause {
    return [[NSNetworkFailed alloc] init:cause];
}

- (instancetype)init:(NSError *)cause {
    NSDictionary *dict = cause ? @{
            NSLocalizedDescriptionKey : NSLocalizedStringFromTable(@"generic_network_failed", @"error_codes", @"generic_network_failed"),
            NSUnderlyingErrorKey : cause
    } : @{
            NSLocalizedDescriptionKey : NSLocalizedStringFromTable(@"generic_network_failed", @"error_codes", @"generic_network_failed"),
    };

    self = [super initWithDomain:@"User" code:JBeaconErrorNetworkFailed userInfo:dict];
    if (self) {
        self.cause = cause;
    }
    return self;
}

@end