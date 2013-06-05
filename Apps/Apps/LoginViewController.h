//
//  LoginViewController.h
//  Apps
//
//  Created by 乱柒ハ糟 on 13-4-27.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GodViewController.h"

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginDidSuccessed:(AppLoginStatus)status;

@end

@interface LoginViewController : GodViewController {
    __unsafe_unretained id <LoginViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <LoginViewControllerDelegate> delegate;

@end
