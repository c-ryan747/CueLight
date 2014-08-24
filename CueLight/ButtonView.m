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
@synthesize button, stateCount, colourView, connected = _connected;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.window bringSubviewToFront:self];
        
        states = @[@{@"colour":[UIColor greenColor] , @"text":@"Relax"      , @"flashing":@NO},
                   @{@"colour":[UIColor orangeColor], @"text":@"Get Ready"  , @"flashing":@YES},
                   @{@"colour":[UIColor greenColor] , @"text":@"Ready"      , @"flashing":@NO},
                   @{@"colour":[UIColor orangeColor], @"text":@"Go"        , @"flashing":@YES}];
        
        self.stateCount = 0;
        
        self.backgroundColor = [UIColor grayColor];
        
        self.colourView = [[UIView alloc]initWithFrame:CGRectMake(7, 17, 306, 84)];
        [self addSubview:self.colourView];
        
//        [UIView animateWithDuration:6.0 animations:^{
//            colour.layer.backgroundColor = [UIColor redColor].CGColor;
//        } completion:NULL];
        
        
        //for ios 8
//        UIVisualEffectView *blur = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//        blur.frame = self.frame;
//        [self addSubview:blur];
        UIToolbar* blur = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [blur setBarStyle:UIBarStyleDefault];
        [self addSubview:blur];

        
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(10, 15, 300, 78);
        [self.button setTitle:states[self.stateCount][@"text"] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont boldSystemFontOfSize:32.0];
        
        self.button.layer.borderColor = [UIColor whiteColor].CGColor;
        self.button.layer.borderWidth = 2.0;
        self.button.layer.cornerRadius = 10;
        
        [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.button];
        
        
        [self changeColour:states[self.stateCount][@"colour"] animated:NO];
        
        
        self.connectionOverlay = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.connectionOverlay.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        self.connectionOverlay.alpha = 0.f;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        
        [self.connectionOverlay addSubview:spinner];
        
        [self addSubview:self.connectionOverlay];

    }
    return self;
}
- (void)nextState
{
    if (self.stateCount >= states.count - 1) {
        self.stateCount = 0;
    } else {
        self.stateCount++;
    }
    [self loadState];
}
- (void)loadState
{
    [self.button setTitle:states[self.stateCount][@"text"]   forState:UIControlStateNormal];
    [self    changeColour:states[self.stateCount][@"colour"] animated:YES];
}
- (void)changeColour:(UIColor *)colour animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.colourView.layer.backgroundColor = colour.CGColor;
            self.button.layer.backgroundColor = colour.CGColor;
        } completion:NULL];
    } else {
        self.colourView.layer.backgroundColor = colour.CGColor;
        self.button.layer.backgroundColor = colour.CGColor;
        
    }
}
- (void)buttonPressed:(id)sender
{
    if (self.stateCount == 0 ||self.stateCount == 2) {
        return;
    } else {
        [self nextState];
        
        [[MPController sharedInstance] sendObject:@"nextState" ToPeers:@[[MPController sharedInstance].controllerID]];
        
    }
}
-(void)setConnected:(BOOL)connected
{
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
- (void)resetState
{
    self.stateCount = 0;
    [self loadState];
}
@end
