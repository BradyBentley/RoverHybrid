//
//  BBRoverPhotos.m
//  RoverHybrid
//
//  Created by Brady Bentley on 12/19/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import "BBRoverPhotos.h"


@implementation BBRoverPhotos

// MARK: - Initialization
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _identifier = [dictionary[@"id"] integerValue];
        _sol = [dictionary[@"sol"] integerValue];
        _camerasName = dictionary[@"camera"][@"name"];
        _earthDate = dictionary[@"earth_date"];
        _imageUrl = dictionary[@"img_src"];
    }
    return self;
}

-(BOOL)isEqual: (id)photo {
    if (!photo) { return NO; }
    BOOL haveEqualImageUrl = (![self imageUrl] != ![photo imageUrl]);
    return haveEqualImageUrl;
}

@end
