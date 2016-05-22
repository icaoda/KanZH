//
//  NewsAnswerViewController.m
//  KanZH
//
//  Created by SW05 on 5/14/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "NewsAnswerViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "Header.h"

@interface NewsAnswerViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
// ** 新闻列表传来的参数
@property (nonatomic, copy) NSString *questionid;
@property (nonatomic, copy) NSString *answerid;
@property (nonatomic, copy) NSString *authorhash;
// ** 网页视图容器
@property (nonatomic, strong) UIWebView *web;
// ** 进度条属性
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
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
        _isPost = NO;
    }
    return self;
}

// ** life-cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // 配置导航栏，开始加载网页
    [self configNaviBar];
    self.web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    // 配置进度条的视图
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    self.web.delegate = self.progressProxy;
    CGFloat barHeight = self.navigationController.navigationBar.frame.size.height;
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, barHeight-4.0, kScreenSize.width, 4.0)];
    [self loadRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

// ** 配置导航栏
- (void)configNaviBar {
    self.navigationItem.title = @"精彩回答";
    UIBarButtonItem *question = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-topic"] style:UIBarButtonItemStylePlain target:self action:@selector(barItemClick:)];
    question.tag = 555;
    UIBarButtonItem *author = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-author"] style:UIBarButtonItemStylePlain target:self action:@selector(barItemClick:)];
    author.tag = 556;
    if (self.authorhash == nil) {
        self.navigationItem.rightBarButtonItems = @[question];
    } else {
        self.navigationItem.rightBarButtonItems = @[question,author];
    }
}
// ** 添加web view
- (void)loadRequest {
    NSString *urlstring;
    if (self.isPost == NO) {
        urlstring = [NSString stringWithFormat:kUrlAnswer,_questionid,_answerid];
    } else {
        urlstring = [NSString stringWithFormat:kUrlAnswerZhanLan,_questionid,_answerid];

    }
    NSURLRequest *requst = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
    [self.web loadRequest:requst];
    [self.view addSubview:self.web];
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [self.progressView setProgress:progress animated:YES];
}

// ** 导航栏按钮响应函数
- (void)barItemClick:(UIBarButtonItem *)sender {
    // ** load url
    NSString *urlString;
    if (sender.tag == 555) {
        urlString = [NSString stringWithFormat:kUrlQuestion,_questionid];
    } else {
        urlString = [NSString stringWithFormat:kUrlUserpage,_authorhash];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    [self.web loadRequest:[NSURLRequest requestWithURL:url]];
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
