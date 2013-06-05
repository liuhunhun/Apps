//
//  AppDelegate.h
//  Apps
//
//  Created by 乱柒ハ糟 on 13-4-27.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSinaWeiboAppKey             @"1487140874"
#define kSinaWeiboAppSecret         @"1f695697db0105488c6efe2c7b3cd695"
#define kSinaAppRedirectURI     @"http://appgroup.com"

#define kTencentWeiboAppKey             @"801363368"
#define kTencentWeiboAppSecret         @"d816e88f05897449a2d1f44d795f2cf1"
#define kTencentAppRedirectURI     @"http://appgroup.com"

#define kWeixinWeiboAppKey             @"b55541fac8a83bf2a03d3facfd03e898"
#define kWeixinAppRedirectURI     @"http://appgroup.com"

@class RootViewController;

@class SinaWeibo;
@class TCWBEngine;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    RootViewController *rootViewController;
    
    SinaWeibo *sinaWeibo;
    
    TCWBEngine *tencentWeibo;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly) SinaWeibo *sinaweibo;
@property (nonatomic, readonly) TCWBEngine *tencentWeibo;

@end
