//
//  KYBasicTableViewCell.m
//  科技头条
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 KY. All rights reserved.
//

#import "KYNewsTableViewCell.h"
#import "KYNewsModel.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

/// 灰色
#define lightColor [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1]

/// 灰色
#define summaryColor [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1]

/// 背景色
#define tableViewColor [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]

@interface KYNewsTableViewCell ()

/// 图片
@property (weak, nonatomic) UIImageView *imgView;
/// 标题
@property (weak, nonatomic) UILabel *titleLable;
/// 详细信息
@property (weak, nonatomic) UILabel *summaryLable;

/// 发布者
@property (weak, nonatomic) UILabel *sitenameLable;
/// 发布时间
@property (weak, nonatomic) UILabel *addtimeLable;

@end

@implementation KYNewsTableViewCell


/// 重写初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubviews];
        
        [self addConstraints];

        
    }

    return self;
}


- (void)addSubviews{
    // 图片
    UIImageView *imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:imgView];
    self.imgView = imgView;
    
    // 标题
    UILabel *titleLable = [[UILabel alloc] init];
    [self.contentView addSubview:titleLable];
    self.titleLable = titleLable;
    self.titleLable.numberOfLines = 2;
    [self.titleLable setFont:[UIFont systemFontOfSize:18]];
    
    // 详细信息
    UILabel *summaryLable = [[UILabel alloc] init];
    [self.contentView addSubview:summaryLable];
    self.summaryLable = summaryLable;
    self.summaryLable.numberOfLines = 2;
    [self.summaryLable setFont:[UIFont systemFontOfSize:14]];
    self.summaryLable.textColor = summaryColor;
    
    // 发布者
    UILabel *sitenameLable = [[UILabel alloc] init];
    [self.contentView addSubview:sitenameLable];
    self.sitenameLable = sitenameLable;
    [self.sitenameLable setFont:[UIFont systemFontOfSize:12]];
    self.sitenameLable.textColor = lightColor;
    
    // 发布时间
    UILabel *addtimeLable = [[UILabel alloc] init];
    [self.contentView addSubview:addtimeLable];
    self.addtimeLable = addtimeLable;
    [self.addtimeLable setFont:[UIFont systemFontOfSize:12]];
    self.addtimeLable.textColor = lightColor;

}

+ (instancetype)tableViewCellWithTableView:(UITableView *)tableView{

    NSString *reuseID = @"news";
    KYNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
   
    if (!cell) {
        cell = [[KYNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)setNewsModel:(KYNewsModel *)newsModel{

    _newsModel = newsModel;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:newsModel.img]];
    self.titleLable.text = newsModel.title;
    self.summaryLable.text = newsModel.summary;
    self.sitenameLable.text = newsModel.sitename;
    self.addtimeLable.text = [newsModel timePutOut];
    
    // 如果图片地址字符串长度大于0,说明有图片
    _newsModel.graphic = NO;
    if (newsModel.img.length > 0) {
       _newsModel.graphic = YES;
    }
    
    
    // 如果有图片
    if (_newsModel.isGraphic) {
        // 图片
        [self.imgView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (self.contentView).offset(5);
            make.right.equalTo (self.contentView).offset(-5);
            make.height.equalTo (60);
            make.width.equalTo (80);
        }];
        
        // 标题
        [self.titleLable remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.imgView.left).offset(-5);
        }];
    }else{
        
        self.imgView.hidden = YES;
        // 图片
        [self.imgView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (self.contentView).offset(5);
            make.right.equalTo (self.contentView).offset(-5);
            make.height.equalTo (0);
            make.width.equalTo (0);
        }];
        
        // 标题
        [self.titleLable remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
        }];
    }
}



- (void)layoutSubviews {

    [super layoutSubviews];
    [self layoutIfNeeded];
    
    // 此处判断必须放到这里 不然拿不到frame
    [self summaryLableHidden];
  
}

- (void)addConstraints{
   

    // 详细信息
    [self.summaryLable remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo (self.titleLable);
        make.top.equalTo (self.titleLable.bottom).offset (5);
    }];
    
    
    // 发布者
    [self.sitenameLable remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.contentView).offset (5);
        make.bottom.equalTo (self.contentView).offset (-5);
    }];
    
    
    // 发布时间
    [self.addtimeLable remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.right).offset (-80);
        make.bottom.equalTo (self.contentView).offset (-5);
    }];

}


- (void)summaryLableHidden{

    CGSize size = [self.newsModel.title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    if (size.width > self.titleLable.frame.size.width) {
        self.summaryLable.hidden = YES;
    }else{
        self.summaryLable.hidden = NO;
    }

}




@end
