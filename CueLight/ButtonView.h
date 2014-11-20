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

@property int stateCount;

//  Main button views
@property UIButton *button;
@property UIView   *colourView;

//  Speak button views
@property UIButton *speakButton;
@property UIView   *speakColourView;
@property (nonatomic) NSString *speakButtonState;

//  Connection properties
@property UIView   *connectionOverlay;
@property (nonatomic) BOOL connected;

@property (nonatomic, weak) id <ButtonViewDelegate> delegate;

- (void)nextState;
- (void)resetState;

@end
