//
//  BBMarsRoverClient.m
//  RoverHybrid
//
//  Created by Brady Bentley on 12/19/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import "BBMarsRoverClient.h"

@implementation BBMarsRoverClient

// MARK: - Methods
+ (NSString *)apiKey {
    static NSString *apiKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *apiKeysURL = [[NSBundle mainBundle] URLForResource:@"APIKeys" withExtension:@"plist"];
        if (!apiKeysURL) {
            NSLog(@"Error! APIKeys file not found!");
            return;
        }
        NSDictionary *apiKeys = [[NSDictionary alloc] initWithContentsOfURL:apiKeysURL];
        apiKey = apiKeys[@"APIKey"];
    });
    return apiKey;
}

+ (NSURL *)baseUrl {
    return [NSURL URLWithString:@"https://api.nasa.gov/mars-photos/api/v1"];
}
//URL for Rover
+ (NSURL *)urlForInfoForRover: (NSString *)roverName {
    NSURL *url = [self baseUrl];
    url = [[url URLByAppendingPathComponent:@"manifests"] URLByAppendingPathComponent:roverName];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"api_key" value:@"sQRcPdYh10YjIZNK6ERb7JOtruvccdaqzDWxVVFi"]];
    return urlComponents.URL;
}
//URL for Photos
+ (NSURL *)urlForPhotosFromRover: (NSString *)roverName
                             sol: (NSInteger)sol {
    NSURL *url = [self baseUrl];
    url = [[[url URLByAppendingPathComponent:@"rovers"] URLByAppendingPathComponent:roverName] URLByAppendingPathComponent:@"photos"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"sol" value:[@(sol) stringValue]],
                                 [NSURLQueryItem queryItemWithName:@"api_key" value:@"sQRcPdYh10YjIZNK6ERb7JOtruvccdaqzDWxVVFi"]];
    return urlComponents.URL;
}
//URL for RoverName
+(NSURL *)roversEndPoint {
    NSURL *url = [self baseUrl];
    url = [url URLByAppendingPathComponent:@"rovers"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"api_key" value:@"sQRcPdYh10YjIZNK6ERb7JOtruvccdaqzDWxVVFi"]];
    return urlComponents.URL;
}

// MARK: - Fetch Methods
+ (void)fetchAllMarsRoversWithCompletion:(void (^)(NSArray *, NSError *))completion
{
    //URL + Request(if needed0
    NSURL *url = [BBMarsRoverClient roversEndPoint];
    //DataTask + Resume
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error in %s: %@, %@", __PRETTY_FUNCTION__, error, error.localizedDescription);
            completion(nil, error);
            return;
        }
        if(!data) {
            NSLog(@"NO DATA COMING BACK");
            completion(nil, error);
            return;
        }
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *roverArray = jsonDictionary[@"rovers"];
        NSMutableArray *roverNames = [NSMutableArray new];
        for (NSDictionary *rovers in roverArray) {
            NSString *name = rovers[@"name"];
            if (name) { [roverNames addObject:name]; }
        }
        completion(roverNames, nil);
    }]resume];
}

+ (void)fetchMissionManifestForRoverNamed:(NSString *)named withCompletion:(void (^)(BBMarsRover *, NSError *))completion
{
    //URL + request (if needed)
    NSURL *url = [BBMarsRoverClient urlForInfoForRover:named];
    //DataTask + resume
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error in %s: %@, %@", __PRETTY_FUNCTION__, error, error.localizedDescription);
            completion(nil, error);
            return;
        }
        if(!data) {
            NSLog(@"NO DATA COMING BACK");
            completion(nil, error);
            return;
        }
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSDictionary *manifestDictionary = jsonDictionary[@"photo_manifest"];
        BBMarsRover *rover = [[BBMarsRover alloc] initWithDictionary:manifestDictionary];
        completion(rover, nil);
    }]resume];
}

+ (void)fetchPhotosFromRover:(BBMarsRover *)rover onSol:(NSInteger )sol withCompletion:(void (^)(NSArray *, NSError *))completion
{
    //URL + Request (if needed)
    NSURL *url = [BBMarsRoverClient urlForPhotosFromRover:[rover name] sol:sol];
    //DataTask + resume
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error in %s: %@, %@", __PRETTY_FUNCTION__, error, error.localizedDescription);
            completion(nil, error);
            return;
        }
        if(!data) {
            NSLog(@"NO DATA COMING BACK");
            completion(nil, error);
            return;
        }
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *photosArray = jsonDictionary[@"photos"];
        NSMutableArray *photos = [NSMutableArray new];
        for (NSDictionary *photoDictionary in photosArray) {
            BBRoverPhotos *photo = [[BBRoverPhotos alloc] initWithDictionary:photoDictionary];
            [photos addObject:photo];
        }
        completion(photos, nil);
    }]resume];
}

+ (void)fetchImageDataForPhoto:(BBRoverPhotos* )photo withCompeltion:(void (^)(NSData *, NSError *))completion
{
    //URL + request(if needed)
    NSURL *photoUrl = [NSURL URLWithString: photo.imageUrl ];
    //DataTask + resume
    [[[NSURLSession sharedSession] dataTaskWithURL:photoUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error in %s: %@, %@", __PRETTY_FUNCTION__, error, error.localizedDescription);
            completion(nil, error);
            return;
        }
        if(!data) {
            NSLog(@"NO DATA COMING BACK");
            completion(nil, error);
            return;
        }
        completion(data, nil);
    }]resume];
    
}


@end
