//
//  WeiboInputViewController.h
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-2-20.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "GodViewController.h"

@protocol WeiboInputViewDelegate;

@interface WeiboInputViewController : GodViewController {
    __unsafe_unretained id <WeiboInputViewDelegate> delegate;
}

@property (nonatomic, assign) id <WeiboInputViewDelegate> delegate;

@end

@protocol WeiboInputViewDelegate <NSObject>

- (void)sendNewWeibo:(NSString*)weiboContent;

@end
