//
//  BLProfileTest.m
//  biu
//
//  Created by Tony Wu on 6/8/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Profile.h"

@interface BLProfileTest : XCTestCase

@end

@implementation BLProfileTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testGetZodiacFromBirthday {
    NSString *stringDate = @"1987-05-22";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    NSDate *birthday = [formatter dateFromString:stringDate];
    NSLog(@"birthday: %@", birthday);
    
    BLZodiac expectedZodiac = BLZodiacGemini;
    BLZodiac zodiac = [Profile getZodiacFromBirthday:birthday];
    
    XCTAssertEqual(zodiac, expectedZodiac, @"Zodiac which get from birthday did not match the expected zodiac");
}

- (void)testGetAgeFromBirthday {
    NSString *stringDate = @"1987-06-9";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    NSDate *birthday = [formatter dateFromString:stringDate];
    NSLog(@"birthday: %@", birthday);
    
    NSUInteger expectedAge = 27;
    NSUInteger age = [Profile getAgeFromBirthday:birthday];
    
    XCTAssertEqual(age, expectedAge, @"Age(%ld) did not match the expected age(%ld)", age, expectedAge);
}

- (void)testGetZodiac {
    NSString *expectedZodiacName = @"Gemini";
    NSString *zodiacName = [Profile getZodiacNameFromZodiac:BLZodiacGemini isShotVersion:NO];
    XCTAssertEqualObjects(zodiacName, expectedZodiacName, @"Zodiac name (%@) did not match the expected zodiac name(%@).", zodiacName, expectedZodiacName);
    
    NSString *expectedZodiacName2 = @"Sgr";
    NSString *zodiacName2 = [Profile getZodiacNameFromZodiac:BLZodiacSagittarius isShotVersion:YES];
    XCTAssertEqualObjects(zodiacName2, expectedZodiacName2, @"Zodiac name (%@) did not match the expected zodiac name(%@).", zodiacName2, expectedZodiacName2);
}

@end
