//
//  GodViewController.h
//  Apps
//
//  Created by 乱柒ハ糟 on 13-4-28.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SinaWeiboLogin,
    TencentWeiboLogin
} AppLoginStatus;

@class SinaWeibo;
@class TCWBEngine;

@class MyActivityIndicator;
@class MenuView;
@class ToolBarView;

@interface GodViewController : UIViewController {
    BOOL needTableView;
    UITableView *_tableView;

    BOOL needActivityIndicator;
    MyActivityIndicator *_activityIndicator;

    BOOL needTopMenu;
    MenuView *topMenuView;

    BOOL needToolBarView;
    NSArray *toolBarItemImages;
    ToolBarView *toolBarView;
}

- (SinaWeibo*)sinaWeibo;

- (BOOL)sinaWeiboAuthValid;

- (TCWBEngine*)tencentWeibo;

- (BOOL)tencentWeiboAuthValid;

- (void)authorizeSuccessed:(AppLoginStatus)status;

- (void)revertTableView;

@end
