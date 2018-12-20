//
//  BBPhotoCache.h
//  RoverHybrid
//
//  Created by Brady Bentley on 12/20/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BBPhotoCache : NSObject

@property (nonatomic, readonly, class) BBPhotoCache *sharedCache;

-(void)cacheImageData: (NSData *)data
        forIdentifier: (NSInteger)identifier;

-(NSData *)imageDataForIdentifier: (NSInteger)identifier;

@end


