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
#import "AFNetworking.h"
#import "UserDetail.h"
#import "TopAnswer.h"
#import "UserDetailCell.h"
#import "Polor7View.h"
#import "TopAnswerCell.h"
#import "TrendView.h"
#import "Header.h"

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource>
// ** 代表用户唯一的hash值，由其他类传入
@property (nonatomic, copy) NSString *usrhash;
// ** 保存用户的数据模型
@property (nonatomic, strong) UserDetail *usrDetail;
// ** 显示数据的ScrollView
@property (nonatomic, strong) UIScrollView *scrollView;
// ** 表格的数据模型
@property (nonatomic, strong) NSMutableArray *topAnswers;
@property (nonatomic, strong) NSMutableArray *usrData;
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
    [self downloadData];
}
// ** Download User Data
- (void)downloadData {
    NSString *url = [NSString stringWithFormat:kUrlUserdetail2,self.usrhash];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSURLSessionDataTask *task = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // ** 下载成功，开始解析
        if (responseObject) {
            // ** 数据不为空
            NSString *erro = [responseObject objectForKey:@"error"];
            if ([erro isEqualToString:@""] == YES) {
                self.usrDetail = [UserDetail userDetailWithDictionary:responseObject];
                NSLog(@"%@",self.usrDetail);
                [self prepareDataModelForView];
                [self layoutIfDataAvaliable];
            } else {
                // ** 返回异常
            }
        } else {
            // ** 数据空，异常
        }
        // ** 修改全局变量，刷新界面
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
    // **
}

// ** 布局界面
- (void)layoutIfDataAvaliable {
    [self addHeaderView];
    [self addSegmentView];
    [self addContentScrollView];
}

- (void)addHeaderView {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"UserDetailCell" owner:nil options:nil];NSLog(@"%@",arr);
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
    NSLog(@"seg  -- %ld",sender.selectedSegmentIndex);NSLog(@"offset:%@",NSStringFromCGPoint(self.scrollView.contentOffset));
    CGFloat xOffset = (sender.selectedSegmentIndex) * CGRectGetWidth(self.scrollView.frame);
    [self.scrollView setContentOffset:CGPointMake(xOffset, 0)];NSLog(@"offset:%@",NSStringFromCGPoint(self.scrollView.contentOffset));
}

- (void)addContentScrollView {
    // ** 添加滑动容器视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 204, CGRectGetWidth(self.view.frame),
                                                                     CGRectGetHeight(self.view.frame)-204)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(4*CGRectGetWidth(self.view.frame), CGRectGetHeight(self.scrollView.frame));
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
    tableTop10.backgroundColor = [UIColor grayColor];
    tableTop10.tag = 100;
    [self.scrollView addSubview:tableTop10];
}

- (void)addMonthTrendView {
    // ** 添加一月趋势图
    UIView *trendView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0,
                                                                 CGRectGetWidth(self.scrollView.bounds),
                                                                 CGRectGetHeight(self.scrollView.bounds))];
    trendView.backgroundColor = [UIColor greenColor];
    trendView.tag = 101;
    [self.scrollView addSubview:trendView];
}

- (void)addPolor7View {
    // ** 添加七星图
    UIView *popor7 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.bounds)*2, 0,
                                                              CGRectGetWidth(self.scrollView.bounds),
                                                              CGRectGetHeight(self.scrollView.bounds))];
    popor7.backgroundColor = [UIColor redColor];
    popor7.tag = 102;
    [self.scrollView addSubview:popor7];

}

- (void)addDetailUserDataView {
    // ** 添加详情表格
    UITableView *detailView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.bounds)*3, 0,
                                                                            CGRectGetWidth(self.scrollView.bounds),
                                                                            CGRectGetHeight(self.scrollView.bounds))];
    detailView.backgroundColor = [UIColor yellowColor];
    detailView.tag = 103;
    [self.scrollView addSubview:detailView];
}

#pragma mark - TableView: Data & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 100) {
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return self.topAnswers.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        TopAnswerCell *topAns = [tableView dequeueReusableCellWithIdentifier:@"TopAnswerCell"];
        [topAns showCellWithAnswer:self.topAnswers[indexPath.row]];
        return topAns;
    } else {
        return nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
