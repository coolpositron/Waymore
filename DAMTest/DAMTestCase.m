//
//  DAMTestCase.m
//  Waymore
//
//  Created by Yuxuan Wang on 5/2/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DataAccessManager.h"

@interface DAMTestCase : XCTestCase

@end

@implementation DAMTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAdduser {
    DataAccessManager * dam = [DataAccessManager getInstance];
    XCTAssertEqual([dam.Users count], 0);
    XCTAssertEqual([dam.Routes count], 0);
    XCTAssertEqual([dam.Snippets count], 0);
    [dam addUser:@"user_1"];
    XCTAssertEqual([dam.Users count], 1);
    [dam addUser:@"user_1"];
    XCTAssertEqual([dam.Users count], 1);
}

- (void)testGetUserWithUserId {
    DataAccessManager * dam = [DataAccessManager getInstance];
    [dam addUser:@"user_1"];
    [dam addUser:@"user_2"];
    NSLog("%@", [dam getUserWithUserId:@"user_1"].userName);
//    XCTAssertEqualObjects([dam getUserWithUserId:@"user_1"].userName, @"UserName_1");
//    XCTAssertEqualObjects([dam getUserWithUserId:@"user_2"].userName, @"UserName_2");
}

@end
