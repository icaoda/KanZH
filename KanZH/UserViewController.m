//
//  UserViewController.m
//  KanZH
//
//  Created by SW05 on 5/16/16.
//  Copyright © 2016 SW05. All rights reserved.
//

/* ** 用户详情展示控制器：
    1.下载数据，获取用户的信息
    2.分解数据，创建数据模型
    3.添加控制器，展示数据
    4.实现代理
 */
#import "UserViewController.h"
#import "NewsAnswerViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UserDetail.h"
#import "TopAnswer.h"
#import "UserDetailCell.h"
#import "Polor7View.h"
#import "TopAnswerCell.h"
#import "TrendView.h"
#import "UsrDetailCell.h"
#import "Header.h"

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource>
// ** Hub相关属性
@property (nonatomic, assign) BOOL isLoading;// 是否加载完成
@property (nonatomic, assign) CGFloat percent;// 下载进度
// ** 代表用户唯一的hash值，由其他类传入
@property (nonatomic, copy) NSString *usrhash;
// ** 保存用户的数据模型
@property (nonatomic, strong) UserDetail *usrDetail;
// ** 显示数据的ScrollView
@property (nonatomic, strong) UIScrollView *scrollView;
// ** 表格的数据模型4-segment
@property (nonatomic, strong) NSMutableArray *topAnswers;// top10
@property (nonatomic, strong) NSMutableArray *trendData;// trend
@property (nonatomic, strong) NSDictionary *polorData;// polor7
@property (nonatomic, strong) NSDictionary *usrData;// detail
@property (nonatomic, strong) NSArray *usrDataModel;// dataModel
@end

@implementation UserViewController

// ** Contructor methods
+ (instancetype)userViewControllerWithHash:(NSString *)hash {
    return [[self alloc] initViewControllerWithHans:hash];
}

- (instancetype)initViewControllerWithHans:(NSString *)hash {
    if (self=[super init]) {
        self.usrhash = hash;
    }
    return self;
}

// ** View controller Life cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    // Download Data from server
    [self startLoadingWithActivityView];
}

#pragma mark - 首次加载数据的MBProgressHUD
- (void)startLoadingWithActivityView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.labelText = @"Loading...";
    hud.tag = 111;
    [self.view addSubview:hud];
    
    self.isLoading = YES;
    self.percent = 0.0;
    [self addObserver:self forKeyPath:@"isLoading" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"percent" options:NSKeyValueObservingOptionNew context:nil];
    [self downloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isLoading"]) {
        if ([[change objectForKey:NSKeyValueChangeNewKey] boolValue] == NO) {
            MBProgressHUD *hud = [self.view viewWithTag:111];
            [hud removeFromSuperview];
            [self removeObserver:self forKeyPath:@"isLoading"];
            [self removeObserver:self forKeyPath:@"percent"];
        }
    } else {
        CGFloat percent = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        MBProgressHUD *hub = [self.view viewWithTag:111];
        hub.progress = percent;
    }
}

