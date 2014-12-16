//
//  CreateShowVC.m
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "CreateShowVC.h"

@implementation CreateShowVC

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  Create blank array
    self.showInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    
    //  Required registering of used UITableViewCells for management
    [self.tableView registerClass:[TextBoxTVC class] forCellReuseIdentifier:@"textCell"];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //  Create new cell and assign delegate as self
    TextBoxTVC *cell = (TextBoxTVC *)[tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
    
    cell.textField.tag = indexPath.section;
    cell.textField.delegate = self;
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Shown name";
            break;
        case 1:
            return @"Operator role";
            break;
        default:
            return @"";
            break;
    }
}

#pragma mark - Textfield delegate
- (void)textFieldDidChange:(UITextField *)textField {
    //  Update showInfo with inputted text
    switch (textField.tag) {
        case 0:
            self.showInfo[@"showName"] = textField.text;
            break;
        case 1:
            self.showInfo[@"opRole"] = textField.text;
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    //  Remove the keyboard from display
    [aTextfield resignFirstResponder];
    
    return YES;
}

#pragma mark - Button actions
- (IBAction)finish:(id)sender {
    //  if user hasnt inputted data, show error message, else save then dismiss
    if ([(NSString *)self.showInfo[@"showName"] length] == 0 || [(NSString *)self.showInfo[@"opRole"] length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please complete all fields" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else {
        //  Get current information
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.showInfo[@"cues"] = [NSArray array];
        NSMutableArray *shows = [NSMutableArray arrayWithArray:[defaults objectForKey:@"shows"]];
        //  Update
        [shows addObject:self.showInfo];
        
        //  Save & notify
        [defaults setObject:shows forKey:@"shows"];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showDataChanged" object:self];
        
        //  Dismiss
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancel:(id)sender {
    //  Dismiss on cancel button press
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
