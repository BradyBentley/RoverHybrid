//
//  BBSolDescription.h
//  RoverHybrid
//
//  Created by Brady Bentley on 12/19/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBSolDescription : NSObject

@property (nonatomic, readonly) NSInteger sol;
@property (nonatomic, readonly) NSInteger numberOfPhotos;
@property (nonatomic, readonly) NSArray<NSString *> *cameras;

// MARK: - Initialization
-(instancetype)initWithDictionary: (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
