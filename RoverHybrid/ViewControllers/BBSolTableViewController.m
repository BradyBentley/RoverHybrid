//
//  BBSolTableViewController.m
//  RoverHybrid
//
//  Created by Brady Bentley on 12/20/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import "BBSolTableViewController.h"
#import "BBSolDescription.h"
#import "BBPhotoCollectionViewController.h"

@interface BBSolTableViewController ()

@end

@implementation BBSolTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rover.solDescriptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SolCell" forIndexPath:indexPath];
    BBSolDescription *solDescription = [[self rover] solDescriptions][indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Sol %@", @(solDescription.sol)];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ photos", @(solDescription.numberOfPhotos)];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqual:@"ToPhotoCollectionView"]){
        NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
        BBPhotoCollectionViewController *destinationVC = [segue destinationViewController];
        BBSolDescription *sol = [[self rover] solDescriptions][indexPath.row];
        destinationVC.sol = sol;
        destinationVC.rover = [self rover];
    }
}

- (void)setRover:(BBMarsRover *)rover
{
    if (rover != _rover){
        _rover = rover;
    }
    [[self tableView] reloadData];
}

@end
