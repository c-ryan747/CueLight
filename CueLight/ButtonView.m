//
//  ButtonView.m
//  CueLight
//
//  Created by Callum Ryan on 30/07/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ButtonView.h"

@implementation ButtonView
@synthesize button, stateCount, colourView, connected = _connected, speakColourView, speakButton;

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.window bringSubviewToFront:self];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        
        states = @[@{@"colour":[UIColor greenColor] , @"text":@"Relax"},
                   @{@"colour":[UIColor orangeColor], @"text":@"Get Ready"},
                   @{@"colour":[UIColor greenColor] , @"text":@"Ready"},
                   @{@"colour":[UIColor orangeColor], @"text":@"Go"}];
        
        self.stateCount = 0;
        
        self.backgroundColor = [UIColor grayColor];
        
        UIToolbar* blur = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 108)];
        [blur setBarStyle:UIBarStyleDefault];
        

        
        //main button
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(10, 15, (2*screenWidth-60)/3, 78);
        [self.button setTitle:states[self.stateCount][@"text"] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont boldSystemFontOfSize:32.0];
        
        self.button.layer.borderColor = [UIColor whiteColor].CGColor;
        self.button.layer.borderWidth = 2.0;
        self.button.layer.cornerRadius = 10;
        
        [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.colourView = [[UIView alloc]initWithFrame:CGRectMake(7, 17, (2*screenWidth-60)/3 + 6, 84)];
        [self changeColour:states[self.stateCount][@"colour"] ofViews:@[self.colourView, self.button] animated:NO];
        
        
        //speak button
        self.speakButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.speakButton.frame = CGRectMake(20 +(2*screenWidth-60)/3, 15, (screenWidth-30)/3, 78);
        [self.speakButton setImage:[UIImage imageNamed:@"MicIcon"] forState:UIControlStateNormal];
        [self.speakButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.speakButton.titleLabel.font = [UIFont boldSystemFontOfSize:32.0];
        
        self.speakButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.speakButton.layer.borderWidth = 2.0;
        self.speakButton.layer.cornerRadius = 10;
        self.speakButton.layer.backgroundColor = [UIColor orangeColor].CGColor;
        
        [self.speakButton addTarget:self action:@selector(speakButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.speakColourView = [[UIView alloc]initWithFrame:CGRectMake(17 +(2*screenWidth-60)/3, 17, (screenWidth-30)/3 + 6, 84)];
        [self changeColour:[UIColor orangeColor] ofViews:@[self.speakColourView, self.speakButton] animated:NO];
        
    
        
        self.connectionOverlay = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 108)];
        self.connectionOverlay.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        self.connectionOverlay.alpha = 0.f;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(screenWidth / 2, 108 / 2);
        
        [self.connectionOverlay addSubview:spinner];
        
        
        //add all the subviews in order
        [self addSubview:self.colourView];
        [self addSubview:self.speakColourView];
        [self addSubview:blur];
        
        [self addSubview:self.button];
        [self addSubview:self.speakButton];
        
        [self addSubview:self.connectionOverlay];

    }
    return self;
}

#pragma mark - State transition
- (void)nextState {
    if (self.stateCount >= states.count - 1) {
        self.stateCount = 0;
    } else {
        self.stateCount++;
    }
    [self loadState];
}

- (void)loadState {
    [self.button setTitle:states[self.stateCount][@"text"]   forState:UIControlStateNormal];
    [self    changeColour:states[self.stateCount][@"colour"] ofViews:@[self.colourView, self.button] animated:YES];
}

- (void)resetState {
    self.stateCount = 0;
    [self loadState];
}

- (void)changeColour:(UIColor *)colour ofViews:(NSArray *)views animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            for (UIView *view in views) {
                view.layer.backgroundColor = colour.CGColor;
            }
        } completion:NULL];
    } else {
        for (UIView *view in views) {
            view.layer.backgroundColor = colour.CGColor;
        }
    }
}

#pragma mark - Event responce
- (void)buttonPressed:(id)sender {
    if (self.stateCount == 0 ||self.stateCount == 2) {
        return;
    } else {
        [self nextState];
        [self.delegate sendNextState];
        
    }
}
- (void)speakButtonPressed:(id)sender {
    AudioController *ac = [AudioController sharedInstance];
    if (ac.canRecord) {
        if (ac.recorder.recording) {
            [ac stop];
            [ac sendToPeer:[MPController sharedInstance].controllerID];
        } else {
            [ac start];
        }
    }
}
-(void)setConnected:(BOOL)connected {
    _connected = connected;
    if (connected) {
        [(UIActivityIndicatorView *)self.connectionOverlay.subviews[0] stopAnimating];
        [UIView animateWithDuration:0.5 animations:^{
            self.connectionOverlay.alpha = 0.f;
        } completion:NULL];
    } else {
        [(UIActivityIndicatorView *)self.connectionOverlay.subviews[0] startAnimating];
        [UIView animateWithDuration:0.5 animations:^{
            self.connectionOverlay.alpha = 1.f;
        } completion:NULL];
    }
}
@end
