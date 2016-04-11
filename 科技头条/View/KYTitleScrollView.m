//
//  KYTitleScrollView.m
//  科技头条
//
//  Created by apple on 15/7/25.
//  Copyright (c) 2015年 KY. All rights reserved.
//

#import "KYTitleScrollView.h"
#import "KYNavTitleModel.h"

#define randomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]

#define lightBlackColor [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1]

@interface KYTitleScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, strong) NSArray *titleLists;

/// 选中导航的背景图片
@property (nonatomic, strong) UIImageView *selectedBg;
@property (nonatomic, strong) UIImageView *leftBg;
@property (nonatomic, strong) UIImageView *rightBg;

@property (nonatomic, strong) KYNavTitleModel *model;


@end


@implementation KYTitleScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setTitleName];
        [self setTitleBottom];
    }
    return self;
}


- (void)layoutSubviews{

    [super layoutSubviews];
    [self setTitleBottomSelectButton:self.selectedBtn];


}

- (void) setTitleName{
    
    for (int i =0 ; i<self.titleLists.count; i++) {
        
        UIButton *titleBtn = [[UIButton alloc] init];
        [self addSubview:titleBtn];
        [self.btnArray addObject:titleBtn];
        titleBtn.frame = CGRectMake(64*i, 0, 64, 36);
        titleBtn.tag = i;
        [titleBtn setTitleColor:lightBlackColor forState:UIControlStateNormal];
        
        self.model = self.titleLists[i];
        [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
        [titleBtn setTitle:[NSString stringWithFormat:@"%@",self.model.title] forState:UIControlStateNormal];
//        [titleBtn setBackgroundImage:[UIImage imageNamed:@"channel_middle_bg"] forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
        
            self.selectedBtn = titleBtn;
            self.selectedBtn.selected = YES;
            
        }
    }
}

- (void)setTitleBottom{
    
    // 选中按钮下面的背景图片
    UIImageView *selectedBg = [[UIImageView alloc] init];
    selectedBg.image = [UIImage imageNamed:@"channel_selected_bottom_bg"];
    [self addSubview:selectedBg];
    self.selectedBg = selectedBg;
    // 选中按钮左边的背景图片
    UIImageView *leftBg = [[UIImageView alloc] init];
    leftBg.image = [UIImage imageNamed:@"channel_normal_bottom_bg"];
    [self addSubview:leftBg];
    self.leftBg = leftBg;
    // 选中按钮右边的背景图片
    UIImageView *rightBg = [[UIImageView alloc] init];
    rightBg.image = [UIImage imageNamed:@"channel_normal_bottom_bg"];
    [self addSubview:rightBg];
    self.rightBg = rightBg;
    
    
}

- (void)buttonClick:(UIButton *)btn{

    [UIView animateWithDuration:0.25 animations:^{
        
        [self setTitleBottomSelectButton:btn];
    }];
    
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;

}


- (void)setTitleBottomSelectButton:(UIButton *)btn{


    CGFloat selectedMinX = (btn.frame.size.width-53)/2 + btn.frame.origin.x;
    CGFloat selectedMaxX = selectedMinX + 53;
    
    // 底部滑动栏 高度为 8
    self.selectedBg.frame = CGRectMake(selectedMinX, 36, 53, 8);
    // 加上200 是为了补足左边和右边弹性的时候空白部分
    self.leftBg.frame = CGRectMake(-200, 36, selectedMinX+ 200, 8);
    self.rightBg.frame = CGRectMake( selectedMaxX, 36, 64*7 - selectedMaxX + 200, 8);



}


#pragma mark - 懒加载

- (NSArray *)titleLists{
    
    if (_titleLists == nil) {
        _titleLists = [KYNavTitleModel navTitleWithPlist];
    }
    return _titleLists;
    
}



@end
