//
//  WaterLilyImageView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 11.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "WaterLilyPadView.h"
#import "LakeView.h"
#import "WaterView.h"
#import "GrassView.h"
#import "ObjectView.h"
#import "GameHelper.h"
#import "UserData.h"
#import "ImageCache.h"

@implementation WaterLilyPadView

@synthesize posI, posJ, state, timeAway, timeGrow, timeStay, timeShrink, shouldStop, stopped, ready, waveForced, timestamp, objectView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
	}
    return self;
}

- (id)initWithRow:(int)i andColumn:(int)j {
	if (self = [super initWithFrame:CGRectZero]) {
		[self resetWithRow:i andColumn:j];
		self.state = [GameHelper getRandomIncl:3];
		NSString *soundName = [[NSString alloc] initWithFormat:@"waterlilypad_wave%i", [GameHelper getRandomWithMin:1 inclMax:2]];
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundName ofType:@"caf"]], &waveSound);
		[soundName release];
		objectView = [[ObjectView alloc] initWithRow:i andColumn:j];
		[self showObject];
	}
	return self;
}

- (void)resetWithRow:(int)i andColumn:(int)j {
	posI = i;
	posJ = j;
	self.transform = CGAffineTransformIdentity;
	int index = [GameHelper getRandom:4];
	self.image = [[ImageCache instance] getImage:IMAGE_WATERLILY_PAD andIndex:index];
	self.frame = [WaterLilyPadView getImageRect:self.image atPosI:posI andPosJ:posJ andIndex:index];
	int waveQuater =  1 + j%2 + (i%2) * 2;
	for (int k = 0; k < 4; k++) {
		waterWave[k] = [[ImageCache instance] getImage:IMAGE_WATERWAVE andType:waveQuater andIndex:k+1];
	}
	if (objectView) {
		[objectView changeType];
	}
	[self setTimes];
}

- (void)showObject {
	if ([GameHelper getFloatRandom] >= 0.5 - ([UserData instance].speedSqrt-1) * 0.2) {
		[objectView changeType];
		objectView.hidden = NO;
		[self addSubview:objectView];
	} else {
		objectView.hidden = YES;
		[objectView removeFromSuperview];
	}
}

+ (CGRect)getImageRect:(UIImage *)image atPosI:(int)i andPosJ:(int)j andIndex:(int)index {
	return CGRectMake(WATERLILYPAD_LEFT + WATERLILYPAD_OFFSET_LEFT[index-1] + j * WATER_WIDTH_2, 
					  WATERLILYPAD_TOP  + WATERLILYPAD_OFFSET_TOP [index-1] + i * WATER_HEIGHT_2, 
					  image.size.width, image.size.height);
}

- (void)setWaterLilyPad {
	self.transform = CGAffineTransformIdentity;
	int index = [GameHelper getRandom:4];
	self.image = [[ImageCache instance] getImage:IMAGE_WATERLILY_PAD andIndex:index];
	[self showObject];
	[self setTimes];
}

- (int)checkObjectCatched {
	if ((state == WATERLILYPAD_STATE_GROW || state == WATERLILYPAD_STATE_STAY || state == WATERLILYPAD_STATE_SHRINK) && !objectView.hidden) {
		objectView.hidden = YES;
		return objectView.objectType;
	} 
	return -1;
}

- (void)setTimes {
	timeAway   = [GameHelper getFloatRandomWithMin:2.0 + 3.5 / [UserData instance].speed andMax:2.0 + 2.0 * [UserData instance].speed];
	timeGrow   = [GameHelper getFloatRandomWithMin:1.5 + 2.0 / [UserData instance].speed andMax:2.5 + 2.0 / [UserData instance].speed];
	timeStay   = [GameHelper getFloatRandomWithMin:1.5 + 2.5 / [UserData instance].speed andMax:3.0 + 2.0 / [UserData instance].speed];
	timeShrink = [GameHelper getFloatRandomWithMin:1.5 + 2.0 / [UserData instance].speed andMax:3.5 + 2.0 / [UserData instance].speed];
}

- (void)away {
	if ([self isNotStopped] && !waveForced) {
		state = WATERLILYPAD_STATE_AWAY;
		self.hidden = YES;
		[self setWaterLilyPad];
		self.transform = CGAffineTransformMakeScale(WATERLILYPAD_SCALE_MIN, WATERLILYPAD_SCALE_MIN);
		[(LakeView *)[self superview] checkFrogsDeath];
		timestamp = [[NSDate date] timeIntervalSince1970];
        self.ready = YES;
	}
}

- (void)grow {
	if ([self isNotStopped] && !waveForced) {
		state = WATERLILYPAD_STATE_GROW;
		self.hidden = NO;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:timeGrow];
		[UIView setAnimationDelegate:self];
		[UIView	setAnimationDidStopSelector:@selector(growEnd)];
		self.transform = CGAffineTransformIdentity;
		[UIView	commitAnimations];
		timestamp = 0;
		[(LakeView *)[self superview] checkFrogsWaterLilyPad:self];
        self.ready = NO;
	}
}

- (void)growEnd {
    self.ready = YES;
    [self stay];
}

