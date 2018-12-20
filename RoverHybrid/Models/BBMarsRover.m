//
//  BBMarsRover.m
//  RoverHybrid
//
//  Created by Brady Bentley on 12/19/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import "BBMarsRover.h"
#import "BBSolDescription.h"

@implementation BBMarsRover


// MARK: - Initialization
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _name = dictionary[@"name"];
        if (!_name) { return nil; }
        _launchDate = dictionary[@"launch_date"];
        _landingDate = dictionary[@"landing_date"];
        _maxSol = [dictionary[@"max_sol"] integerValue];
        _maxDate = dictionary[@"max_date"];
        _status = [dictionary[@"status"] isEqualToString:@"active"] ? BBMarsRoverStatusActive:BBMarsRoverStatusComplete;
        _totalPhotos = [dictionary[@"total_photos"]integerValue];
        
        NSArray *solDescriptionDictionaries = dictionary[@"photos"];
        NSMutableArray *solDescriptions = [NSMutableArray new];
        for (NSDictionary *sol in solDescriptionDictionaries) {
            BBSolDescription *solDescription = [[BBSolDescription alloc] initWithDictionary:sol];
            if (!solDescription) {continue;}
            [solDescriptions addObject:solDescription];
        }
        _solDescriptions = [solDescriptions copy];
    }
    return self;
}

@end
