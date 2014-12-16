//
//  HelpTVC.m
//  CueLight
//
//  Created by Callum Ryan on 05/12/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "HelpVC.h"

@interface HelpVC () {
    NSArray *_helpText;
}

@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _helpText = @[//    Typical Use
                  @[@"Creating a new show\nFrom the first screen touch the ‘+’ button in the top right hand corner. Then tap on the white box below ‘Show name’ and type in the new shows name. Then do the same for your role in the show. After both text boxes have been completed click ‘Create’ at the top right. You can click ‘Cancel’ in the top left at any time to stop the process.",
                    
                    @"Loading a new show\nTo load into an existing show, touch the name of the show you want to load from the first screen.",
                    
                    @"Deleting a show\nTo delete a show swipe from right to left on the shows name in the first screen, then click the red delete button that appears.",
                    
                    @"Adding a cue\nFirstly make sure your loaded into the appropriate show, then tap on the ‘+’ button at the bottom of your cue list.",
                    
                    @"Editing a cue\nTo edit a cues description, touch to the right of a cues number, and then type the description via the onscreen keyboard. When you are finished simply scroll the cue list a small amount or tap away and the keyboard will be removed.",
                    
                    @"Deleting a cue\nTo delete a cue swipe from left to right on the cue in question then touch the red ‘Delete’ button.",
                    
                    @"Communicating cue responses\nWhen the stage manager has sent you a request to get ready or run a cue your device will vibrate and the main button will change its colour and text. You then have to acknowledge that you’ve received this by tapping that button once.",
                    
                    @"Communicating other information\nTo communicate any other information with an operator tap on the microphone button at the top right. Then audibly speak your message, tapping that button again to indicate the end of your message. This audio will then be sent to the operator.\nWhen you receive a message from an operator the microphone button will change to display a speaker symbol. To listen to that message just touch that button and it will start to play. The message will automatically be dismissed at the end but you can prematurely dismiss it by touching the button again.\nNote: A microphone will be needed to send this information, and the volume turned up to receive it"],
                  
                  //    Backup
                  @[@"Backing up\nShow information should be backed up after every significant change. This can be achieved by either one of the two standard iOS backup mechanisms.\nTo back up to a computer plug the device into the computer using a USB cable, then launch iTunes or install iTunes if not present. Then click on the device icon in the top right of the window, followed by the centrally placed back up button. Leave the device plugged in until iTunes has finished backing up your devices data.\nTo back up to iCloud first make sure you’re signed in on the device in question. Then open settings and navigate to ‘iCloud’ then ‘Backup’. Enabling this switch will automatically back up your device data at the next convenient time."],
                  
                  //    Troubleshooting
                  @[@"Problem: Can’t download application\nCause: No network connection\nFix: Connect to the Hawthorn WIFI network and reattempt",
                    
                    @"Problem: Can’t launch application\nCause: No certificate installed\nFix: Reinstall the application and certificate detailed in section 1",
                    
                    @"Problem: Can’t create a show\nCause: Not all fields provided\nFix: Make sure the ‘Show name’ and ‘Operator role’ fields are complete before touching ‘Create’",
                    
                    @"Problem: Can’t send an audio message\nCause: Audio permissions not granted\nFix: Go into Settings > Privacy > Microphone and enable CueLight. Then restart the app.",
                    
                    @"Problem: Can’t connect to the stage manager\nCause: No network connection\nFix: Connect to the Hawthorn WIFI network and reattempt"]];
    
    //  Allow for dynamic height cells
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
- (IBAction)goBack:(id)sender {
    //  Dismiss on back button press
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_helpText count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_helpText[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Typical Use";
            break;
        case 1:
            return @"Backup";
            break;
        case 2:
            return @"Troubleshooting";
            break;
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlainCell" forIndexPath:indexPath];
    cell.textLabel.text = _helpText[indexPath.section][indexPath.row];
    
    return cell;
}

@end
