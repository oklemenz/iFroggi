//
//  WaterReedView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 25.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "WaterReedView.h"
#import "WaterView.h"
#import "GameHelper.h"
#import "ImageCache.h"

@implementation WaterReedView

@synthesize type, shouldStop, stopped;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
	}
    return self;
}

- (id)initWithRow:(int)i andColumn:(int)j {
	if (self = [super initWithFrame:CGRectZero]) {
		self.layer.anchorPoint = CGPointMake(0.5, 1);
		[self resetWithRow:i andColumn:j];
		[self start];
	}
    return self;
}

- (void)resetWithRow:(int)i andColumn:(int)j {
	self.type = [GameHelper getRandomWithMin:0 inclMax:1];
	self.image = [[ImageCache instance] getImage:IMAGE_WATERREED andIndex:self.type+1];
	self.frame = CGRectMake(WATERREED_LEFT[self.type] + j * WATER_WIDTH_2, WATERREED_TOP[self.type] + i * WATER_HEIGHT_2, self.image.size.width, self.image.size.height);
}

- (void)sway:(float)duration andAngle:(float)angle {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationDelegate:self];
	self.transform = CGAffineTransformMakeRotation(angle);
	[UIView	commitAnimations];
}

- (void)start {
	shouldStop = NO;
	stopped = NO;
}

- (void)stop {
	shouldStop = YES;
}

- (void)resume {
	[self start];
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
