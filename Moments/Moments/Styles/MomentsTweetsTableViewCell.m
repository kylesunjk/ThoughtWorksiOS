//
//  MomentsTweetsTableViewCell.m
//  Moments
//
//  Created by MDT003MBP on 8/7/16.
//  Copyright © 2016 abc. All rights reserved.
//

#import "MomentsTweetsTableViewCell.h"
@interface MomentsTweetsTableViewCell()<UITableViewDelegate , UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *tweetImageView;
@property (strong, nonatomic) IBOutlet UILabel *tweetSenderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tweetContentsLabel;
@property (strong, nonatomic) IBOutlet UIView *tweetResourceView;
@property (strong, nonatomic) IBOutlet UITableView *tweetCommentsTableView;
@property (strong, nonatomic) IBOutlet UIButton *tweetCommentActionButton;

@end

@implementation MomentsTweetsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetObject.comments.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc] init];
}
@end
