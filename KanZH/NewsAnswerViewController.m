//
//  NewsAnswerViewController.m
//  KanZH
//
//  Created by SW05 on 5/14/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "NewsAnswerViewController.h"

@interface NewsAnswerViewController ()
// ** 新闻列表传来的参数
@property (nonatomic, copy) NSString *questionid;
@property (nonatomic, copy) NSString *answerid;
@property (nonatomic, copy) NSString *authorhash;
// ** 网页视图容器
@property (nonatomic, strong) UIWebView *web;
@end

@implementation NewsAnswerViewController

// ** 初始化方法
+ (instancetype)newsAnserWithQuestion:(NSString *)quest answer:(NSString *)ans userHash:(NSString *)usr {
    return [[self alloc] initAnserWithQeestion:quest answer:ans userHash:usr];
}

- (instancetype)initAnserWithQeestion:(NSString *)quest answer:(NSString *)ans userHash:(NSString *)usr {
    if (self=[super init]) {
        _questionid = quest;
        _answerid = ans;
        _authorhash = usr;
    }
    return self;
}

// ** life-cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNaviBar];
    [self addWebView];
}

// ** 配置导航栏
- (void)configNaviBar {
    self.navigationItem.title = @"精彩回答";
    UIBarButtonItem *question = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-topic"] style:UIBarButtonItemStylePlain target:self action:@selector(barItemClick:)];
    question.tag = 555;
    UIBarButtonItem *author = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-author"] style:UIBarButtonItemStylePlain target:self action:@selector(barItemClick:)];
    author.tag = 556;
    self.navigationItem.rightBarButtonItems = @[question,author];
}
// ** 添加web view
- (void)addWebView {
    self.web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.web loadHTMLString:@"人在什么时候最舒服？ - 调查类问题 - 知乎_files" baseURL:[NSURL URLWithString:@"人在什么时候最舒服？ - 调查类问题 - 知乎.html"]];
    [self.view addSubview:self.web];
}

// ** 导航栏按钮响应函数
- (void)barItemClick:(UIBarButtonItem *)sender {
    NSLog(@"bar item click");
    // ** load url
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
