//
//  MyGestureController.h
//  CePing
//
//  Created by chengzhao huang on 12-6-5.
//  Copyright (c) 2012年 TianJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GodViewController.h"

@interface MyGestureController : GodViewController {
    CGPoint touchBeganPoint;
    
    BOOL homeViewIsOutOfStage;
    
    BOOL needGestureRecognizer;
    UIPanGestureRecognizer *panGestureRecognizer;
}

- (void)restoreViewLocation:(BOOL)withSound;
- (void)moveToRightSide:(BOOL)withSound;
- (void)leftBarBtnTapped;
- (void)animateHomeViewToSide:(CGRect)newViewRect;

@end