- (void)stay {
	if ([self isNotStopped] && !waveForced) {
		state = WATERLILYPAD_STATE_STAY;
		self.transform = CGAffineTransformIdentity;
		timestamp = [[NSDate date] timeIntervalSince1970];
        self.ready = YES;
	}
}

- (void)shrink {
	if ([self isNotStopped] && !waveForced) {
		state = WATERLILYPAD_STATE_SHRINK;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:timeShrink];
		[UIView setAnimationDelegate:self];
		[UIView	setAnimationDidStopSelector:@selector(shrinkEnd)];
		self.transform = CGAffineTransformMakeScale(WATERLILYPAD_SCALE_MIN, WATERLILYPAD_SCALE_MIN);
		[UIView	commitAnimations];
		timestamp = 0;
        self.ready = NO;
	}
}

- (void)shrinkEnd {
    self.ready = YES;
    [self wave];
}

- (void)wave {
	if ([self isNotStopped] && !waveForced) {
		[self waveAndCheckDeath:YES];
	}
}

- (void)waveAndCheckDeath:(BOOL)checkDeath {
	if ([self isNotStopped] && !waveForced) {
		state = WATERLILYPAD_STATE_WAVE;
		objectView.hidden = YES;
		if (objectView.objectType == TYPE_DIAMOND) {
			objectView.objectType = 0;
			[(LakeView *)[self superview] resetDiamond:objectView.kind];
		}
		waveIndex = 0;
		if ([(LakeView *)[self superview] isWaterLilyPadInView:self] && [UserData instance].sound && !shouldStop) {
			AudioServicesPlaySystemSound(waveSound);
		}
		if (checkDeath) {
			[(LakeView *)[self superview] checkFrogsDeath];
		}
		self.transform = CGAffineTransformMakeScale(0.01, 0.01);
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0];
		self.transform = CGAffineTransformIdentity;
		[UIView	commitAnimations];	
		[self animateWave];
	}
}

- (void)animateWave {
	if ([self isNotStopped]) {
		if (waveIndex == 0) {
			[[self superview] insertSubview:self belowSubview:[(LakeView *)[self superview] grassView]];
		} 
		if (waveIndex < 4) {
			self.image = waterWave[waveIndex];
			waveIndex++;
			timestamp = [[NSDate date] timeIntervalSince1970];
		} else {
			self.hidden = YES;
			[[self superview] insertSubview:self aboveSubview:[(LakeView *)[self superview] grassView]];
			waveForced = NO;
			[self away];
		}
	}
}

- (void)update:(double)ts {
	if ([self isNotStopped]) {
		switch (state) {
			case 0: // Away
				if (timestamp > 0 && ts - timestamp >= timeAway) {
					timestamp = 0;
                    self.ready = YES;
					[self grow];
				}
				break;
			case 2: // Stay
				if (timestamp > 0 && ts - timestamp >= timeStay) {
					timestamp = 0;
                    self.ready = YES;
					[self shrink];
				}
				break;
			case 4: // Wave
				if (timestamp > 0 && ts - timestamp >= WATERLILYPAD_WAVE_TIME) {
					timestamp = 0;
                    self.ready = YES;
					[self animateWave];
				}
				break;
		}
		if ((state == WATERLILYPAD_STATE_STAY || state == WATERLILYPAD_STATE_GROW || state == WATERLILYPAD_STATE_SHRINK) &&	!objectView.hidden) {
			[objectView update:ts];
		}
	}
}

- (void)start {
	shouldStop = NO;
	stopped = NO;
    ready = YES;
	[objectView resume];
	float scale;
	switch (self.state) {
		case 0:
			self.transform = CGAffineTransformIdentity;
			[self away];
			break;
		case 1:
			scale = [GameHelper getFloatRandomWithMin:WATERLILYPAD_SCALE_MIN andMax:WATERLILYPAD_SCALE_MAX];
			self.transform = CGAffineTransformMakeScale(scale, scale);
			[self grow];
			break;
		case 2:
			self.transform = CGAffineTransformIdentity;
			[self stay];
			break;
		case 3:
			scale = [GameHelper getFloatRandomWithMin:WATERLILYPAD_SCALE_MIN andMax:WATERLILYPAD_SCALE_MAX];
			self.transform = CGAffineTransformMakeScale(scale, scale);
			[self shrink];
			break;
	}
}

- (void)stop {
	[objectView stop];
	shouldStop = YES;
	objectView.shouldStop = YES;
	timestamp = 0;
	if (state == WATERLILYPAD_STATE_AWAY || state == WATERLILYPAD_STATE_STAY || state == WATERLILYPAD_STATE_WAVE) {
		stopped = YES;
	}
}

- (void)resume {
	[objectView resume];
	shouldStop = NO;
	if (stopped) {
		stopped = NO;
        if (ready) {
            if (self.state < 4) {
                self.state++;
            } else {
                self.state = 0;
            }
            switch (self.state) {
                case 0:
                    [self away];
                    break;
                case 1:
                    [self grow];
                    break;
                case 2:
                    [self stay];
                    break;
                case 3:
                    [self shrink];
                    break;
                case 4:
                    [self wave];
                    break;
            }
        }
	} else {
		timestamp = [[NSDate date] timeIntervalSince1970];	
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
	AudioServicesDisposeSystemSoundID(waveSound);
	[objectView release];
    [super dealloc];
}

@end
