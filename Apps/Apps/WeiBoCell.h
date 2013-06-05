//
//  WeiBoCell.h
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-2-18.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageButton;

@interface WeiBoCell : UITableViewCell {
    EGOImageButton *avatarButton;
    EGOImageButton *contentImageButton;
    UILabel *nameLabel;
    UILabel *contentLabel;
    UILabel *timeLabel;
    
    UIImageView *retweetBgImageView;
    UILabel *retweetContentLabel;
    EGOImageButton *retweetContentImageButton;
    
    NSNumber *weiboID;
}

@property (nonatomic, readonly) EGOImageButton *avatarButton;
@property (nonatomic, readonly) EGOImageButton *contentImageButton;
@property (nonatomic, readonly) UILabel *contentLabel;
@property (nonatomic, readonly) UILabel *nameLabel;
@property (nonatomic, readonly) UILabel *timeLabel;
@property (nonatomic, readonly) UILabel *retweetContentLabel;
@property (nonatomic, readonly) EGOImageButton *retweetContentImageButton;
@property (nonatomic, retain) NSNumber *weiboID;

+ (CGFloat)cellHeight:(NSDictionary*)weiboInfo;

@end