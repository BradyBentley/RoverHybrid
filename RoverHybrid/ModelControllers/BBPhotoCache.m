//
//  BBPhotoCache.m
//  RoverHybrid
//
//  Created by Brady Bentley on 12/20/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import "BBPhotoCache.h"

@interface BBPhotoCache()

@property (nonatomic, readonly) NSCache *cache;

@end

@implementation BBPhotoCache

+(instancetype)sharedCache
{
    static BBPhotoCache *sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [self new];
    });
    return sharedCache;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [NSCache new];
        _cache.name = @"com.BradyBentley.MarsRover.PhotosCache";
    }
    return self;
}

- (void)cacheImageData:(NSData *)data forIdentifier:(NSInteger)identifier
{
    [[self cache] setObject:data forKey:@(identifier) cost:data.length];
}

- (NSData *)imageDataForIdentifier:(NSInteger)identifier
{
    NSData *dataCache = [[self cache] objectForKey:@(identifier)];
    return dataCache;
}

@end
