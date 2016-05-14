//
//  NewsBatchCell.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/4/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsBatch;
@interface NewsBatchCell : UITableViewCell
// ** Layout cell with data model
- (void)showCellWithNewsBatch:(NewsBatch *)newsBatch;
@end
