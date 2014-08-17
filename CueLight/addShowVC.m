//
//  addShowVC.m
//  CueLight
//
//  Created by Callum Ryan on 13/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "addShowVC.h"

@interface addShowVC ()

@end

@implementation addShowVC
@synthesize showInfo;
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.showInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [self.tableView registerClass:[textBoxTVC class] forCellReuseIdentifier:@"textCell"];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    textBoxTVC *cell = (textBoxTVC *)[tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
    cell.textField.tag = indexPath.section+1;
    cell.textField.delegate = self;
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Shown name";
    }
    return @"Operator role";
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.tag == 1) {
        self.showInfo[@"showName"] = textField.text;
    } else {
        self.showInfo[@"opRole"] = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
{
    [aTextfield resignFirstResponder];
    return YES;
}

- (IBAction)finish:(id)sender
{
    if ([(NSString *)self.showInfo[@"showName"] length] == 0 && [(NSString *)self.showInfo[@"opRole"] length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please complete all fields" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        
        NSInteger currentMaxShowID = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentMaxShowID"];
        self.showInfo[@"showID"] = [NSNumber numberWithLong:currentMaxShowID + 1];
        [[NSUserDefaults standardUserDefaults] setInteger:currentMaxShowID + 1 forKey:@"currentMaxShowID"];
        
        self.showInfo[@"cues"] = [NSArray array];

        
        NSMutableArray *shows = [NSMutableArray arrayWithArray:[defaults objectForKey:@"shows"]];
        
        [shows addObject:self.showInfo];
        
        [defaults setObject:shows forKey:@"shows"];
        
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showDataChanged" object:self];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
