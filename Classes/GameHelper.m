//
//  GameHelper.m
//  iFroggi
//
//  Created by Oliver Klemenz on 11.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "GameHelper.h"
#import "LakeView.h"
#import "WaterView.h"

#define ARC4RANDOM_MAX 0x100000000;

@implementation GameHelper

+ (void)logInt:(int)i {
	NSLog(@"%d", i);
}

+ (void)logFloat:(float)f {
	NSLog(@"%f", f);
}

+ (void)logPoint:(CGPoint)point {
	NSLog(@"(%f, %f)", point.x, point.y);
}

+ (void)logRetain:(NSObject *)object {
	NSLog(@"Retain count: %i", (int)[object retainCount]);
}

+ (void)logBool:(BOOL)boolean {
	NSLog(@"%@", boolean ? @"true" : @"false");
}

+ (void)logTimestamp {
	NSLog(@"%f", [GameHelper getTimestamp]);
}

+ (void)logTimestampWithPrefix:(NSString *)prefix {
	NSLog(@"%@ - %f", prefix, [GameHelper getTimestamp]);
}

+ (double)getTimestamp {
	return [[NSDate date] timeIntervalSince1970];
}

+ (int)getRandom:(int)max {
	return (arc4random() % max) + 1;
}

+ (int)getRandomIncl:(int)max {
	return arc4random() % (max+1);
}

+ (float)getFloatRandom {
	return (float)arc4random() / (float)ARC4RANDOM_MAX;
}

+ (float)getFloatRandom:(float)max {
	return [self getFloatRandom] * max;	
}

+ (float)getFloatRandomWithMin:(float)min andMax:(float)max {
	return min + [self getFloatRandom] * (max-min);
}

+ (BOOL)getBoolRandom {
	return [self getFloatRandomWithMin:0 andMax:1] >= 0.5;
}

+ (int)getZeroOneRandom {
	return [self getFloatRandomWithMin:0 andMax:1] >= 0.5 ? 1 : 0;
}

+ (int)getRandomWithMin:(int)min andMax:(int)max {
	if (min == max) {
		return min;
	}
	return min + arc4random() % (max-min);
}

+ (int)getRandomWithMin:(int)min inclMax:(int)max {
	if (min == max) {
		return min;
	}
	return min + arc4random() % (max+1-min);
}

+ (CGRect)getMainScreen {
	return CGRectMake(0, 0, [self getScreenWidth], [self getScreenHeight]);
}

+ (CGFloat)getScreenWidth {
	return SCREEN_WIDTH;
}

+ (CGFloat)getScreenHeight {
	return SCREEN_HEIGHT;
}

@end
