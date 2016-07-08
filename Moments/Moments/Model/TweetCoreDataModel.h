//
//  TweetCoreDataModel.h
//  Moments
//
//  Created by MDT003MBP on 7/7/16.
//  Copyright © 2016 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface TweetCoreDataModel : NSManagedObject

@property (nonatomic , strong) NSString *content;
@property (nonatomic , strong) NSArray  *images;
@property (nonatomic , strong) NSDictionary *sender;
@property (nonatomic , strong) NSArray *comments;
@property (nonatomic , assign) double timestamp;

@end
