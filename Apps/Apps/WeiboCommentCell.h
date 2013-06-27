//
//  WeiboCommentCell.h
//  Apps
//
//  Created by waiting_alone on 13-6-14.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageButton;

@interface WeiboCommentCell : UITableViewCell

@property (nonatomic, retain) NSDictionary *commentDic;
@property (nonatomic, retain, readonly) EGOImageButton *avatarButton;
@property (nonatomic, retain, readonly) UILabel *nameLabel;
@property (nonatomic, retain, readonly) UILabel *contentLabel;
@property (nonatomic, retain, readonly) UILabel *timeLabel;

+ (CGFloat)cellHeight:(NSDictionary*)weiboInfo;

@end
