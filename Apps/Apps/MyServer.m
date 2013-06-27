//
//  MyServer.m
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-2-25.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "MyServer.h"

#define MAXWIDTH 90
#define MAXHEIGHT 68

@implementation MyServer

+ (NSString *)intervalSinceNow: (NSString *) theDate {
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [date setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha / 60 < 1) {
        timeString=@"刚才";
    }
    else if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    else {
        timeString = [MyServer getDateStringFromDate:d];
    }
    return timeString;
}

+ (NSString *)getDateStringFromDate:(NSDate *)date {
    NSInteger location = 0;
    NSString *timeStr = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //设置时间样式（不包含年月日）
    [formatter setDateFormat:@"HH:mm:a"];
    NSString *ampm = [[[formatter stringFromDate:date] componentsSeparatedByString:@":"] objectAtIndex:2];
    timeStr = [formatter stringFromDate:date];
    NSRange range = [timeStr rangeOfString:[NSString stringWithFormat:@":%@",ampm]];
    location = range.location;
    NSString *string = [timeStr substringToIndex:location];
    timeStr = [NSString stringWithFormat:@"%@ %@",ampm,string];
    
    NSTimeInterval late=[date timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha=now-late;
    
    NSString *result = @"";
    
    if (cha / 86400 < 1) {
        result = [NSString stringWithFormat:@"今天 %@", string];
    }
    else {
        NSString *dateStr = @"";
        NSDateFormatter *Dformatter = [[NSDateFormatter alloc] init];
        [Dformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [Dformatter setDateFormat:@"MM-dd"];
        dateStr = [Dformatter stringFromDate:date];
        result = [NSString stringWithFormat:@"%@  %@",dateStr,string];
    }
    return result;
}

+ (CGSize)getImageRightSize:(CGSize)srcSize {
    CGSize resultSize = srcSize;
    float temp = 1.0;
    if (srcSize.width > MAXWIDTH && srcSize.height > MAXHEIGHT) {
        CGFloat widthTemp = MAXWIDTH / srcSize.width;
        CGFloat heightTemp = MAXHEIGHT / srcSize.height;
        temp = widthTemp >= heightTemp ? heightTemp : widthTemp;
    }
    else if (srcSize.width > MAXWIDTH && srcSize.height <= MAXHEIGHT) {
        temp = MAXWIDTH / srcSize.width;
    }
    else if (srcSize.width <= MAXWIDTH && srcSize.height > MAXHEIGHT) {
        temp = MAXHEIGHT / srcSize.height;
    }
    resultSize.width = srcSize.width * temp;
    resultSize.height = srcSize.height * temp;
    return resultSize;
}

+ (CGSize)calculateImageSize:(CGSize)srcSize deviceFrame:(CGRect)deviceFrame {
    CGSize resultSize;
    CGFloat temp;
    if (srcSize.width > deviceFrame.size.width && srcSize.height > deviceFrame.size.height) {
        CGFloat widthTemp = deviceFrame.size.width / srcSize.width;
        CGFloat heightTemp = deviceFrame.size.height / srcSize.height;
        temp = widthTemp >= heightTemp ? heightTemp : widthTemp;
    }
    else if (srcSize.width > deviceFrame.size.width && srcSize.height <= deviceFrame.size.height){
        temp = deviceFrame.size.width / srcSize.width;
    }
    else if (srcSize.width <= deviceFrame.size.width && srcSize.height > deviceFrame.size.height) {
        temp = deviceFrame.size.height / srcSize.height;
    }
    else {
        temp = 1;
    }
    resultSize.width = srcSize.width * temp;
    resultSize.height = srcSize.height * temp;
    return resultSize;
}

@end
