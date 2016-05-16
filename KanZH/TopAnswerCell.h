//
//  TopAnswerCell.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/9/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopAnswer;
@interface TopAnswerCell : UITableViewCell
// ** 根据回答信息，填充回答cell
- (void)showCellWithAnswer:(TopAnswer *)answer;
@end
