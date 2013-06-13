//
//  ContentImageCache.m
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-2-27.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import "ContentImageCache.h"

@implementation ContentImageCache

@synthesize imagePath;
@synthesize contentImageData;

+ (void)saveContentImage:(UIImage*)image forKey:(NSString*)key {
    if (!image && !key) {
        return;
    }
    ContentImageCache *contentImageCache = [[ContentImageCache alloc] init];
    contentImageCache.contentImageData = [NSKeyedArchiver archivedDataWithRootObject:image];
    contentImageCache.imagePath = key;
    [contentImageCache save];
}

+ (UIImage*)getContentImageForKey:(NSString*)key {
    ContentImageCache *imageCache = (ContentImageCache*)[ContentImageCache findFirstByCriteria:@"WHERE image_path = '%@'", key];
    return imageCache.contentImageData ? (UIImage*)[NSKeyedUnarchiver unarchiveObjectWithData:imageCache.contentImageData] : nil;
}

@end