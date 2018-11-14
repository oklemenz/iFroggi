//
//  WaterView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 07.01.10.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static CGFloat WATER_OFFSET_TOP   = 13; // 26;
static CGFloat WATER_OFFSET_LEFT  = 9;  // 20;
static CGFloat WATER_WIDTH        = 230;
static CGFloat WATER_HEIGHT       = 193;
static CGFloat WATER_WIDTH_2      = 115;
static CGFloat WATER_HEIGHT_2     = 96.5;
static CGFloat WATER_WIDTH_4      = 57.5;
static CGFloat WATER_HEIGHT_4     = 48.25;

static float WATER_MIN_TIME = 0.5;
static float WATER_MAX_TIME = 2.0;

@class WaterLayerView;

@interface WaterView : UIView {
	int index;
	BOOL shouldStop;
	BOOL stopped;
	float waterTime;
	double timestamp;
	WaterLayerView *waterLayerView;
}

@property int index;
@property BOOL shouldStop;
@property BOOL stopped;
@property float waterTime;
@property double timestamp;
@property(nonatomic, retain) WaterLayerView *waterLayerView;

- (void)resetWithFrame:(CGRect)frame;
- (void)update:(double)ts;
- (void)animateWater;

- (void)start;
- (void)stop;
- (void)resume;
- (BOOL)isNotStopped;

@end
