//
//  showVC.m
//  CueLight
//
//  Created by Callum Ryan on 11/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "showVC.h"

@interface showVC ()

@end

@implementation showVC
@synthesize shows = _shows;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadShowData];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadShowData) name:@"showDataChanged" object:nil];
}

- (void)reloadShowData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.shows = [NSMutableArray arrayWithArray:[defaults objectForKey:@"shows"]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.shows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"showCell" forIndexPath:indexPath];
    cell.textLabel.text = self.shows[indexPath.row][@"showName"];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.shows removeObjectAtIndex:indexPath.row];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:self.shows forKey:@"shows"];
        
        [defaults synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([segue.identifier isEqualToString:@"goToList"])
    {
        ListVC *vc = [segue destinationViewController];
        [vc setShowInfo:self.shows[indexPath.row]];
    }
}


@end
