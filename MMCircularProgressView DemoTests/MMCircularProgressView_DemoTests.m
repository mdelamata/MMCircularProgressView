//
//  MMCircularProgressView_DemoTests.m
//  MMCircularProgressView DemoTests
//
//  Created by Manuel de la Mata Sáez on 08/01/14.
//  Copyright (c) 2014 mms. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMCircularProgressView.h"

@interface MMCircularProgressView_DemoTests : XCTestCase

@end

@implementation MMCircularProgressView_DemoTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testForTravis{
    
    MMCircularProgressView *circularProgressView = [[MMCircularProgressView alloc] init];
    
    XCTAssertTrue([circularProgressView isKindOfClass:[MMCircularProgressView class]], @"Introspection Test");
}
@end
