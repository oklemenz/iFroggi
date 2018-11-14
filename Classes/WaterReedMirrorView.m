//
//  WaterReedMirrorView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 25.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "WaterReedMirrorView.h"
#import "WaterReedView.h"
#import "WaterView.h"
#import "GameHelper.h"
#import "ImageCache.h"

@implementation WaterReedMirrorView

@synthesize type, shouldStop, timestamp, waitTime, stopped, waterReedView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
	}
    return self;
}

- (id)initWithRow:(int)i andColumn:(int)j andWaterReed:(WaterReedView *)waterReed {
	if (self = [super initWithFrame:CGRectZero]) {
		self.layer.anchorPoint = CGPointMake(0.5, 0);
		self.waterReedView = waterReed;
		[waterReed release];
		[self resetWithRow:i andColumn:j];
		[self start];
	}
    return self;
}

- (void)resetWithRow:(int)i andColumn:(int)j {
	self.type = waterReedView.type;
	self.image = [[ImageCache instance] getImage:IMAGE_WATERREED andIndex:self.type+1 andSuffix:@"_m"];
	self.frame = CGRectMake(waterReedView.frame.origin.x, waterReedView.frame.origin.y + waterReedView.frame.size.height-2, self.image.size.width, self.image.size.height);
}

- (void)wait {
	if (type % 2 == 0) {
		[self swayLeft];
	} else {
		[self swayRight];
	}
}

- (void)swayLeft {
	if ([self isNotStopped]) {
		float duration = [GameHelper getFloatRandomWithMin:1.5 andMax:4];
		float angle = [GameHelper getFloatRandom]/20;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:duration];
		[UIView setAnimationDelegate:self];
		[UIView	setAnimationDidStopSelector:@selector(swayRight)];
		self.transform = CGAffineTransformMakeRotation(angle);
		[UIView	commitAnimations];
		[waterReedView sway:duration andAngle:-angle];
	}
}

- (void)swayRight {
	if ([self isNotStopped]) {
		float duration = [GameHelper getFloatRandomWithMin:1.5 andMax:4];
		float angle = -[GameHelper getFloatRandom]/20;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:duration];
		[UIView setAnimationDelegate:self];
		[UIView	setAnimationDidStopSelector:@selector(swayLeft)];
		self.transform = CGAffineTransformMakeRotation(angle);
		[UIView	commitAnimations];
		[waterReedView sway:duration andAngle:-angle];
	}
}

- (void)update:(double)ts {
	if (timestamp > 0 && ts - timestamp >= waitTime) {
		timestamp = 0;
		[self wait];
	}
}

- (void)start {
	shouldStop = NO;
	stopped = NO;
	waitTime = [GameHelper getFloatRandom]*2;
	timestamp = [[NSDate date] timeIntervalSince1970];
}

- (void)stop {
	shouldStop = YES;
	timestamp = 0;
}

- (void)resume {
	shouldStop = NO;
	if (stopped) {
		[self start];
	}
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
