//
//  SelectShowVC.m
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "SelectShowVC.h"

@implementation SelectShowVC

@synthesize shows = _shows;

#pragma mark - Init/reload
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadShowData];
    
    //  Single editing mode only
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    //  Correctly display back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    //  Register for notification on showDataChanged
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadShowData) name:@"showDataChanged" object:nil];
}

- (void)reloadShowData {
    //Update data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.shows = [NSMutableArray arrayWithArray:[defaults objectForKey:@"shows"]];
    
    //Refresh UI
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //  Create cell from Main.storyboard, add correct name
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"showCell" forIndexPath:indexPath];
    cell.textLabel.text = self.shows[indexPath.row][@"showName"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//  Add show deletion behaviour
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //  Remove show locally
        [self.shows removeObjectAtIndex:indexPath.row];
        
        //  Update persistent storage
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.shows forKey:@"shows"];
        [defaults synchronize];
        
        //  Update UI with animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];

    }
}

#pragma mark - transition methods
//  Called when showCell is tapped
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToList"]) {
        //  Get index of tapped cell
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        //  Give new vc the index
        InShowVC *vc = [segue destinationViewController];
        [vc setShowIndex:(int)indexPath.row];
    }
}


@end
