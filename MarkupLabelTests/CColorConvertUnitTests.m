//
//  CColorConvertUnitTests.m
//  MarkupLabel
//
//  Created by Jonathan Wight on 3/13/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CColorConverter.h"

@interface CColorConvertUnitTests : XCTestCase

@end

@implementation CColorConvertUnitTests

- (void)testNamedColor
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"green" error:NULL];
    XCTAssertNil(theDictionary);
//    XCTAssertEqual([theDictionary[@"red"] floatValue], 0.0);
//    XCTAssertEqual([theDictionary[@"green"] floatValue], 1.0);
//    XCTAssertEqual([theDictionary[@"blue"] floatValue], 0.0);
}

- (void)testShortHex
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"0F0" error:NULL];
    XCTAssertEqual([theDictionary[@"red"] floatValue], 0.0);
    XCTAssertEqual([theDictionary[@"green"] floatValue], 1.0);
    XCTAssertEqual([theDictionary[@"blue"] floatValue], 0.0);
    XCTAssertNil(theDictionary[@"alpha"]);
}

- (void)testWithHash
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"#0F0" error:NULL];
    XCTAssertEqual([theDictionary[@"red"] floatValue], 0.0);
    XCTAssertEqual([theDictionary[@"green"] floatValue], 1.0);
    XCTAssertEqual([theDictionary[@"blue"] floatValue], 0.0);
    XCTAssertNil(theDictionary[@"alpha"]);
}

- (void)testLongHex
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"00FF00" error:NULL];
    XCTAssertEqual([theDictionary[@"red"] floatValue], 0.0);
    XCTAssertEqual([theDictionary[@"green"] floatValue], 1.0);
    XCTAssertEqual([theDictionary[@"blue"] floatValue], 0.0);
    XCTAssertNil(theDictionary[@"alpha"]);
}

- (void)testLongHexWithHash
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"#00FF00" error:NULL];
    XCTAssertEqual([theDictionary[@"red"] floatValue], 0.0);
    XCTAssertEqual([theDictionary[@"green"] floatValue], 1.0);
    XCTAssertEqual([theDictionary[@"blue"] floatValue], 0.0);
    XCTAssertNil(theDictionary[@"alpha"]);
}

- (void)testRGB8
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"rgb(0,255,0)" error:NULL];
    XCTAssertEqual([theDictionary[@"red"] floatValue], 0.0);
    XCTAssertEqual([theDictionary[@"green"] floatValue], 1.0);
    XCTAssertEqual([theDictionary[@"blue"] floatValue], 0.0);
    XCTAssertNil(theDictionary[@"alpha"]);
}

- (void)testRGBPercent
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"rgb(0,100%,0)" error:NULL];
    XCTAssertEqual([theDictionary[@"red"] floatValue], 0.0);
    XCTAssertEqual([theDictionary[@"green"] floatValue], 1.0);
    XCTAssertEqual([theDictionary[@"blue"] floatValue], 0.0);
    XCTAssertNil(theDictionary[@"alpha"]);
}

- (void)testRGBAPercent
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"rgba(0,100%,0,50%)" error:NULL];
    XCTAssertEqual([theDictionary[@"red"] floatValue], 0.0);
    XCTAssertEqual([theDictionary[@"green"] floatValue], 1.0);
    XCTAssertEqual([theDictionary[@"blue"] floatValue], 0.0);
    XCTAssertEqual([theDictionary[@"alpha"] floatValue], 0.5);
}

- (void)testRGBADecimal
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"rgba(0,100%,0,0.5)" error:NULL];
    XCTAssertEqual([theDictionary[@"red"] floatValue], 0.0);
    XCTAssertEqual([theDictionary[@"green"] floatValue], 1.0);
    XCTAssertEqual([theDictionary[@"blue"] floatValue], 0.0);
    XCTAssertEqual([theDictionary[@"alpha"] floatValue], 0.5);
}

- (void)testHSL
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"hsl(120,100%,100%)" error:NULL];
    XCTAssertEqualWithAccuracy([theDictionary[@"hue"] floatValue], 1.0 / 3.0, 3);
    XCTAssertEqual([theDictionary[@"saturation"] floatValue], 1.0);
    XCTAssertEqual([theDictionary[@"brightness"] floatValue], 1.0);
    XCTAssertNil(theDictionary[@"alpha"]);
}

- (void)testHSLAPercent
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"hsla(120,100%,100%,50%)" error:NULL];
    XCTAssertEqualWithAccuracy([theDictionary[@"hue"] floatValue], 1.0 / 3.0, 3);
    XCTAssertEqual([theDictionary[@"saturation"] floatValue], 1.0);
    XCTAssertEqual([theDictionary[@"brightness"] floatValue], 1.0);
    XCTAssertEqual([theDictionary[@"alpha"] floatValue], 0.5);
}

- (void)testHSLADecimal
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"hsla(120,100%,100%,0.5)" error:NULL];
    XCTAssertEqualWithAccuracy([theDictionary[@"hue"] floatValue], 1.0 / 3.0, 3);
    XCTAssertEqual([theDictionary[@"saturation"] floatValue], 1.0);
    XCTAssertEqual([theDictionary[@"brightness"] floatValue], 1.0);
    XCTAssertEqual([theDictionary[@"alpha"] floatValue], 0.5);
}

- (void)testInvalidExtraAlphaWithRGB
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"rgb(0,255,0,100%)" error:NULL];
    XCTAssertNil(theDictionary);
}

- (void)testInvalidEmptyString
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"" error:NULL];
    XCTAssertNil(theDictionary);
}

- (void)testInvalidNotEnoughHex
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"FF" error:NULL];
    XCTAssertNil(theDictionary);
}

- (void)testInvalidTooMuchHex
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"FFFFFFF" error:NULL];
    XCTAssertNil(theDictionary);
}

- (void)testInvalidUnterminatedRGB
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"rgba(0,255,0,100%" error:NULL];
    XCTAssertNil(theDictionary);
}

- (void)testInvalidExtraFieldsWithRGBA
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"rgba(0,255,0,100%,100%)" error:NULL];
    XCTAssertNil(theDictionary);
}

- (void)testInvalidExtraAlphaWithHSL
{
    NSDictionary *theDictionary = [[CColorConverter sharedInstance] colorDictionaryWithString:@"hsl(120,100%,100%,0.5)" error:NULL];
    XCTAssertNil(theDictionary);
}

@end
