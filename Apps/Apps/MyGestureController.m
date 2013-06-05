//
//  TJGestureController.m
//  CePing
//
//  Created by chengzhao huang on 12-6-5.
//  Copyright (c) 2012年 TianJi. All rights reserved.
//

#import "MyGestureController.h"
#import <QuartzCore/QuartzCore.h>
#import "AudioToolbox/AudioToolbox.h"

#define kTriggerOffSet 100.0f

@implementation MyGestureController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (needGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (needGestureRecognizer) {
        [self.navigationController.view addGestureRecognizer:panGestureRecognizer];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.view removeGestureRecognizer:panGestureRecognizer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UIPanGestureRecognizer

- (void)handlePanGesture:(UIPanGestureRecognizer*)recognizer {
    static CGFloat srcX;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        srcX = self.navigationController.view.frame.origin.x;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat xOffSet = [recognizer translationInView:[[UIApplication sharedApplication] keyWindow]].x;
        if (srcX+xOffSet < 0 || srcX+xOffSet > 270) {
            return;
        }
        self.navigationController.view.frame = CGRectMake(srcX+xOffSet, 
                                      self.navigationController.view.frame.origin.y, 
                                      self.navigationController.view.frame.size.width, 
                                      self.navigationController.view.frame.size.height);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        float boundAge; 
        if (!homeViewIsOutOfStage) {
            boundAge = 80;
        }else {
            boundAge = 200;
        }
        if (self.navigationController.view.frame.origin.x > boundAge) {
            [self moveToRightSide:YES];
        }
        else {
            [self restoreViewLocation:NO];
        }
    }
}

#pragma mark -
#pragma mark Other methods

// restore view location
- (void)restoreViewLocation:(BOOL)withSound{
    homeViewIsOutOfStage = NO;
    [UIView animateWithDuration:0.25 
                     animations:^{
                         self.navigationController.view.frame = CGRectMake(0, 
                         self.navigationController.view.frame.origin.y, 
                         self.navigationController.view.frame.size.width, 
                         self.navigationController.view.frame.size.height);
                         if (withSound && ![[NSUserDefaults standardUserDefaults] boolForKey:@"Play_Sound"]) {
                             SystemSoundID soundFileObject;
                             CFURLRef soundFileURLRef  = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("view_move"), CFSTR("caf"), NULL);
                             AudioServicesCreateSystemSoundID(soundFileURLRef, &soundFileObject);
                             AudioServicesPlaySystemSound(soundFileObject);
                         }
                     } 
                     completion:^(BOOL finished){
                         UIControl *control = (UIControl*)[[[UIApplication sharedApplication] keyWindow] viewWithTag:10086];
                         if (control) {
                             [control removeFromSuperview];
                         }
                     }];
}

// move view to right side
- (void)moveToRightSide:(BOOL)withSound{
    homeViewIsOutOfStage = YES;
    [self animateHomeViewToSide:CGRectMake(164,
           self.navigationController.view.frame.origin.y, 
           self.navigationController.view.frame.size.width, 
           self.navigationController.view.frame.size.height)];
    if (withSound && ![[NSUserDefaults standardUserDefaults] boolForKey:@"Play_Sound"]) {
        SystemSoundID soundFileObject;
        CFURLRef soundFileURLRef  = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("view_move"), CFSTR("caf"), NULL);
        AudioServicesCreateSystemSoundID(soundFileURLRef, &soundFileObject);
        AudioServicesPlaySystemSound(soundFileObject);
    }
}

// animate home view to side rect
- (void)animateHomeViewToSide:(CGRect)newViewRect {
    [UIView animateWithDuration:0.25 
                     animations:^{
                         self.navigationController.view.frame = newViewRect;
                     } 
                     completion:^(BOOL finished){
                         UIControl *controlIsExit = (UIControl*)[[[UIApplication sharedApplication] keyWindow] viewWithTag:10086];
                         if (!controlIsExit) {
                             UIControl *control = [[UIControl alloc] init];
                             control.tag = 10086;
                             control.backgroundColor = [UIColor clearColor];
                             control.frame = self.navigationController.view.frame;
                             [control addTarget:self action:@selector(restoreViewLocation:) forControlEvents:UIControlEventTouchUpInside];
                             [[[UIApplication sharedApplication] keyWindow] addSubview:control];
                             UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
                             [control addGestureRecognizer:pan];
                         } 
                     }];
}

// handle left bar btn
-(void)leftBarBtnTapped {
    if (homeViewIsOutOfStage) {
        [self restoreViewLocation:YES];
    }else {
        [self moveToRightSide:YES];
    }
}


@end