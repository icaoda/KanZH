//
//  TopUserViewController.m
//  KanZH
//
//  Created by SW05 on 5/14/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "TopUserViewController.h"
#import "SearchViewController.h"
#import "UserViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "UserCell.h"
#import "Header.h"

@interface TopUserViewController ()<UITableViewDataSource, UITableViewDelegate,
                                    UIPickerViewDataSource, UIPickerViewDelegate>
// ** 数据相关属性
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) NSInteger pageIndex;// ** 默认每页30条，从第一页起算
// ** 表格相关属性
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *valueBtn;// ** 表头的标签
// ** 刷新相关属性
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLast;
// ** 选取器相关属性
@property (nonatomic, strong) NSArray *rootData;
@property (nonatomic, strong) NSArray *pickerData1;
@property (nonatomic, strong) NSArray *pickerData2;
@end

@implementation TopUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPickerDataSource];
    // Add Controls
    [self customizeNavigationBar];
    [self addTableViewToView];
    [self setDataSource:[NSMutableArray array]];
    [self addRefreshViewToView];
    // Init properties
    [self setPageIndex:1];
    [self setValue:[self.pickerData2[0] objectForKey:@"item"]];
    [self setIsRefreshing:NO];
    [self setIsLast:NO];
    [self downloadDataWithValue:_value pageIndex:_pageIndex];
}

// ** 初始化选取器的数据模型
- (void)initPickerDataSource {
    // ** 从plist读入模型数组
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Parameters.plist" ofType:nil];
    self.rootData  = [NSArray arrayWithContentsOfFile:path];NSLog(@"root:\n%@",self.rootData);
    // ** 给第一个选取部件准备数据
    NSMutableArray *data1 = [NSMutableArray array];
    for (NSDictionary *item in self.rootData) {
        NSString *cateName = [item objectForKey:@"category"];
        [data1 addObject:cateName];
    }
    self.pickerData1 = data1;
    self.pickerData2 = [self.rootData[0] objectForKey:@"items"];
}

- (void)customizeNavigationBar {
    self.navigationItem.title = @"Top用户排行";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-nav"]
                                                                             style:UIBarButtonItemStylePlain target:self
                                                                            action:@selector(toggleDrawerLeft)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-search"]
                                                                              style:UIBarButtonItemStylePlain target:self
                                                                             action:@selector(searchBarItemClick)];
    self.navigationController.navigationBar.tintColor = kWhiteColor;
    self.navigationController.navigationBar.barTintColor = kGreenColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0],
                                                                    NSForegroundColorAttributeName:[UIColor blueColor]};
}
// ** 修改标题的方法
- (void)modifyTopKey:(NSString *)key {
    // ** 循环数据源2的子项目，找出name
    for (NSDictionary *dic in self.pickerData2) {
        NSString *item = [dic objectForKey:@"item"];
        if ([item isEqualToString:key]) {
            item = [dic objectForKey:@"name"];
            self.navigationItem.rightBarButtonItem.title = item;
        }
    }
}

- (void)addTableViewToView {
    // ** 配置表头
    self.valueBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.valueBtn.frame = CGRectMake(0, 64.0, CGRectGetWidth(self.view.frame), 20);
    self.valueBtn.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:255.0/255.0 alpha:1.0];
    [self.valueBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [self.valueBtn setTitle:[self.pickerData2[0] objectForKey:@"name"] forState:UIControlStateNormal];
    [self.valueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.valueBtn addTarget:self action:@selector(popupSettingPanel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.valueBtn];
    // ** 配置表格
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64-20)
                                              style:UITableViewStylePlain];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.table.separatorColor = [UIColor brownColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.rowHeight = 100.0;
    [self.table registerNib:[UINib nibWithNibName:@"UserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UserCell"];
    [self.view addSubview:self.table];
}

- (void)addRefreshViewToView {
    // ** 添加下拉刷新
    __weak typeof(self) weakSelf = self;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_isRefreshing) {
            return ;
        } else {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf setIsRefreshing:YES];
            NSInteger index = strongSelf.pageIndex<=1 ? 1 : strongSelf.pageIndex-1;
            [strongSelf downloadDataWithValue:self.value pageIndex:index];
        }
        
    }];
    // ** 添加下拉刷新
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_isRefreshing) {
            return ;
        } else {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf setIsRefreshing:YES];
            NSUInteger index = strongSelf.pageIndex + 1;
            [strongSelf downloadDataWithValue:self.value pageIndex:index];
        }
        
    }];
}

