//
//  RootCell.m
//  Apps
//
//  Created by 乱柒ハ糟 on 13-4-28.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "RootCell.h"

@implementation RootCell

@synthesize iconImageView;
@synthesize titleLable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, 25, 25)];
        [self addSubview:iconImageView];
        
        UIImageView *partLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 38, 270, 2)];
        partLineImageView.image = [UIImage imageNamed:@"row_partline.png"];
        [self addSubview:partLineImageView];
        
        titleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 4, 150, 30)];
        titleLable.font = [UIFont boldSystemFontOfSize:17];
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.textColor = [UIColor whiteColor];
        [self addSubview:titleLable];
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
    titleLable.text = nil;
}

@end
