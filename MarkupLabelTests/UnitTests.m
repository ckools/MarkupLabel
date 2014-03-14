//
//  UnitTests.m
//  UnitTests
//
//  Created by Jonathan Wight on 3/13/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CMarkupTransformer.h"

@interface UnitTests : XCTestCase

@end

@implementation UnitTests

- (void)testCollapseWhitespace1
    {
    CMarkupTransformer *theTransformer = [[CMarkupTransformer alloc] init];
    NSAttributedString *theAttributedString = [theTransformer transformMarkup:@"Hello   world" baseFont:NULL error:NULL];
    NSString *theOutputString = [theAttributedString string];
    XCTAssertEqualObjects(theOutputString, @"Hello world");
    }

//- (void)testCollapseWhitespace2
//    {
//    CMarkupTransformer *theTransformer = [[CMarkupTransformer alloc] init];
//    theTransformer.whitespaceCharacterSet = NULL;
//    NSAttributedString *theAttributedString = [theTransformer transformMarkup:@"Hello   world" baseFont:NULL error:NULL];
//    NSString *theOutputString = [theAttributedString string];
//    XCTAssertEqualObjects(theOutputString, @"Hello   world");
//    }

//- (void)testCollapseWhitespace3
//    {
//    CMarkupTransformer *theTransformer = [[CMarkupTransformer alloc] init];
//    NSAttributedString *theAttributedString = [theTransformer transformMarkup:@"Hello\nworld" baseFont:NULL error:NULL];
//    NSString *theOutputString = [theAttributedString string];
//    XCTAssertEqualObjects(theOutputString, @"Hello world");
//    }

//- (void)testCollapseWhitespace4
//    {
//    CMarkupTransformer *theTransformer = [[CMarkupTransformer alloc] init];
//    theTransformer.whitespaceCharacterSet = NULL;
//    NSAttributedString *theAttributedString = [theTransformer transformMarkup:@"Hello\nworld" baseFont:NULL error:NULL];
//    NSString *theOutputString = [theAttributedString string];
//    XCTAssertEqualObjects(theOutputString, @"Hello world");
//    }

@end
