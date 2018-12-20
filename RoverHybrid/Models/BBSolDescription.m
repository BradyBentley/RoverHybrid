//
//  BBSolDescription.m
//  RoverHybrid
//
//  Created by Brady Bentley on 12/19/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import "BBSolDescription.h"

@implementation BBSolDescription

// MARK: - Initialization
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _sol = [dictionary[@"sol"] integerValue];
        _numberOfPhotos = [dictionary[@"total_photos"] integerValue];
        _cameras = dictionary[@"cameras"];
    }
    return self;
}

@end