- (void)downloadDataWithValue:(NSString *)value pageIndex:(NSInteger)index {
    NSString *url = [NSString stringWithFormat:kUrlTopuser,value,index];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSURLSessionDataTask *task = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"Download in progress!");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // ** 获取数据成功
        if (responseObject) {
            NSString *erro = [responseObject objectForKey:@"error"];
            if ([erro isEqualToString:@""]) {
                // ** 如果是第一页，先移除数据模型
                if (index == 1) {
                    [self.dataSource removeAllObjects];
                }
                // ** 解析数据，生产数据模型
                NSArray *topUsers = [responseObject objectForKey:@"topuser"];
                for (NSDictionary *dic in topUsers) {
                    UserModel *user = [UserModel userModelWithDictionary:dic key:value];
                    [self.dataSource addObject:user];
                }
                // ** 修改全局变量
                [self setValue:value];
                [self modifyTopKey:value];
                [self setPageIndex:index];
                // ** 刷新表格
                [self.table reloadData];
            }
        } else {
            NSLog(@"response data nil");
        }
        // ** 终止刷新
        [self setIsRefreshing:NO];
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // ** 终止刷新
        [self setIsRefreshing:NO];
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
    }];
    [task resume];
}

#pragma mark - Action for Controls
// ** 左侧导航栏：侧边栏
- (void)toggleDrawerLeft {
    [[AppDelegate globalDelegate] toggleDrawerWithLeftSide];
}
// ** 右侧导航栏：查找
- (void)searchBarItemClick {
    NSLog(@"Search start!");
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:NO];
}
// ** 中间按钮，弹出设置
- (void)popupSettingPanel {
    NSLog(@"pop up setting panel");
    // ** 弹出选取面板
    UIView *pickerPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 64+20, CGRectGetWidth(self.view.frame), 150)];
    pickerPanel.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:255.0/255.0 alpha:1.0];
    pickerPanel.tag = 777;
    // ** 设置选取器
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.tag = 776;
    [pickerPanel addSubview:picker];
    // ** 设置确认按钮
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(CGRectGetWidth(self.table.bounds)-kCellSpace-50, 110, 50, 30);
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = 15.0;
    [okBtn setBackgroundColor:[UIColor whiteColor]];
    [okBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"Done" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(valuePickerDone) forControlEvents:UIControlEventTouchUpInside];
    [pickerPanel addSubview:okBtn];
    
    [self.view addSubview:pickerPanel];
}
// ** 选择器：选择确认
- (void)valuePickerDone {
    NSLog(@"value picker done");
    // ** 获取选取器的值
    UIView *pickerPanel  = [self.view viewWithTag:777];
    UIPickerView *picker = [self.view viewWithTag:776];
    NSInteger selected = [picker selectedRowInComponent:1];
    NSString *value = [self.pickerData2[selected] objectForKey:@"item"];
    // ** 移除设置面板
    [pickerPanel removeFromSuperview];
    // ** 加载数据
    [self downloadDataWithValue:value pageIndex:1];
}

// ** 表格的代理方法和数据
#pragma mark - TableView: Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {NSLog(@"row = %ld",self.dataSource.count);
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [self.table dequeueReusableCellWithIdentifier:@"UserCell"];
    [cell showCellWithUserModel:self.dataSource[indexPath.row]];NSLog(@"******%ld",indexPath.row);
    NSLog(@"&&&&&-%@",self.dataSource[indexPath.row]);
    return cell;
}

#pragma mark - TableView: Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ** 将用户详情视图 入栈道导航控制器
    UserModel *usr = self.dataSource[indexPath.row];
    UserViewController *usrVC = [UserViewController userViewControllerWithHash:usr.uHash];
    [self.navigationController pushViewController:usrVC animated:NO];
}

// ** 选取器的代理方法和数据
#pragma mark - PickerView: Data Source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.pickerData1.count;
    } else {
        return self.pickerData2.count;
    }
}

#pragma mark - PickerView: Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.pickerData1[row];
    } else {
        return [self.pickerData2[row] objectForKey:@"name"];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 80.0;
    } else {
        return 240.0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.pickerData2 = [self.rootData[row] objectForKey:@"items"];
        [pickerView reloadComponent:1];
    }
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
