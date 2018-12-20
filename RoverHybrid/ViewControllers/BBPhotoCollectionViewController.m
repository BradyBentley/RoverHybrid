//
//  BBPhotoCollectionViewController.m
//  RoverHybrid
//
//  Created by Brady Bentley on 12/20/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import "BBPhotoCollectionViewController.h"
#import "BBMarsRoverClient.h"
#import "BBRoverPhotos.h"
#import "BBPhotoCache.h"
#import "BBPhotoCollectionViewCell.h"
#import "RoverHybrid-Bridging-Header.h"
#import "RoverHybrid-Swift.h"


@interface BBPhotoCollectionViewController ()

@property (nonatomic, readonly) BBMarsRoverClient *client;
@property (nonatomic) NSArray *photos;

@end

@implementation BBPhotoCollectionViewController

static NSString * const reuseIdentifier = @"PhotoCell";

// MARK: - Methods
-(void)fetchPostReferences
{
    [BBMarsRoverClient fetchPhotosFromRover:self.rover onSol:self.sol.sol withCompletion:^(NSArray *photos, NSError *error) {
        if (error) {
            NSLog(@"Error fetching photos for collection view");
            return;
        };
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = photos;
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPostReferences];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"ToPhotoDetail"]){
        NSIndexPath *indexPath = [[self collectionView] indexPathsForSelectedItems][0];
        PhotoDetailViewController *destinationVC = [segue destinationViewController];
        BBRoverPhotos *photo = [self photos][indexPath.row];
//        destinationVC.photo = photo;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self photos] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    BBRoverPhotos *photo = [self photos][indexPath.row];
    BBPhotoCache *cache = [BBPhotoCache sharedCache];
    NSData *cacheData = [cache imageDataForIdentifier:photo.identifier];
    if (cache != nil){
        UIImage *image = [UIImage imageWithData: cacheData];
        cell.photoImageView.image = image;
    } else {
        cell.photoImageView.image = [UIImage imageNamed: @"MarsPlaceholder"];
    }
    [BBMarsRoverClient fetchImageDataForPhoto:photo withCompeltion:^(NSData *imageData, NSError *error) {
        if (error) {
            NSLog(@"Error fetching image Data for photos");
            return;
        }
        [cache cacheImageData:imageData forIdentifier:photo.identifier];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![indexPath isEqual: [collectionView indexPathForCell:cell]]){
                return;
            }
            cell.photoImageView.image = image;
        });
    }];
    return cell;
}

@end
