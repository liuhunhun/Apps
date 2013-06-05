//
//  WeiboCache.h
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-3-1.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObject.h"

@interface WeiboCache : SQLitePersistentObject

@property (nonatomic, readwrite, retain) NSData *weiboData;

@end
