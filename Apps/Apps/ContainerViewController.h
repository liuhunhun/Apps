//
//  ContainerViewController.h
//  Apps
//
//  Created by 乱柒ハ糟 on 13-5-14.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "MyGestureController.h"

typedef enum AppsClientStatus {
    AppsClientIsSinaWeibo = 0,
    AppsClientIsTencentWeibo
}AppsClientStatus;

@interface ContainerViewController : MyGestureController

- (void)ChangeClientStatus:(AppsClientStatus)status;

@end
