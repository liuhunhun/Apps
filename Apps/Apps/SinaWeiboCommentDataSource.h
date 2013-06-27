//
//  SinaWeiboCommentDataSource.h
//  Apps
//
//  Created by waiting_alone on 13-6-18.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "GodDataSource.h"

@interface SinaWeiboCommentDataSource : GodDataSource

- (void)removeLastObject;

- (NSString*)lastCommentID;

@end