//
//  GameHelper.h
//  iFroggi
//
//  Created by Oliver Klemenz on 11.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

static CGFloat SCREEN_WIDTH    = 480;
static CGFloat SCREEN_HEIGHT   = 320;

static CGFloat SCREEN_WIDTH_2  = 240;
static CGFloat SCREEN_HEIGHT_2 = 160;

@interface GameHelper : NSObject {
}

+ (void)logInt:(int)f;
+ (void)logFloat:(float)f;
+ (void)logPoint:(CGPoint)point;
+ (void)logRetain:(NSObject *)object;
+ (void)logBool:(BOOL)boolean;
+ (void)logTimestamp;
+ (void)logTimestampWithPrefix:(NSString *)prefix;

+ (double)getTimestamp;

+ (int)getRandom:(int)max;
+ (int)getRandomIncl:(int)max;

+ (float)getFloatRandom;
+ (float)getFloatRandom:(float)max;
+ (float)getFloatRandomWithMin:(float)min andMax:(float)max;

+ (BOOL)getBoolRandom;
+ (int)getZeroOneRandom;

+ (int)getRandomWithMin:(int)min andMax:(int)max;
+ (int)getRandomWithMin:(int)min inclMax:(int)max;

+ (CGRect)getMainScreen;
+ (CGFloat)getScreenWidth;
+ (CGFloat)getScreenHeight;

@end
