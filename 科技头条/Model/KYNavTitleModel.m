//
//  KYNavTitleModel.m
//  科技头条
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 KY. All rights reserved.
//

#import "KYNavTitleModel.h"

@implementation KYNavTitleModel

- (instancetype)initWithDict:(NSDictionary *)dict{

    if(self = [super init]){
    
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


+ (instancetype)navTitleWithDict:(NSDictionary *)dict{

    return [[self alloc] initWithDict:dict];
}


// 封装plist
+ (NSArray *)navTitleWithPlist{
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"KYNavTitle" ofType:@"plist"]];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        KYNavTitleModel *model = [KYNavTitleModel navTitleWithDict:dict];
        [tempArray addObject:model];
    }
    return tempArray;
    
}



@end
