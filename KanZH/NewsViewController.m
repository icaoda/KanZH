//
//  NewsViewController.m
//  KanZH
//
//  Created by SW05 on 5/12/16.
//  Copyright © 2016 SW05. All rights reserved.
//

// ** News控制器的功能： 1.配置导航栏
/*                    2.添加设置功能
 *                    3.下载和配置表格
                      4.设置刷新
                      5.代理表格
 */

#import "NewsViewController.h"
#import "NewsAnswerViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "ToolBox.h"
#import "Header.h"

@interface NewsViewController ()<UITableViewDelegate, UITableViewDataSource>
// ** 属性：加载数据的参数
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *currentDate;
@property (nonatomic, copy) NSString *currentName;
// ** 属性：表格相关的参数
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UILabel *headTime;
// ** 属性：刷新相关参数
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLast;
@end

@implementation NewsViewController

// ** 构造方法，初始化方法
+ (instancetype)newsViewWithDate:(NSString *)date name:(NSString *)name {
    return [[NewsViewController alloc] initNewsWithDate:date name:name];
}

- (instancetype)initNewsWithDate:(NSString *)date name:(NSString *)name {
    if (self=[super init]) {
        self.date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self.name = name;
    }
    return self;
}

// ** 视图控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self addTableViewToView];
    [self addMJRefreshToTable];
    [self setCurrentDate:_date];
    [self setCurrentName:_name];
    [self setDataSource:[NSMutableArray array]];
    [self downloadDataWithDate:self.date name:self.name];
}

#pragma mark - Config View
// ** 配置导航栏
- (void)configNavigationBar {
    // ** 更新导航栏标题
    if ([self.name isEqualToString:@"yesterday"]) {
        self.navigationItem.title = @"昨日最新";
    } else if ([self.name isEqualToString:@"recent"]) {
        self.navigationItem.title = @"近日热门";
    } else {
        self.navigationItem.title = @"历史精华";
    }
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],
                                                                    NSForegroundColorAttributeName:[UIColor blueColor]};
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-date"]
                                                                              style:UIBarButtonItemStylePlain target:self
                                                                             action:@selector(popupPickerView)];
}

// ** 添加table做新闻容器
- (void)addTableViewToView {
    // ** 配置表格
    CGRect rect = self.view.bounds;
    rect.origin.y    += 20.0;
    rect.size.height -= 20.0;
    self.table = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.table.separatorStyle = UITableViewCellSelectionStyleNone;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table registerNib:[UINib nibWithNibName:@"NewsCell"
                                           bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NewsCell"];
    [self.view addSubview:self.table];
    // ** 配置表头view
    self.headTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 64.0, CGRectGetWidth(self.view.bounds), 20)];
    self.headTime.textAlignment = NSTextAlignmentCenter;
    self.headTime.textColor = [UIColor whiteColor];
    self.headTime.text = [ToolBox toolDayWithString:self.date];
    self.headTime.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:255.0/255.0 alpha:1.0];
    [self.view addSubview:self.headTime];

}

// ** 添加刷新功能
- (void)addMJRefreshToTable {
    self.isRefreshing = NO;
    self.isLast = NO;
    __weak typeof(self) weakSelf = self;
    // ** 设置下拉刷新
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_isRefreshing) {
            return ;
        } else {
            __strong typeof(self) strongSelf = self;
            [strongSelf setIsRefreshing:YES];
            [strongSelf downloadDataWithDate:[ToolBox toolOneDay:strongSelf.currentDate before:NO] name:self.currentName];
        }
    }];
    // ** 设置上拉刷新
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_isRefreshing) {
            return ;
        } else {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf setIsRefreshing:YES];
            [strongSelf downloadDataWithDate:[ToolBox toolOneDay:strongSelf.currentDate before:YES] name:self.currentName];
        }
    }];
}

