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
    XCTAssertEqualObjects([dam getUserWithUserId:@"user_1"].userName, @"UserName_1");
    XCTAssertEqualObjects([dam getUserWithUserId:@"user_2"].userName, @"UserName_2");
}

- (void)testPutLocalRoute {
    DataAccessManager * dam = [DataAccessManager getInstance];
    Route * dummyRoute = [[Route alloc] init];
    if (dummyRoute) {
        NSUInteger count = [dam.Routes count] + 1;
        dummyRoute.city = [NSString stringWithFormat:@"%@_%lu", @"City", count];
        dummyRoute.title = [NSString stringWithFormat:@"%@_%lu", @"Title", count];
        dummyRoute.keywords = [NSString stringWithFormat:@"%@_%lu", @"#keyword", count];
        NSDate * now = [NSDate date];
        dummyRoute.createdTime = now;
        dummyRoute.lastModifiedTime = now;
    }
    NSUInteger count = [dam.Routes count];
    [dam putLocalRoute:dummyRoute];
    XCTAssertEqual([dam.Routes count], count+1);
}

- (void)testGetRouteWithRouteId {
    DataAccessManager * dam = [DataAccessManager getInstance];
    Route * dummyRoute = [[Route alloc] init];
    if (dummyRoute) {
        dummyRoute.title = @"Test1";
        NSDate * now = [NSDate date];
        dummyRoute.createdTime = now;
        dummyRoute.lastModifiedTime = now;
    }
    NSString * routeId1 = [dam putLocalRoute:dummyRoute];
    dummyRoute = [[Route alloc] init];
    if (dummyRoute) {
        dummyRoute.title = @"Test2";
        NSDate * now = [NSDate date];
        dummyRoute.createdTime = now;
        dummyRoute.lastModifiedTime = now;
    }
    NSString * routeId2 = [dam putLocalRoute:dummyRoute];
    XCTAssertEqualObjects([dam getRouteWithRouteId:routeId1].title, @"Test1");
    XCTAssertEqualObjects([dam getRouteWithRouteId:routeId2].title, @"Test2");
}

- (void)testGetRoutesWithUserId {
    DataAccessManager * dam = [DataAccessManager getInstance];
    [dam addUser:@"user_1"];
    [dam addUser:@"user_2"];
    Route * dummyRoute = [[Route alloc] init];
    if (dummyRoute) {
        dummyRoute.title = @"Test1";
        dummyRoute.userIdWhoCreates = @"user_1";
    }
    [dam putLocalRoute:dummyRoute];
    dummyRoute = [[Route alloc] init];
    if (dummyRoute) {
        dummyRoute.title = @"Test2";
        dummyRoute.userIdWhoCreates = @"user_1";
    }
    [dam putLocalRoute:dummyRoute];
    dummyRoute = [[Route alloc] init];
    if (dummyRoute) {
        dummyRoute.title = @"Test3";
        dummyRoute.userIdWhoCreates = @"user_2";
    }
    [dam putLocalRoute:dummyRoute];
    XCTAssertEqual([dam getRoutesWithUserId:@"user_1"].count, 2);
    XCTAssertEqualObjects(((Route *)[dam getRoutesWithUserId:@"user_1"][0]).title, @"Test1");
    XCTAssertEqualObjects(((Route *)[dam getRoutesWithUserId:@"user_1"][1]).title, @"Test2");
}
@end
