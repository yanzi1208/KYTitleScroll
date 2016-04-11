//
//  KYNewsModel.h
//  01-科技头条
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYNewsModel : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;
/// 详细信息
@property (nonatomic, copy) NSString *summary;
/// 图片
@property (nonatomic, copy) NSString *img;
/// 发布者
@property (nonatomic, copy) NSString *sitename;
/// 发布时间
@property (nonatomic, strong) NSNumber *addtime;


/// 是否有图片
@property (nonatomic, assign, getter=isGraphic) BOOL graphic;

/// 转化发布的时间
@property (nonatomic, copy, readonly) NSString *timePutOut;


/// 初始化方法
+ (instancetype) newsWithDictionary:(NSDictionary *)dict;

///
+ (void)newsListWithUrl:(NSString *)urlStr Completion:(void(^)(NSArray *array))completion error:(void(^)(NSString *string))error;

@end
