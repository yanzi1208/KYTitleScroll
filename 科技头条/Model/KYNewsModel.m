//
//  KYNewsModel.m
//  01-科技头条
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 KY. All rights reserved.
//

#import "KYNewsModel.h"
#import "NetworkTools.h"

@implementation KYNewsModel

+ (instancetype)newsWithDictionary:(NSDictionary *)dict{

    KYNewsModel *new = [KYNewsModel new];
    [new setValuesForKeysWithDictionary:dict];

    return new;
}

+ (void)newsListWithUrl:(NSString *)urlStr Completion:(void(^)(NSArray *array))completion error:(void(^)(NSString *string))error{
    
    
    [[NetworkTools sharedNetworkTools] GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task,  NSArray *array) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        // 字典转模型
        for (NSDictionary *dict in array) {
            KYNewsModel *model = [KYNewsModel newsWithDictionary:dict];
            
            [tempArr addObject:model];
        }
        if (completion) {
            completion(tempArr.copy);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error); // 打印错误
    }];
}

/// 计算时间
- (NSString *)timePutOut{

    // 距离现在的时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.addtime.doubleValue];
    // 截取当前时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获取分钟
    NSDateComponents *comparator = [calendar components:NSCalendarUnitMinute fromDate:date toDate:[NSDate date] options:NSCalendarWrapComponents];
    if (comparator.minute < 60) {
        return [NSString stringWithFormat:@"%zd分钟前", comparator.minute];
    }
    // 获取小时
    comparator = [calendar components:NSCalendarUnitHour fromDate:date toDate:[NSDate date] options:NSCalendarWrapComponents];
    if (comparator.hour < 24) {
        return [NSString stringWithFormat:@"%zd小时前", comparator.hour];
    }
    // 获取当前时间
    NSDateFormatter *mdhm = [NSDateFormatter new];
    
    mdhm.dateFormat = @"MM-dd hh:mm";
    
    return [mdhm stringFromDate:date];
}




-  (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}




@end
