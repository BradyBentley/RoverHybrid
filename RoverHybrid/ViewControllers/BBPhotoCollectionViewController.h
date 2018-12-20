//
//  BBPhotoCollectionViewController.h
//  RoverHybrid
//
//  Created by Brady Bentley on 12/20/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSolDescription.h"
#import "BBMarsRover.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBPhotoCollectionViewController : UICollectionViewController

@property (nonatomic) BBSolDescription *sol;
@property (nonatomic) BBMarsRover *rover;

@end

NS_ASSUME_NONNULL_END
