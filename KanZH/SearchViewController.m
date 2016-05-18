//
//  SearchViewController.m
//  KanZH
//
//  Created by SW05 on 5/16/16.
//  Copyright © 2016 SW05. All rights reserved.
//

/* ** 用户搜索视图的控制器： 
            1.配置导航栏
            2.搜索栏和表格的添加
            3.数据的下载
            4.下拉刷新
 */
#import "SearchViewController.h"
#import "UserViewController.h"
#import "AFNetworking.h"
#import "UserSrch.h"
#import "UserSrchCell.h"
#import "Header.h"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate,
                                    UISearchBarDelegate>
// ** 搜索框
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearchEditing;
// ** 数据表格相关属性
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // ** 初始化属性
    [self setDataSource:[NSMutableArray array]];
    // ** 添加控件
    [self configNavigationBar];
    [self addTableView];
}

- (void)configNavigationBar {
    self.navigationItem.title = @"用户搜索";
    self.navigationController.navigationBar.tintColor = kWhiteColor;
    self.navigationController.navigationBar.barTintColor = kLightBlueColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],
                                                                    NSForegroundColorAttributeName:[UIColor blueColor]};
}

- (void)addTableView {
    // ** 添加搜索栏
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    self.searchBar.delegate = self;
    // ** 添加表格
    self.table = [[UITableView alloc] initWithFrame:self.view.frame];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table registerNib:[UINib nibWithNibName:@"UserSrchCell" bundle:[NSBundle mainBundle]]
                                    forCellReuseIdentifier:@"UserSrchCell"];
    [self.table setTableHeaderView:self.searchBar];
    [self.view  addSubview:self.table];
}

- (void)downloadData:(NSString *)usrname {
    NSString *url = [NSString stringWithFormat:kUrlUserSrch,usrname];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSURLSessionDataTask *task = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // ** 如果连接成功，开始解析
        if (responseObject) {
            NSString *erro = [responseObject objectForKey:@"error"];
            if ([erro isEqualToString:@""]) {
                // ** 移除原有的数据
                [self.dataSource removeAllObjects];
                // ** 解析数据，生成模型
                NSArray *users = [responseObject objectForKey:@"users"];
                for (NSDictionary *dic in users) {
                    UserSrch *usr = [UserSrch userSrchWithDictionary:dic];
                    [self.dataSource addObject:usr];
                }
            }
            // ** 重新刷新表格
            [self.table reloadData];
        } else {
            // ** 失败，不做处理
        }
        // ** 修改全局变量
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // ** 修改全局变量
    }];
    
    [task resume];
}

#pragma mark - SearchBar: Delegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"%d,%s",__LINE__,__func__);
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%d,%s",__LINE__,__func__);
    // ** 赋值全局变量，标记当前模式为搜索编辑
    [self setIsSearchEditing:YES];
    // ** 如果不为空，加载数据，显示名字
    if ([searchBar.text isEqualToString:@""] == NO) {
        [self downloadData:searchBar.text];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%d,%s",__LINE__,__func__);
    [searchBar resignFirstResponder];
    [self setIsSearchEditing:NO];
    [self.table reloadData];
}

#pragma mark - TableView: Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // ** 当前显示状态：如果为搜索编辑状态
    if (self.isSearchEditing == YES) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                       reuseIdentifier:@"UserSrchCellSearch"];
        UserSrch *user = self.dataSource[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"用户ID: %@",user.id];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"用户姓名：%@",user.name];
        return cell;
    } else {
    // ** 搜索完成状态
        UserSrchCell *cell = [self.table dequeueReusableCellWithIdentifier:@"UserSrchCell"];
        [cell showCellWithUserSrch:self.dataSource[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearchEditing == YES) {
        return 40;
    } else {
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ** 选中用户，入栈用户详情视图
    UserSrch *usr = self.dataSource[indexPath.row];
    UserViewController *userVC = [UserViewController userViewControllerWithHash:usr.uHash];
    [self.navigationController pushViewController:userVC animated:NO];
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
