//
//  ToolBarView.m
//  Apps
//
//  Created by 乱柒ハ糟 on 13-5-28.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "ToolBarView.h"

@implementation ToolBarView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame itemImages:(NSArray*)imagesArray {
    self = [self initWithFrame:frame];
    if (self) {
        for (int i=0; i<[imagesArray count]; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 39 * (i + 1), 10, 24, 24)];
            [button setImage:[imagesArray objectAtIndex:i] forState:UIControlStateNormal];
            [self addSubview:button];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i+1;
        }
    }
    return  self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.image = [UIImage imageNamed:@"navigationbar_bg.png"];
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 28, 28)];
        [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        [self addSubview:backBtn];
        [backBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.tag = 0;
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)buttonClicked:(id)sender {
    if ([delegate respondsToSelector:@selector(toolBarViewButtonClicked:)]) {
        UIButton *button = (UIButton*)sender;
        [delegate toolBarViewButtonClicked:button.tag];
    }
}

@end
