//
//  ButtonView.h
//  CueLight
//
//  Created by Callum Ryan on 30/07/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPController.h"
#import "AudioController.h"
#import "Constants.m"

@protocol ButtonViewDelegate <NSObject>

@required
- (void)sendNextState;
- (void)speakButtonPressed;

@end

@interface ButtonView : UIView {
    NSArray *states;
}

@property (        nonatomic) int stateCount;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIView   *colourView;
@property (strong, nonatomic) UIButton *speakButton;
@property (strong, nonatomic) UIView   *speakColourView;
@property (strong, nonatomic) UIView   *connectionOverlay;
@property (weak  , nonatomic) id <ButtonViewDelegate> delegate;
@property (        nonatomic) BOOL connected;

- (void)nextState;
- (void)resetState;

- (void)changeColour:(UIColor *)colour ofViews:(NSArray *)views animated:(BOOL)animated;

@end
