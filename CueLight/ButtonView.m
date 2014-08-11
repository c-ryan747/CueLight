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
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.window bringSubviewToFront:self];
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

        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10, 20, 300, 78);
        [button setTitle:@"GO" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:32.0];
        button.backgroundColor = [UIColor greenColor];
        
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 2.0;
        button.layer.cornerRadius = 10;
        [self addSubview:button];
    }
    return self;
}

@end
