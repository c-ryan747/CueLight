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
@synthesize button, stateCount;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.window bringSubviewToFront:self];
        
        states = @[@"Relax",@"Get Ready",@"Ready",@"Go"];
        self.stateCount = 0;
        
        self.backgroundColor = [UIColor grayColor];
        
        UIView *colour = [[UIView alloc]initWithFrame:CGRectMake(7, 17, 306, 84)];
        colour.layer.backgroundColor = [UIColor greenColor].CGColor;
        [self addSubview:colour];
        
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

        
        
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        self.button.frame = CGRectMake(10, 20, 300, 78);
        [self.button setTitle:states[self.stateCount] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont boldSystemFontOfSize:32.0];
        self.button.backgroundColor = [UIColor greenColor];
        
        self.button.layer.borderColor = [UIColor whiteColor].CGColor;
        self.button.layer.borderWidth = 2.0;
        self.button.layer.cornerRadius = 10;
        [self addSubview:self.button];
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
    
    [self.button setTitle:states[self.stateCount] forState:UIControlStateNormal];
}
@end
