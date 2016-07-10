//
//  TweetsModel.m
//  Moments
//
//  Created by MDT003MBP on 7/7/16.
//  Copyright © 2016 abc. All rights reserved.
//

#import "TweetModel.h"

@implementation TweetModel
-(BOOL) isValidTweet{
    return self.content || self.images;
}
@end

@implementation TweetModelList
@end

