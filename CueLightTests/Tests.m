//
//  CueLightTests.m
//  CueLightTests
//
//  Created by Callum Ryan on 30/07/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ButtonView.h"
#import "InShowVC.h"

@interface Tests : XCTestCase

@end

@implementation Tests

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
    UIView *blackToWhiteView = [[UIView alloc]init];
    blackToWhiteView.layer.backgroundColor = [UIColor blackColor].CGColor;
    [button changeColour:[UIColor whiteColor] ofViews:@[blackToWhiteView] animated:NO];
    
    XCTAssertEqual(blackToWhiteView.layer.backgroundColor, [UIColor whiteColor].CGColor,@"Didn't change views colour correctly");
}

- (void)testNextThree
{
    InShowVC *vc = [[InShowVC alloc]init];
    vc.cueList = [@[@"A",@"B",@"C",@"D",@"E",@"F"] mutableCopy];
    
    NSArray *expectedResult = @[];
    NSArray *result = @[];
    
    //normal test
    expectedResult = @[@"1. C",@"2. D",@"3. E"];
    vc.currentCue = 2;
    result = [vc getNextThreeCues];
    XCTAssertEqualObjects(result, expectedResult,@"Failed next three normal test");
    
    
    //borderline
    expectedResult = @[@"1. A",@"2. B",@"3. C"];
    vc.currentCue = 0;
    result = [vc getNextThreeCues];
    XCTAssertEqualObjects(result, expectedResult,@"Failed next three borderline test");
    
    //extreme
    expectedResult = @[@"",@"",@""];
    vc.currentCue = -5;
    result = [vc getNextThreeCues];
    XCTAssertEqualObjects(result, expectedResult,@"Failed next three extreme test");
}

@end
