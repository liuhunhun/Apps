//
//  GodCacheObject.m
//  Apps
//
//  Created by 乱柒ハ糟 on 13-5-3.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "GodCacheObject.h"

@implementation GodCacheObject

+ (void)clearCache {
    NSArray *cacheArray = [GodCacheObject allObjects];
    for (GodCacheObject *cache in cacheArray) {
        [cache deleteObject];
    }
}

@end
