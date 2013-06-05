//
//  MyServer.h
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-2-25.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyServer : NSObject

// 计算指定时间距现在的时间差
+ (NSString *)intervalSinceNow: (NSString *) theDate;

// 获取时间的月日和时间
+ (NSString *)getDateStringFromDate:(NSDate *)date;

// 计算网络获取图片显示时的适合尺寸
+ (CGSize)getImageRightSize:(CGSize)srcSize;

// 计算图片的尺寸
+ (CGSize)calculateImageSize:(CGSize)srcSize deviceFrame:(CGRect)deviceFrame;

@end
