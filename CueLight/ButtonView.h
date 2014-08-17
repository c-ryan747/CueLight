//
//  ButtonView.h
//  CueLight
//
//  Created by Callum Ryan on 30/07/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPController.h"

@interface ButtonView : UIView {
    NSArray *states;
}
@property (        nonatomic) int stateCount;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIView   *colourView;
@property (strong, nonatomic) UIView   *connectionOverlay;
@property (        nonatomic) BOOL connected;

- (void)nextState;
- (void)resetState;

@end
