//
//  KYNavTitleModel.h
//  科技头条
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYNavTitleModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *topURL;
@property (nonatomic, copy) NSString *bottomURL;

+ (NSArray *)navTitleWithPlist;



@end
