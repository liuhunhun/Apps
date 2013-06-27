//
//  WeiboCommentCell.m
//  Apps
//
//  Created by waiting_alone on 13-6-14.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "WeiboCommentCell.h"
#import "EGOImageButton.h"

@implementation WeiboCommentCell

@synthesize avatarButton;
@synthesize nameLabel;
@synthesize contentLabel;
@synthesize timeLabel;
@synthesize commentDic;

+ (CGFloat)cellHeight:(NSDictionary*)weiboInfo {
    CGFloat cellHeight = 40;
    
    CGSize size = [[weiboInfo objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeWordWrap];
    cellHeight += size.height;

    return cellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        avatarButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default_avatar.png"]];
        avatarButton.frame = CGRectMake(10, 5, 30, 30);
        [self addSubview:avatarButton];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 180, 20)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 5, 80, 20)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor grayColor];
        [self addSubview:timeLabel];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 250, 0)];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.lineBreakMode = UILineBreakModeWordWrap;
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = [contentLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeWordWrap];
    contentLabel.frame = CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, size.width, size.height);
}

@end
