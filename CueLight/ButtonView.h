//
//  ButtonView.h
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//
//  Description : UIView subclass that creates the UI for the main button
//

#import <UIKit/UIKit.h>
#import "MPController.h"

#import "AudioController.h"
#import "Constants.m"

//  Protocol for other objects getting data from this class
@protocol ButtonViewDelegate <NSObject>

- (void)sendNextState;
- (void)speakButtonPressed;

@end

@interface ButtonView : UIView {
    NSArray *states;
}

@property (        nonatomic) int stateCount;

//  Main button views
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIView   *colourView;

//  Speak button views
@property (strong, nonatomic) UIButton *speakButton;
@property (strong, nonatomic) UIView   *speakColourView;
@property (strong, nonatomic) NSString *speakButtonState;

//  Connection properties
@property (strong, nonatomic) UIView   *connectionOverlay;
@property (        nonatomic) BOOL connected;

@property (weak  , nonatomic) id <ButtonViewDelegate> delegate;

- (void)nextState;
- (void)resetState;

@end
