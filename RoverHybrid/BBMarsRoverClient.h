//
//  BBMarsRoverClient.h
//  RoverHybrid
//
//  Created by Brady Bentley on 12/19/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBMarsRover.h"
#import "BBRoverPhotos.h"


@interface BBMarsRoverClient : NSObject

// MARK: - Methods
+(void)fetchAllMarsRoversWithCompletion: (void(^)(NSArray *roverNames , NSError *error))completion;

+(void)fetchMissionManifestForRoverNamed: (NSString *)named
                                  withCompletion: (void(^)(BBMarsRover *rover, NSError *error))completion;

+(void)fetchPhotosFromRover: (BBMarsRover *)rover
                              onSol: (NSInteger )sol
                     withCompletion: (void(^)(NSArray *photos, NSError *error))completion;

+(void)fetchImageDataForPhoto: (BBRoverPhotos* )photo
                       withCompeltion: (void(^)(NSData *imageData, NSError *error))completion;

@end
