//
//  CueLightTests.m
//  CueLightTests
//
//  Created by Callum Ryan on 30/07/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ButtonView.h"

@interface ButtonTexts : XCTestCase

@end

@implementation ButtonTexts

- (void)testChangeColour
{
    ButtonView *button = [[ButtonView alloc]init];
    UIView *blackToWhiteView = [[UIView alloc]init];
    blackToWhiteView.layer.backgroundColor = [UIColor blackColor].CGColor;
    [button changeColour:[UIColor whiteColor] ofViews:@[blackToWhiteView] animated:NO];
    
    XCTAssertEqual(blackToWhiteView.layer.backgroundColor, [UIColor whiteColor].CGColor,@"Didn't change views colour correctly");
}

- (void)testNextState
{
    ButtonView *button = [[ButtonView alloc]init];
    button.stateCount = 0;
    blackToWhiteView.layer.backgroundColor = [UIColor blackColor].CGColor;
    [button changeColour:[UIColor whiteColor] ofViews:@[blackToWhiteView] animated:NO];
    
    XCTAssertEqual(blackToWhiteView.layer.backgroundColor, [UIColor whiteColor].CGColor,@"Didn't change views colour correctly");
}


@end
