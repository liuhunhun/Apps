//
//  SinaWeiBoDataSource
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-2-18.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GodDataSource.h"

@interface SinaWeiBoDataSource : GodDataSource

- (NSString*)lastWeiboID;

// 由于新浪微博请求更多微博的接口返回的数据是大于等于上传的微博ID，所以导致最后一条和新一条重复，所以只能将原来的最后一条在本地删除
- (void)removeLastObject;

@end
