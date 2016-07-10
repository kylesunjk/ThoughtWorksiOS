//
//  MomentsTweetsTableViewCell.m
//  Moments
//
//  Created by MDT003MBP on 8/7/16.
//  Copyright © 2016 abc. All rights reserved.
//

#import "MomentsTweetsTableViewCell.h"
#import "TweetImagesCollectionViewCell.h"
#import "TweetCommentsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MomentsTweetsTableViewCell()<UITableViewDelegate , UITableViewDataSource , UICollectionViewDataSource , UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *tweetImageView;
@property (strong, nonatomic) IBOutlet UILabel *tweetSenderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tweetContentsLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *tweetResourceCollectionView;
@property (strong, nonatomic) IBOutlet UITableView *tweetCommentsTableView;
@property (strong, nonatomic) IBOutlet UIButton *tweetCommentActionButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeightConstraint;
@end

@implementation MomentsTweetsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self addObserver:self forKeyPath:@"tweetObject" options:NSKeyValueObservingOptionInitial context:nil];
    
    self.tweetCommentsTableView.delegate = self;
    self.tweetCommentsTableView.dataSource = self;
    
    self.tweetResourceCollectionView.delegate = self;
    self.tweetResourceCollectionView.dataSource = self;
    
    [self.tweetCommentsTableView registerClass:[TweetCommentsTableViewCell class] forCellReuseIdentifier:@"TweetCommentsTableViewCell"];
    [self.tweetCommentsTableView registerNib:[UINib nibWithNibName:@"TweetCommentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"TweetCommentsTableViewCell"];
    
    [self.tweetResourceCollectionView registerClass:[TweetImagesCollectionViewCell class] forCellWithReuseIdentifier:@"TweetImagesCollectionViewCell"];
    [self.tweetResourceCollectionView registerNib:[UINib nibWithNibName:@"TweetImagesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TweetImagesCollectionViewCell"];
    
    [self.tweetResourceCollectionView setBackgroundColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetObject.comments.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCommentsTableViewCell"];
    UILabel *senderLabel = (UILabel *)[cell viewWithTag:11];
    [senderLabel setText:[NSString stringWithFormat:@"%@ :%@",self.tweetObject.sender.nickName,[[self.tweetObject.comments objectAtIndex:indexPath.row] valueForKey:@"content"]]];
    return cell;
}

-(void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableviewHeightConstraint.constant = tableView.contentSize.height;
    [self layoutIfNeeded];
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tweetObject.images.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TweetImagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TweetImagesCollectionViewCell" forIndexPath:indexPath];
    UIImageView *tweetImageView = (UIImageView *)[cell viewWithTag:11];
    [tweetImageView sd_setImageWithURL:[NSURL URLWithString:[[self.tweetObject.images objectAtIndex:indexPath.row] valueForKey:@"url"]]];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat collectionWidth = [collectionView contentSize].width;
    if (self.tweetObject.images.count == 1) {
        return CGSizeMake(collectionWidth-10, collectionWidth-10);
    }
    else if (self.tweetObject.images.count >4){
        return CGSizeMake(collectionWidth/3-20, collectionWidth/3-20);
    }
    else{
        return CGSizeMake(collectionWidth/2-10, collectionWidth/2-10);
    }
}

-(void) collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    self.collectionHeightConstraint.constant = collectionView.contentSize.height;
    [cell layoutIfNeeded];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    [self.tweetImageView sd_setImageWithURL:[NSURL URLWithString:self.tweetObject.sender.avatar]];
    [self.tweetSenderNameLabel setText:self.tweetObject.sender.nickName];
    [self.tweetContentsLabel setText:self.tweetObject.content];
    if (self.tweetObject.images.count != 0) {
        [self.tweetResourceCollectionView reloadData];
    }

    if (self.tweetObject.comments.count != 0) {
        [self.tweetCommentsTableView reloadData];
    }

//    [self layoutIfNeeded];
}
@end