// ** 下载数据
- (void)downloadDataWithDate:(NSString *)date name:(NSString *)name {
    // ** 拼接字串，配置URL连接
    NSString *url = [NSString stringWithFormat:kUrlGetpostanswers,date,name];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // ** 配置DataTask
    NSURLSessionDataTask *task = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"Download inprogress!");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // ** 如果切换了name，或者所取时间不晚于当前时间 则清空数据重新加载
        if ([name isEqualToString:_currentName] == NO || [ToolBox toolDate:date isNotLaterThanDate:_currentDate]) {
            [self.dataSource removeAllObjects];
        }
        // ** 连接成功，如果数据不为空
        NSLog(@"data task success");
        if (responseObject) {
            NSString *erro = [responseObject valueForKey:@"error"];
            if ([erro isEqualToString:@""]) {
                NSArray *answers = [responseObject objectForKey:@"answers"];
                for (NSDictionary *dic in answers) {
                    NewsModel *news = [NewsModel newsModelWithDictionary:dic];
                    [self.dataSource addObject:news];
                }
                // ** 加载数据后全局变量的修改
                self.currentDate = date;
                self.currentName = name;
                self.headTime.text = [ToolBox toolDayWithString:self.currentDate];
            }
        // ** 如果数据为空，不做处理
        } else {
            NSLog(@"Download data error");
        }
        // ** 终止刷新，更新数据
        [self.table reloadData];
        [self setIsRefreshing:NO];
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Download fail:%@",error.description);
        // ** 失败提示
        NSString *message = [NSString stringWithFormat:@"获取数据失败"];
        [self showAlertForMessage:message];
        // ** 连接失败，处理刷新
        [self setIsRefreshing:NO];
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
    }];
    [task resume];
}

- (void)showAlertForMessage:(NSString *)str {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:8.0 animations:^{
        alert.view.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf dismissViewControllerAnimated:alert completion:nil];
    }];
}

#pragma mark - Response to User Interaction
// ** 右导航按钮的响应函数，退出设置
- (void)popupPickerView {
    NSLog(@"Pop up view");
    // ** 弹出view的幕布
    UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+20, CGRectGetWidth(self.view.frame), 150)];
    popView.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:255.0/255.0 alpha:1.0];
    popView.tag = 888;
    // ** 时间选取器
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    picker.calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    picker.date = [formatter dateFromString:self.currentDate];
    picker.locale = [NSLocale currentLocale];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.maximumDate = [NSDate date];
    picker.tag = 889;
    [popView addSubview:picker];
    // ** 确定按钮
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(CGRectGetWidth(self.table.bounds)-kCellSpace-50, 110, 50, 30);
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = 15.0;
    [okBtn setBackgroundColor:[UIColor whiteColor]];
    [okBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"Done" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(datePickerDone) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:okBtn];
    
    [self.view addSubview:popView];
}

- (void)datePickerDone {
    NSLog(@"date picker done");
    // ** 取出选取值，移除弹出视图
    UIView *view = [self.view viewWithTag:888];
    UIDatePicker *picker = [view viewWithTag:889];
    NSDate *date = picker.date;
    [view removeFromSuperview];
    // ** 重新加载数据
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    [self downloadDataWithDate:[formatter stringFromDate:date] name:self.currentName];
}

#pragma mark - TableView DataSource & Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [self.table dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    [cell showCellWithNews:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsModel *news = self.dataSource[indexPath.row];
    CGFloat sHeight = [ToolBox toolCalcHeightForString:news.summary Width:CGRectGetWidth(self.table.bounds) fontSize:11.0];
    return 8+60+sHeight+15+8;// ** kCellSpace + avatarHeight + summaryHeight + timeHeight + kCellSpace
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsModel *news = self.dataSource[indexPath.row];
    NewsAnswerViewController *answerVC = [NewsAnswerViewController newsAnserWithQuestion:news.questionid answer:news.answerid userHash:news.authorhash];
    [self.navigationController pushViewController:answerVC animated:NO];
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
