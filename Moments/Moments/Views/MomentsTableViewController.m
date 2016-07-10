//
//  MomentsTableViewController.m
//  Moments
//
//  Created by MDT003MBP on 7/7/16.
//  Copyright © 2016 abc. All rights reserved.
//

#import "MomentsTableViewController.h"
#import <Bolts/BFExecutor.h>
#import "MomentService.h"
#import "UserModel.h"
#import "TweetModel.h"
#import "MomentsProfileTableViewCell.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "MomentsTweetsTableViewCell.h"

#define DATA_LIMITED 5


@interface MomentsTableViewController ()<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic , strong) UITableView *momentsTableView;
@property (nonatomic , strong) NSMutableArray *momentsBindingDataArray;

@property (nonnull , strong, nonatomic) UserModel *loginUser;
@property (assign , nonatomic) NSInteger pageNumber;
@end

@implementation MomentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewControllerStyle];
    [self generateMomentsTableview];
    self.pageNumber = 0;
    __weak typeof(self) weakSelf = self;

    [self.momentsTableView addPullToRefreshWithActionHandler:^{
        weakSelf.momentsBindingDataArray = [[NSMutableArray alloc] init];
        weakSelf.momentsTableView.showsPullToRefresh = NO;
        [[BFTask taskForCompletionOfAllTasks:@[[weakSelf getCurrentUserInfoWithUserName:@"jsmith"],[weakSelf getTweets:@"jsmith" withRange:NSMakeRange(DATA_LIMITED*weakSelf.pageNumber, DATA_LIMITED)]]] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull t) {
            [weakSelf.momentsTableView reloadData];
            [weakSelf.momentsTableView.pullToRefreshView stopAnimating];
            weakSelf.momentsTableView.showsPullToRefresh = YES;
            weakSelf.pageNumber = 1;
            return nil;
        }];
    }];
    
    [self.momentsTableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.momentsTableView.showsInfiniteScrolling = NO;
        [[[weakSelf getTweets:@"jsmith" withRange:NSMakeRange(DATA_LIMITED*weakSelf.pageNumber, DATA_LIMITED)]continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {

            return t;
        }] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull t) {
            weakSelf.pageNumber = weakSelf.pageNumber+1;
            [weakSelf.momentsTableView reloadData];
            [weakSelf.momentsTableView.infiniteScrollingView stopAnimating];
            weakSelf.momentsTableView.showsInfiniteScrolling = t == nil?NO:YES;
            return nil;
        }];
    }];
    
    [self.momentsTableView triggerPullToRefresh];

}

-(void) generateMomentsTableview{
    
    self.momentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-50) style:UITableViewStylePlain];
    
    self.momentsTableView.estimatedRowHeight = 44.;
    self.momentsTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.momentsTableView.delegate = self;
    self.momentsTableView.dataSource = self;
    
    [self.view addSubview: self.momentsTableView];

}

- (void)setViewControllerStyle{
    self.title = @"Moments";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

-(BFTask *)getCurrentUserInfoWithUserName:(NSString *)name{
    return [[MomentService getUserInfoByUserName:name ] continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
        NSError *parseError = nil;
        self.loginUser = [[UserModel alloc] initWithString:[t.result valueForKey:@"json"] error:&parseError];
        return t;
    }];
}

-(BFTask *)getTweets:(NSString *)userName withRange:(NSRange)tweetRange{
    return [[MomentService getTweetsByUser:userName withRange:tweetRange] continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
        self.momentsBindingDataArray = [[self.momentsBindingDataArray arrayByAddingObjectsFromArray:t.result] mutableCopy];
        return t;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.momentsBindingDataArray.count+1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        MomentsProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MomentsProfileTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MomentsProfileTableViewCell" owner:self options:nil] objectAtIndex:0];
            }
        cell.user  = self.loginUser;
        return cell;
        
    }
    else{
        MomentsTweetsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MomentsTweetsTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MomentsTweetsTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.tweetObject = [self.momentsBindingDataArray objectAtIndex:indexPath.row-1];
        return cell;
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
