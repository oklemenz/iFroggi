//
//  ReedView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 18.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>

static CGFloat REED_TOP      = 40;
static CGFloat REED_LEFT     = -25;
static CGFloat REED_WIDTH[4] = { 0, 90, 240, 330 };
static CGFloat REED_MAX      = 320;

static CGFloat REED_MOVE_MAX = 20;
static CGFloat REED_SCROLL   = 10;

@interface ReedView : UIImageView {
	int type;
	CGPoint lakePos;
	
	BOOL shouldStop;
	BOOL stopped;
	
	double timestamp;
	float waitTime;
}

@property int type;
@property CGPoint lakePos;

@property BOOL shouldStop;
@property BOOL stopped;

@property double timestamp;
@property float waitTime;

- (id)initWithType:(int)reedType;
- (void)resetWithType:(int)reedType;

- (void)update:(double)ts;
- (void)wait;
- (void)swayLeft;
- (void)swayRight;

- (void)start;
- (void)stop;
- (void)resume;
- (BOOL)isNotStopped;

- (void)notifyAcceleration:(CMAcceleration)acceleration;

@end
