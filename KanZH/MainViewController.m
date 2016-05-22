//
//  MainViewController.m
//  KanZH
//
//  Created by SW05 on 5/10/16.
//  Copyright © 2016 SW05. All rights reserved.
//

// ** 主控制器的功能：1.配置界面
/*                 2.下载和配置表格
                   3.设置刷新
                   4.代理表格
 */

#import "MainViewController.h"
#import "NewsViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "NewsBatch.h"
#import "NewsBatchCell.h"
#import "Header.h"
#import "ToolBox.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>
// ** 表格相关属性
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *timeStamp;
// ** Hub相关属性
@property (nonatomic, assign) BOOL isLoading;// 是否加载完成
// ** 刷新相关属性
@property (nonatomic, assign) BOOL isRefreshing;// 是否正在刷新
@property (nonatomic, assign) BOOL isLast;// 是否是最后一条可加载数据
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizeNavigationBar];
    [self addTableViewToView];
    [self setTimeStamp:@""];
    [self setDataSource:[NSMutableArray array]];
    [self addRefreshViewToTable];
    [self startLoadingWithActivityView];
}

#pragma mark - 首次加载数据的MBProgressHUD
- (void)startLoadingWithActivityView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Loading...";
    hud.tag = 111;
    [self.view addSubview:hud];

    self.isLoading = YES;
    [self addObserver:self forKeyPath:@"isLoading" options:NSKeyValueObservingOptionNew context:nil];
    [self downloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isLoading"]) {
        if ([[change objectForKey:NSKeyValueChangeNewKey] boolValue] == NO) {
            MBProgressHUD *hud = [self.view viewWithTag:111];
            [hud removeFromSuperview];
            [self removeObserver:self forKeyPath:@"isLoading"];
        }
    }
}

#pragma mark - UI 控件的添加
- (void)customizeNavigationBar {
    self.navigationItem.title = @"看知乎首页";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-nav"]
                                                                             style:UIBarButtonItemStylePlain target:self
                                                                            action:@selector(toggleDrawerLeft)];
    self.navigationController.navigationBar.tintColor = kWhiteColor;
    self.navigationController.navigationBar.barTintColor = kLightBlueColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0],
                                                                    NSForegroundColorAttributeName:[UIColor blueColor]};
}

- (void)addTableViewToView {
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                              style:UITableViewStylePlain];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table registerNib:[UINib nibWithNibName:@"NewsBatchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NewsBatchCell"];
    [self.view addSubview:self.table];
}

- (void)addRefreshViewToTable {
    self.isRefreshing = NO;
    self.isLast = NO;
    __weak typeof(self) weakSelf = self;
    // ** 设置下拉刷新
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_isRefreshing) {
            return ;
        } else {
            self.timeStamp = @"";
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf setIsRefreshing:YES];
            [strongSelf downloadData];
        }
    }];
    // ** 设置上拉刷新
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_isRefreshing) {
            return ;
        } else {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf setIsRefreshing:YES];
            [strongSelf downloadData];
        }
    }];
}

- (void)downloadData {
    // ** 拼接字串，配置URL连接
    NSString *url = [NSString stringWithFormat:kUrlGetposts,self.timeStamp];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // ** 配置Datatask
    NSURLSessionDataTask *task = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // ** 首次或者向上刷新，清空数据，重新加载
        if ([self.timeStamp isEqualToString:@""]) {
            [self.dataSource removeAllObjects];
        }
        // ** 连接成功，如果数据不为空
        if (responseObject) {
            NSString *erro = [responseObject valueForKey:@"error"];
            if ([erro isEqualToString:@""] ) {
                NSArray *posts = [responseObject objectForKey:@"posts"];
                for (NSDictionary *dic in posts) {
                    NewsBatch *batch = [NewsBatch newsBatchWithDictionary:dic];
                    [self.dataSource addObject:batch];
                }
                // ** 更新最后时间戳
                NewsBatch *last = [self.dataSource lastObject];
                self.timeStamp = last.publishtime;
                [self.table reloadData];
            }
        // ** 如果数据为空，不做处理
        } else {
            NSLog(@"Download data error");
        }
        // ** 终止刷新，更新数据
        self.isLoading = NO;
        [self setIsRefreshing:NO];
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Download data fail: %@",error.description);
        // ** 终止刷新
        self.isLoading = NO;
        [self setIsRefreshing:NO];
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
    }];
    [task resume];
}

- (void)toggleDrawerLeft {
    [[AppDelegate globalDelegate] toggleDrawerWithLeftSide];
}

#pragma mark - Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsBatchCell *cell = [self.table dequeueReusableCellWithIdentifier:@"NewsBatchCell" forIndexPath:indexPath];
    [cell showCellWithNewsBatch:self.dataSource[indexPath.row]];
    return cell;
}

#pragma mark - Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsBatch *batch = self.dataSource[indexPath.row];
    CGFloat cWidth  = self.table.frame.size.width - 2 * kCellSpace;
    CGFloat tHeight = [ToolBox toolCalcHeightForString:batch.excerpt Width:cWidth fontSize:10.0];
    return 100.0 + 15.0 + tHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsBatch *batch = self.dataSource[indexPath.row];
    NewsViewController *nvc = [NewsViewController newsViewWithDate:batch.date name:batch.name];
    [self.navigationController pushViewController:nvc animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
