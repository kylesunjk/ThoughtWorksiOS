//
//  UserModel.h
//  Moments
//
//  Created by MDT003MBP on 7/7/16.
//  Copyright © 2016 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
@interface UserModel : JSONModel

@property (nonatomic , strong) NSString<Optional> *profileImage;
@property (nonatomic , strong) NSString<Optional> *avatar;
@property (nonatomic , strong) NSString<Optional> *nickName;
@property (nonatomic , strong) NSString *userName;

@end
