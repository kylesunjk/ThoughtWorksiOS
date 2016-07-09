//
//  MomentsProfileTableViewCell.m
//  Moments
//
//  Created by MDT003MBP on 8/7/16.
//  Copyright © 2016 abc. All rights reserved.
//

#import "MomentsProfileTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MomentsProfileTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *profileBackgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;

@end
@implementation MomentsProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addObserver:self forKeyPath:@"user" options:NSKeyValueObservingOptionInitial context:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    [self refreashData];
}

- (void)refreashData{
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:self.user.avatar]];
    
    [self.profileBackgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.user.profileImage]];
    
    [self.nickNameLabel setText:self.user.nickName];
    
}

-(void)dealloc{
    @try {
        [self removeObserver:self forKeyPath:@"user"];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