// ** Download User Data
- (void)downloadData {
    NSString *url = [NSString stringWithFormat:kUrlUserdetail2,self.usrhash];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSURLSessionDataTask *task = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        self.percent = downloadProgress.fractionCompleted;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // ** 下载成功，开始解析
        if (responseObject) {
            // ** 数据不为空
            NSString *erro = [responseObject objectForKey:@"error"];
            if ([erro isEqualToString:@""] == YES) {
                self.usrDetail = [UserDetail userDetailWithDictionary:responseObject];
                [self prepareDataModelForView];
                [self layoutIfDataAvaliable];
            } else {
                // ** 返回异常
            }
        } else {
            // ** 数据空，异常
        }
        // ** 修改全局变量，刷新界面
        [self setIsLoading:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setIsLoading:NO];
    }];
    [task resume];
}
// ** 数据处理，准备数据模型
- (void)prepareDataModelForView {
    // ** 处理top10数据模型
    self.topAnswers = [NSMutableArray array];
    NSArray *topAns = self.usrDetail.topanswers;
    for (NSDictionary *dic in topAns) {
        TopAnswer *ans = [TopAnswer topAnswerWithDictionary:dic];
        [self.topAnswers addObject:ans];
    }
    // ** 处理trend图的数据模型
    self.trendData = [NSMutableArray array];
    NSArray *trend = self.usrDetail.trend;
    NSMutableArray *trendAns = [NSMutableArray array];
    NSMutableArray *trendAgr = [NSMutableArray array];
    NSMutableArray *trendFlo = [NSMutableArray array];
    NSMutableArray *trendDat = [NSMutableArray array];
    for (NSDictionary *dic in trend) {
        [trendAns addObject:dic[@"answer"]];
        [trendAgr addObject:dic[@"agree"]];
        [trendFlo addObject:dic[@"follower"]];
        [trendDat addObject:dic[@"date"]];
    }
    [self.trendData addObject:trendAns];
    [self.trendData addObject:trendAgr];
    [self.trendData addObject:trendFlo];
    [self.trendData addObject:trendDat];
    // ** 处理七星图的数据模型
    self.polorData = self.usrDetail.star;
    // ** 处理详情数据的数据模型
    self.usrData = self.usrDetail.detail;
}

// ** 布局界面
- (void)layoutIfDataAvaliable {
    [self addHeaderView];
    [self addSegmentView];
    [self addContentScrollView];
}

- (void)addHeaderView {
    UserDetailCell *header = [[NSBundle mainBundle] loadNibNamed:@"UserDetailCell" owner:nil options:nil][0];
    header.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 120);
    [header showCellWithUserDetail:self.usrDetail];
    [self.view addSubview:header];
}

- (void)addSegmentView {
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"高票答案",@"一月趋势",@"七星阵",@"详细数据"]];
    segment.frame = CGRectMake(0, 64+120, CGRectGetWidth(self.view.frame), 20);
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
}

- (void)segmentClick:(UISegmentedControl *)sender {
    CGFloat xOffset = (sender.selectedSegmentIndex) * CGRectGetWidth(self.scrollView.frame);
    [self.scrollView setContentOffset:CGPointMake(xOffset, 0)];
}

- (void)addContentScrollView {
    // ** 添加滑动容器视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 204, CGRectGetWidth(self.view.frame),
                                                                     CGRectGetHeight(self.view.frame)-204)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(4*CGRectGetWidth(self.view.frame), CGRectGetHeight(self.scrollView.frame));
    [self.scrollView setScrollEnabled:NO];
    [self.view addSubview:self.scrollView];
    // ** 添加高票答案表格
    [self addTableTop10];
    // ** 添加一月趋势图
    [self addMonthTrendView];
    // ** 添加七星图
    [self addPolor7View];
    // ** 添加详情表格
    [self addDetailUserDataView];
}

- (void)addTableTop10 {
    // ** 添加高票答案表格
    UITableView *tableTop10 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds),
                                                                            CGRectGetHeight(self.scrollView.bounds))];
    [tableTop10 registerNib:[UINib nibWithNibName:@"TopAnswerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TopAnswerCell"];
    tableTop10.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableTop10.separatorColor = [UIColor blackColor];
    tableTop10.delegate = self;
    tableTop10.dataSource = self;
    tableTop10.rowHeight = 45.0;
    tableTop10.backgroundColor = [UIColor whiteColor];
    tableTop10.tag = 100;
    [self.scrollView addSubview:tableTop10];
}

