//
//  BBRoverTableViewController.m
//  RoverHybrid
//
//  Created by Brady Bentley on 12/20/18.
//  Copyright © 2018 Brady. All rights reserved.
//

#import "BBRoverTableViewController.h"
#import "BBMarsRoverClient.h"
#import "BBSolTableViewController.h"

@interface BBRoverTableViewController ()

@property (nonatomic, copy) NSArray *rovers;

@end

@implementation BBRoverTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *rovers = [NSMutableArray new];
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [BBMarsRoverClient fetchAllMarsRoversWithCompletion:^(NSArray *roverNames, NSError *error) {
        if (error) {
            NSLog(@"Error in fetching rovers: %@", error.localizedDescription);
            return;
        }
        dispatch_queue_t resultsQueue = dispatch_queue_create("com.bradybentley.roverFetchedQueue", 0);
        for (NSString *name in roverNames){
            dispatch_group_enter(group);
            [BBMarsRoverClient fetchMissionManifestForRoverNamed:name withCompletion:^(BBMarsRover *rover, NSError *error) {
                if (error) {
                    NSLog(@"Error fetching list of mars rovers: %@", error.localizedDescription);
                    return;
                }
                dispatch_async(resultsQueue, ^{
                    [rovers addObject:rover];
                    dispatch_group_leave(group);
                });
            }];
        }
        dispatch_group_leave(group);
    }];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    self.rovers = rovers;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rovers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoverCell" forIndexPath:indexPath];
    BBMarsRover *rover = [self rovers][indexPath.row];
    cell.textLabel.text = rover.name;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqual:@"ToSolTableView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BBSolTableViewController *destinationVC = [segue destinationViewController];
        destinationVC.rover = [self rovers][indexPath.row];
    }
}


@end
