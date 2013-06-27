//
//  WeiboInputViewController.h
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-2-20.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "GodViewController.h"

typedef enum InputType {
    IsNewWeibo = 0,
    IsComment
}InputType;

@protocol WeiboInputViewDelegate;

@interface WeiboInputViewController : GodViewController {
    __unsafe_unretained id <WeiboInputViewDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) id <WeiboInputViewDelegate> delegate;

- (void)inputType:(InputType)type title:(NSString*)title;

@end





@protocol WeiboInputViewDelegate <NSObject>

- (void)sendButtonClicked:(NSString*)content type:(InputType)type;

@end
