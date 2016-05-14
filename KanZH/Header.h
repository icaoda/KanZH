//
//  Header.h
//  KanZH
//
//  Created by SW05 on 5/10/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#ifndef Header_h
#define Header_h

// **** 屏幕尺寸和标准间隔，为cell的布局提供标准参数
#define kScreenSize [UIScreen mainScreen].bounds.size
#define kCellSpace 8.0

// **** 界面背景色
#define kGreenColor [UIColor colorWithRed:100.0/255.0 green:126.0/255.0 blue:255.0/255.0 alpha:0.5];
#define kWhiteColor [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5];

// -------------------www.kanzhihu.com API-------------------- //
// **** 第一部分 <新闻集>
//          获取新闻集列表 @para: 参数为时间戳，不带参默认选最近的十篇
//#define kUrlGetposts @"http://api.kanzhihu.com/getposts/%@"
#define kUrlGetposts @"file:///Users/sw05/Desktop/KanZhi/getposts%@.json"
//          检查更新      @para：参数为时间戳，检查时间以后是否有更新
#define kUrlChecknew @"http://api.kanzhihu.com/checknew/%@"
//          获取新闻列表   @para：参数为列表id，必须参数
//#define kUrlGetpostanswers @"http://api.kanzhihu.com/getpostanswers/%@/%@"
#define kUrlGetpostanswers @"file:///Users/sw05/Desktop/KanZhi/getpostanswers_%@_%@"
// ----------------------------------------------------------- //
// **** 第二部分 <知乎接口>
//          问题链接      @para：参数为问题id
#define kUrlQuestion @"http://www.zhihu.com/question/%@"
//          答案链接      @para：参数1--问题id,参数2--答案id
#define kUrlAnswer @"http://www.zhihu.com/question/%@/answer/%@"
//          用户主页      @para：参数--用户哈希
#define kUrlUserpage @"http://www.zhihu.com/people/%@"
// ----------------------------------------------------------- //
// **** 第三部分 <排行榜接口>
//          用户搜索      @para:参数--关键字
#define kUrlUserSrch @"http://api.kanzhihu.com/searchuser/%@"
//          排行榜        @para：参数item--排行指标
//                       @para: 参数page--page/items
#define kUrlTopuser @"http://api.kanzhihu.com/topuser/%@/%@/%@"
//          用户详情      @para: 参数hash--用户hash
#define kUrlUserdetail2 @"http://api.kanzhihu.com/userdetail2/%@"
// ----------------------------------------------------------- //

// ** 全局的通知
#define kSideBarNotification @"kSideBarNotification"

#endif /* Header_h */
