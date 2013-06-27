//
//  SinaWeiboContentView.h
//  Apps
//
//  Created by 乱柒ハ糟 on 13-6-2.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageButton;

@interface SinaWeiboContentView : UIView {
    EGOImageButton *weiboContentImageButton;
    EGOImageButton *retweetContentImageButton;
}

@property (nonatomic, readonly) EGOImageButton *weiboContentImageButton;
@property (nonatomic, readonly) EGOImageButton *retweetContentImageButton;

- (id)initWithWeiboInfo:(NSDictionary*)info;

@end