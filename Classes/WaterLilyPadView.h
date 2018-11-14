//
//  WaterLilyImageView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 11.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class ObjectView, FrogView;

static CGFloat WATERLILYPAD_TOP       = 25;
static CGFloat WATERLILYPAD_LEFT      = 18;
static CGFloat WATERLILYPAD_WIDTH     = 115;
static CGFloat WATERLILYPAD_HEIGHT    = 96.5;

static CGFloat WATERLILYPAD_SCALE_MIN = 0.2;
static CGFloat WATERLILYPAD_SCALE_MAX = 1.0;

static CGFloat WATERLILYPAD_OFFSET_TOP[4]  = {-1, -1, 0, -1};
static CGFloat WATERLILYPAD_OFFSET_LEFT[4] = { 0,  0, 0,  0};

static int WATERLILYPAD_STATE_AWAY   = 0;
static int WATERLILYPAD_STATE_GROW   = 1;
static int WATERLILYPAD_STATE_STAY   = 2;
static int WATERLILYPAD_STATE_SHRINK = 3;
static int WATERLILYPAD_STATE_WAVE   = 4;

static float WATERLILYPAD_WAVE_TIME = 0.20;

@interface WaterLilyPadView : UIImageView {
	
	int posI;
	int posJ;
	int state;
	
	float timeAway;
	float timeGrow;
	float timeStay;
	float timeShrink;
	
	BOOL shouldStop;
	BOOL stopped;
    BOOL ready;
	BOOL waveForced;
	double timestamp;
	
	ObjectView *objectView;

	int waveIndex;
	UIImage *waterWave[4];
	
	SystemSoundID waveSound;
}

@property int posI;
@property int posJ;
@property int state;
@property float timeAway;
@property float timeGrow;
@property float timeStay;
@property float timeShrink;
@property BOOL shouldStop;
@property BOOL stopped;
@property BOOL ready;
@property BOOL waveForced;
@property double timestamp;

@property(nonatomic, retain) ObjectView *objectView;

- (id)initWithRow:(int)i andColumn:(int)j;
- (void)resetWithRow:(int)i andColumn:(int)j;

- (void)setWaterLilyPad;
- (void)setTimes;
- (void)showObject;

+ (CGRect)getImageRect:(UIImage *)image atPosI:(int)i andPosJ:(int)j andIndex:(int)index;

- (void)away;
- (void)grow;
- (void)stay;
- (void)shrink;
- (void)wave;
- (void)waveAndCheckDeath:(BOOL)checkDeath;
- (void)animateWave;

- (void)update:(double)ts;
- (void)start;
- (void)stop;
- (void)resume;
- (BOOL)isNotStopped;

- (int)checkObjectCatched;

@end
