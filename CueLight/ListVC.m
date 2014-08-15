//
//  ListVC.m
//  CueLight
//
//  Created by Callum Ryan on 30/07/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "ListVC.h"
#import "ButtonView.h"
#import "cueTVC.h"

@interface ListVC ()

@end
//@implementation UINavigationBar (customNav)
//- (CGSize)sizeThatFits:(CGSize)size {
//    CGSize newSize = CGSizeMake(self.frame.size.width,88);
//    return newSize;
//}
//@end
@implementation ListVC
@synthesize cueList, button, showInfo = _showInfo;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[cueTVC class] forCellReuseIdentifier:@"cueCell"];
    
    self.mpController = [MPController sharedInstance];

    [self.mpController setupIfNeededWithName:self.showInfo[@"opRole"]];
    [self.mpController advertiseSelf:YES];
    self.mpController.delegate = self;
    
    
    self.button = [[ButtonView alloc]initWithFrame:CGRectMake(0,64, 320, 108)];
    
    self.cueList = [[NSMutableArray alloc] init];
    for (int i=1; i<31; i++) {
        [self.cueList addObject:[NSString stringWithFormat:@"Hello,%d",i]];
    }


    [self.view addSubview:self.button];


    [self.tableView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    self.tableView.backgroundColor = [UIColor blackColor];
//    self.tableView.separatorColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.hidden = YES;
    
    

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
    return self.cueList.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.cueList.count) {
        cueTVC *cell = (cueTVC *)[tableView dequeueReusableCellWithIdentifier:@"cueCell"];
        cell.cueNum.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        cell.textField.text = self.cueList[indexPath.row];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCell"];
        return cell;
    }

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if (indexPath.row > self.cueList.count) {
        return NO;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.cueList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.cueList.count) {
        [self.cueList addObject:[NSString stringWithFormat:@"Hello,%lu",self.cueList.count + 1]];
        [self.tableView reloadData];
    }
}

- (void)recievedMessage:(NSData *)data fromPeer:(MCPeerID *)peer
{
    [self.button nextState];
}
- (void)setShowInfo:(NSDictionary *)showInfo
{
    _showInfo = showInfo;
    self.title = showInfo[@"showName"];
}
-(NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Go To Cue";
}
-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView setEditing:NO animated:YES];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
@end
