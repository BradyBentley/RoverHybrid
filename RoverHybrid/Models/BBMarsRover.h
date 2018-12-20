//
//  BBMarsRover.h
//  RoverHybrid
//
//  Created by Brady Bentley on 12/19/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: - enum
typedef NS_ENUM(NSInteger, BBMarsRoverStatus){
    BBMarsRoverStatusActive,
    BBMarsRoverStatusComplete
};

@interface BBMarsRover : NSObject


// MARK: - Properties
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *launchDate;
@property (nonatomic, readonly) NSString *landingDate;
@property (nonatomic, readonly) NSInteger maxSol;
@property (nonatomic, readonly) NSString *maxDate;
@property (nonatomic, readonly) BBMarsRoverStatus status;
@property (nonatomic, readonly) NSInteger totalPhotos;
@property (nonatomic, readonly) NSArray *solDescriptions;

// MARK: - Initialazation
-(instancetype)initWithDictionary: (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
