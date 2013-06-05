//
//  ToolBarView.h
//  Apps
//
//  Created by 乱柒ハ糟 on 13-5-28.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolBarViewDelegate <NSObject>

- (void)toolBarViewButtonClicked:(NSInteger)tag;

@end

@interface ToolBarView : UIImageView {
    __unsafe_unretained id <ToolBarViewDelegate> delegate;
}

@property (nonatomic, assign) id <ToolBarViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame itemImages:(NSArray*)imagesArray;

@end
