//
//  AboutItemViewController.m
//  KanZH
//
//  Created by SW05 on 5/14/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "AboutItemViewController.h"

@interface AboutItemViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation AboutItemViewController

// ** 构造方法
+ (instancetype)aboutItemWithIndex:(NSInteger)index {
    return [[self alloc] initItemWithIndex:index];
}

- (instancetype)initItemWithIndex:(NSInteger)index {
    if (self=[super init]) {
        _index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // ** 配置
    [self configNavigationBar];
}

// ** 配置导航栏
- (void)configNavigationBar {
    NSArray *arr = @[@"关于看知乎",@"看知乎API",@"用户互动"];
    self.navigationItem.title = arr[self.index];
    switch (self.index) {
        case 0:
            [self layoutForAbout];
            break;
        case 1:
            [self layoutForAPI];
            break;
        case 2:
            [self layoutForInteract];
            break;
        default:
            break;
    }
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.backgroundColor = [UIColor clearColor];
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AboutItemCell"];
    [self.view addSubview:self.table];
}

// ** 布局：关于看知乎
- (void)layoutForAbout {
    // ** 标签显示文本
    self.dataSource = @[@"每天三次，看知乎精选。",
                        @"清早上班路上，不错过昨日最新话题；",
                        @"午饭后休息时间，看看最近还有哪些热门；",
                        @"傍晚回家，读一读过去的好答案。",
                        @"",
                        @"既有长篇干货，也有一句话抖机灵；",
                        @"所有话题兼容并包，人文科技艺术体育职场情感都囊括其中；",
                        @"无添加剂的电脑筛选，不预设立场。",
                        @"",
                        @"如果你是知乎日报的读者或精选集的订阅者，希望你能在这里看到更多原汁原味的答案；",
                        @"如果你还是知乎社区的参与者，希望你除了阅读好答案，还能找到值得关注的人；",
                        @"如果你想更深入了解知乎，就去用户动态的数据海洋中尽情查找吧。"];

}

// ** 布局：看知乎API
- (void)layoutForAPI {
    // ** 标签显示文本
    self.dataSource = @[@"API文档",
                        @"URL: http://kanzhihu.com",
                        @"这里是很简陋的看知乎官方API文档0.1.5版。",
                        @"当前版本不需要身份认证即可调用，但请大家注意节制，不要滥用。",
                        @"",
                        @"本文档适合以下人群阅读：",
                        @"",
                        @"对「看知乎」的网站感兴趣，准备开发APP或客户端的开发者；",
                        @"对知乎用户数据和排行感兴趣的数据分析者；",
                        @"不知道干什么就是想随便看看的闲人。"];
}
// ** 布局：用户互动
- (void)layoutForInteract {
    self.dataSource = @[@"API来源：kanzhihu.com",
                        @"",
                        @"相关开源库：",
                        @"AFNetworking",
                        @"SDWebImage",
                        @"MJRefresh",
                        @"JVFloatingDrawer",
                        @"",
                        @"反馈：icaoda@qq.com",
                        @"Copyright © 2016 曹达. All rights researved."];
}

#pragma mark - Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:@"AboutItemCell"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
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
