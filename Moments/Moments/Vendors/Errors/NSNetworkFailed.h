//
// Created by Yunarta Kartawahyudi on 29/12/14.
// Copyright (c) 2014 Massive Infinity. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNetworkFailed : NSError

@property(nonatomic, weak) NSError *cause;

+ (instancetype)cause:(NSError *)cause;

@end