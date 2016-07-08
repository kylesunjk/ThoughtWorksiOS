//
//  TweetsModel.h
//  Moments
//
//  Created by MDT003MBP on 7/7/16.
//  Copyright © 2016 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import "UserModel.h"

@protocol TweetModel
@end

@interface TweetModel : JSONModel

@property (nonatomic , strong) NSString <Optional> *content;
@property (nonatomic , strong) NSArray <Optional> *images;
@property (nonatomic , strong) UserModel *sender;
@property (nonatomic , strong) NSArray <TweetModel *><Optional> *comments;

@end

@interface TweetModelList : JSONModel

@property (nonatomic , strong) NSMutableArray <TweetModel *> * TweetsList;

@end




