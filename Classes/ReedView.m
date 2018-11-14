//
//  ReedView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 18.04.09.
//  Copyright 2009 KillerApp Soft. All rights reserved.
//

#import "ReedView.h"
#import "GameHelper.h"
#import "ImageCache.h"

@implementation ReedView

@synthesize type, lakePos, shouldStop, stopped, timestamp, waitTime;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (id)initWithType:(int)reedType {
	if (self = [super initWithFrame:CGRectZero]) {
		self.layer.anchorPoint = CGPointMake(0.5, 1);
		[self resetWithType:reedType];
		[self start];
	}
    return self;
}

- (void)resetWithType:(int)reedType {
	self.type = reedType;
	self.image = [[ImageCache instance] getImage:IMAGE_REED andIndex:self.type % 4 + 1];	
	self.frame = CGRectMake(REED_LEFT + (self.type / 4) * REED_MAX + REED_WIDTH[self.type % 4], REED_TOP + [GameHelper getScreenHeight] - self.image.size.height, self.image.size.width, self.image.size.height);
	lakePos = self.center;
}

- (void)update:(double)ts {
	if (timestamp > 0 && ts - timestamp >= waitTime) {
		timestamp = 0;
		[self wait];
	}
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
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:[GameHelper getFloatRandomWithMin:1.5 andMax:4]];
		[UIView setAnimationDelegate:self];
		[UIView	setAnimationDidStopSelector:@selector(swayRight)];
		self.transform = CGAffineTransformMakeRotation([GameHelper getFloatRandom]/30);
		[UIView	commitAnimations];
	}
}

- (void)swayRight {
	if ([self isNotStopped]) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:[GameHelper getFloatRandomWithMin:1.5 andMax:4]];
		[UIView setAnimationDelegate:self];
		[UIView	setAnimationDidStopSelector:@selector(swayLeft)];
		self.transform = CGAffineTransformMakeRotation(-[GameHelper getFloatRandom]/30);
		[UIView	commitAnimations];	
	}
}

- (void)start {
	shouldStop = NO;
	stopped = NO;
	waitTime = [GameHelper getFloatRandom]*3;
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

- (void)notifyAcceleration:(CMAcceleration)acceleration {
	CGPoint point = lakePos;
	point.x += REED_MOVE_MAX * acceleration.y;
	point.y -= REED_MOVE_MAX * acceleration.x;
	self.center = point;
}

- (void)dealloc {
    [super dealloc];
}

@end
