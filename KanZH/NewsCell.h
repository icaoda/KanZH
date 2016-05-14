//
//  NewsCell.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/5/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsModel;
@interface NewsCell : UITableViewCell
// ** 设置Cell的内容, @para: news--新闻的数据模型
- (void)showCellWithNews:(NewsModel *)news;
@end
