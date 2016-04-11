//
//  KYBasicTableViewCell.h
//  科技头条
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 KY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KYNewsModel;

@interface KYNewsTableViewCell : UITableViewCell

@property (nonatomic, strong) KYNewsModel *newsModel;

+ (instancetype) tableViewCellWithTableView:(UITableView *)tableView;



@end
