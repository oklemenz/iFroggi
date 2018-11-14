//
//  WaterView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 07.01.10.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "WaterView.h"
#import "WaterLayerView.h"
#import "UserData.h"
#import "ImageCache.h"
#import "GameHelper.h"

@implementation WaterView

@synthesize index, shouldStop, stopped, waterTime, timestamp, waterLayerView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		waterLayerView = [[WaterLayerView alloc] initWithFrame:frame andIndex:0];
		[self addSubview:waterLayerView];
		[self start];
    }
    return self;
}

- (void)resetWithFrame:(CGRect)frame {
	self.frame = frame;
	[waterLayerView resetWithFrame:frame];
}

- (void)update:(double)ts {
	if (timestamp > 0 && ts - timestamp >= waterTime) {
		timestamp = ts;
		[self animateWater];
	}
}

- (void)animateWater {
	if ([self isNotStopped]) {
		index++;
		if (index >= 10) {
			index = 0;
		}
		waterLayerView.index = index;
		[waterLayerView setNeedsDisplay];
		timestamp = [[NSDate date] timeIntervalSince1970];
		waterTime = [GameHelper getFloatRandomWithMin:WATER_MIN_TIME andMax:WATER_MAX_TIME];
	}
}

- (void)start {
	shouldStop = NO;
	stopped = NO;
	timestamp = [[NSDate date] timeIntervalSince1970];
	waterTime = [GameHelper getRandomWithMin:WATER_MIN_TIME andMax:WATER_MAX_TIME];
}

- (void)stop {
	shouldStop = YES;
	timestamp = 0;
}

- (void)resume {
	[self start];
	[self animateWater];
}

- (BOOL)isNotStopped {
	if (shouldStop) {
		stopped = YES;
		return NO;
	}
	return YES;
}

- (void)dealloc {
    [super dealloc];
}

@end
