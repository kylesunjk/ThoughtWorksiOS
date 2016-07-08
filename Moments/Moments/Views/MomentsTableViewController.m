//
//  MomentsTableViewController.m
//  Moments
//
//  Created by MDT003MBP on 7/7/16.
//  Copyright © 2016 abc. All rights reserved.
//

#import "MomentsTableViewController.h"
#import "MomentService.h"
#import "UserModel.h"
#import "TweetModel.h"


@interface MomentsTableViewController ()<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic , strong) UITableView *momentsTableView;
@property (nonatomic , strong) NSMutableArray *momentsBindingDataArray;

@property (nonnull , strong, nonatomic) UserModel *loginUser;
@end

@implementation MomentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[MomentService getTweetsByUser:@"jsmith"] continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
        
        return t;

    }];
    
    [[MomentService getUserInfoByUserName:@"jsmith"] continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
        NSError *parseError = nil;
        self.loginUser = [[UserModel alloc] initWithString:[t.result valueForKey:@"json"] error:&parseError];
        return t;
    }];

}

-(void) generateMomentsTableview{
    
    self.momentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    
    self.momentsTableView.delegate = self;
    self.momentsTableView.dataSource = self;
    
    [self.view addSubview: self.momentsTableView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.momentsBindingDataArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
