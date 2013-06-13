//
//  ContentImageCache.h
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-2-27.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "SQLitePersistentObject.h"
#import "GodCacheObject.h"

@interface ContentImageCache : GodCacheObject

@property (nonatomic, readwrite, copy) NSString *imagePath;
@property (nonatomic, readwrite, retain) NSData *contentImageData;

+ (void)saveContentImage:(UIImage*)image forKey:(NSString*)key;

+ (UIImage*)getContentImageForKey:(NSString*)key;

+ (void)clearCache;

@end
