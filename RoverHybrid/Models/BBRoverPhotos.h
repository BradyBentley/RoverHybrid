//
//  BBRoverPhotos.h
//  RoverHybrid
//
//  Created by Brady Bentley on 12/19/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBRoverPhotos : NSObject

// MARK: - Properties
@property (nonatomic, readonly) NSInteger identifier;
@property (nonatomic, readonly) NSInteger sol;
@property (nonatomic, readonly) NSString *camerasName;
@property (nonatomic, readonly) NSString *earthDate;
@property (nonatomic, readonly) NSString *imageUrl;

// MARK: - Initialization
-(instancetype)initWithDictionary: (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