- (void)addMonthTrendView {
    // ** 添加一月趋势图
    UIScrollView *trendView = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0,
                                                                 CGRectGetWidth(self.scrollView.bounds),
                                                                 CGRectGetHeight(self.scrollView.bounds))];
    trendView.backgroundColor = [UIColor whiteColor];
    trendView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), 1000);
    trendView.tag = 101;
    
    NSArray *titles = @[@"回答数+专栏文章数",@"赞同数",@"被关注数"];
    // ** 添加3张趋势图
    for (NSInteger i=0; i<[titles count]; i++) {
        TrendView *trendAns = [[TrendView alloc] initWithFrame:CGRectMake((CGRectGetWidth(trendView.frame)-290)/2, 30+(290+30)*i, 290, 290)];
        trendAns.dateArray = [self.trendData lastObject];
        trendAns.scaleArray = self.trendData[i];
        [trendAns drawTitleWithString:titles[i]];
        [trendView addSubview:trendAns];
    }
    
    [self.scrollView addSubview:trendView];
}

- (void)addPolor7View {
    // ** 添加七星图底幕布
    UIView *popor7 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.bounds)*2, 0,
                                                              CGRectGetWidth(self.scrollView.bounds),
                                                              CGRectGetHeight(self.scrollView.bounds))];
    popor7.backgroundColor = [UIColor whiteColor];
    popor7.tag = 102;
    // ** 添加七星图
    Polor7View *view = [[Polor7View alloc] initWithFrame:CGRectMake((CGRectGetWidth(popor7.frame)-280)/2, 0, 280, 280)];
    view.rankData = self.polorData;
    [popor7 addSubview:view];
    
    [self.scrollView addSubview:popor7];
}

- (void)addDetailUserDataView {
    // ** 获取详情数据模型
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Parameters.plist" ofType:nil];
    self.usrDataModel = [NSArray arrayWithContentsOfFile:path];
    
    // ** 添加详情表格
    UITableView *detailView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.bounds)*3, 0,
                                                                            CGRectGetWidth(self.scrollView.bounds),
                                                                            CGRectGetHeight(self.scrollView.bounds))
                                                           style:UITableViewStyleGrouped];
    [detailView registerClass:[UsrDetailCell class] forCellReuseIdentifier:@"UsrDetailCell"];
    detailView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    detailView.separatorColor = [UIColor blackColor];
    detailView.delegate = self;
    detailView.dataSource = self;
    detailView.rowHeight = 30.0;
    detailView.backgroundColor = kLightBlueColor;
    detailView.tag = 103;
    [self.scrollView addSubview:detailView];
}

#pragma mark - TableView: Data & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 100) {
        return 1;
    } else {
        return self.usrDataModel.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return self.topAnswers.count;
    } else {
        NSDictionary *category = self.usrDataModel[section];
        NSArray *items = [category objectForKey:@"items"];
        return items.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        TopAnswerCell *topAns = [tableView dequeueReusableCellWithIdentifier:@"TopAnswerCell"];
        [topAns showCellWithAnswer:self.topAnswers[indexPath.row]];
        return topAns;
    } else {
        // ** 获取数据模型
        NSDictionary *itemDict = [self.usrDataModel[indexPath.section] objectForKey:@"items"][indexPath.row];
        NSString *name = [itemDict objectForKey:@"name"];
        NSString *item = [itemDict objectForKey:@"item"];
        NSString *scale = [self.usrData objectForKey:item];
        // ** 构造cell模型
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 30);
        UsrDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UsrDetailCell"];
        [cell showCellWithRect:rect name:name scale:scale];
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag != 100) {
        NSDictionary *category = self.usrDataModel[section];
        return [category objectForKey:@"category"];
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return 0;
    } else {
        return 20.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        TopAnswer *ans = self.topAnswers[indexPath.row];
        NSArray *linkComp = [ans.link componentsSeparatedByString:@"/"];
        NewsAnswerViewController *ansVC = [NewsAnswerViewController newsAnserWithQuestion:linkComp[2]
                                                                                   answer:linkComp[4] userHash:nil];
        ansVC.isPost = ans.ispost;
        [self.navigationController pushViewController:ansVC animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
