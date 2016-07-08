//
//  UserModel.m
//  Moments
//
//  Created by MDT003MBP on 7/7/16.
//  Copyright © 2016 abc. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"profile-image": @"profileImage",
                                                       @"nick": @"nickName",
                                                       @"username": @"userName"
                                                       }];
}
@end
