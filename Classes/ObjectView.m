//
//  ObjectView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 09.07.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "ObjectView.h"
#import "WaterView.h"
#import "LakeView.h"
#import "WaterLilyPadView.h"
#import "iFroggiAppDelegate.h"
#import "LakeViewController.h"
#import "GameHelper.h"
#import "UserData.h"
#import "ImageCache.h"

@implementation ObjectView

@synthesize objectType, kind, state, posI, posJ, objectLeft, objectTop, shouldStop, stopped, timestamp, firstClapTime, secondClapTime;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
	}
    return self;
}

- (id)initWithRow:(int)i andColumn:(int)j {
	if (self = [super initWithFrame:CGRectZero]) {
		self.posI = i;
		self.posJ = j;
		self.objectType = 0;
		self.kind = 0;
	}
    return self;
}

- (id)initWithRow:(int)i andColumn:(int)j andType:(int)aType {
	if (self = [super initWithFrame:CGRectZero]) {
		self.posI = i;
		self.posJ = j;
		[self setObjectType:aType andRandom:YES];
	}
    return self;
}

- (id)initWithRow:(int)i andColumn:(int)j andType:(int)aType andKind:(int)aKind {
	if (self = [super initWithFrame:CGRectZero]) {
		self.posI = i;
		self.posJ = j;
		self.kind = aKind;
		[self setObjectType:aType andRandom:NO];
	}
    return self;
}

- (void)changeType {
	if (objectType == TYPE_BUTTERFLY) {
		[self stop];
	}
	[self setObjectType:[self chooseType] andRandom:YES];
	if (objectType == TYPE_BUTTERFLY) {
		[self clap];
	} 
}

- (void)setObjectType:(int)aType andRandom:(BOOL)random {
	objectType = aType;
	switch (objectType) {
		case 1:
			if (random) {
				self.kind = [GameHelper getRandomWithMin:0 inclMax:3];
			}
			self.image = [[ImageCache instance] getImage:IMAGE_FLY andIndex:kind+1];
			break;
		case 2:
			if (random) {
				self.kind = [GameHelper getRandomWithMin:0 inclMax:13];
			}
			self.image = [[ImageCache instance] getImage:IMAGE_BUTTERFLY andIndex:kind+1];
			imageNormal = self.image;
			imageClap = [[ImageCache instance] getImage:IMAGE_BUTTERFLY andIndex:kind+1 andSuffix:@"x"];
			break;
		case 3:
			if (random) {
				self.kind = [GameHelper getRandomWithMin:0 inclMax:5];
			}
			self.image = [[ImageCache instance] getImage:IMAGE_CATERPILLAR andIndex:kind+1];
			break;
		case 4:
			if (random) {
				self.kind = [GameHelper getRandomWithMin:0 inclMax:3];
			}
			self.image = [[ImageCache instance] getImage:IMAGE_LADYBUG andIndex:kind+1];
			break;
		case 5:
			if (random) {
				self.kind = [GameHelper getRandomWithMin:0 inclMax:3];
			}
			self.image = [[ImageCache instance] getImage:IMAGE_WATERLILY andIndex:kind+1];
			break;
		case 6:
			if (random) {
				self.kind = 0;
			}
			self.image = [[ImageCache instance] getImage:IMAGE_COIN];
			break;
		case 7:
			if (random) {
				self.kind = [[self getLakeView] getNextDiamond];
				if (self.kind != -1) {
					self.image = [[ImageCache instance] getImage:IMAGE_DIAMOND andIndex:kind+1];
				} else {
					self.objectType = 0;
					self.frame = CGRectZero;
					return;
				}
			}
			break;
		case 8:
			if (random) {
				self.kind = [GameHelper getRandomWithMin:0 inclMax:1];
			}
			self.image = [[ImageCache instance] getImage:IMAGE_FLAG andIndex:kind+1];
			break;
	}
	self.frame = CGRectMake((WATER_WIDTH_2  - self.image.size.width) / 2  + [GameHelper getRandomWithMin:-5 andMax:5], 
							(WATER_HEIGHT_2 - self.image.size.height) / 2 + [GameHelper getRandomWithMin:-5 andMax:5], 
							self.image.size.width, self.image.size.height);
}

- (int)chooseType {
	int index = [UserData instance].levelType-1;
	float sum = 0;
	for (int i = 0; i < 7; i++)	{
		if (i != TYPE_LADYBUG-1 || [UserData instance].time > 0) {
			sum += OBJECT_OCCURENCES[index][i];
		}
	}
	float value = [GameHelper getFloatRandomWithMin:0 andMax:sum];
	int i;
	sum = 0;
	for (i = 0; i < sizeof(OBJECT_OCCURENCES[index]); i++)	{
		if (i != TYPE_LADYBUG-1 || [UserData instance].time > 0) {
			sum += OBJECT_OCCURENCES[index][i];
		}
		if (sum >= value) {
			if (i == 0) {
				return TYPE_FLY;
			} else if (i == 1) {
				return TYPE_BUTTERFLY;
			} else if (i == 2) {
				return TYPE_CATERPILLAR;
			} else if (i == 3) {
				return TYPE_LADYBUG;
			} else if (i == 4) {
				return TYPE_WATERLILY;
			} else if (i == 5) {
				return TYPE_COIN;
			} else if (i == 6) {
				return TYPE_DIAMOND;
			}
		}
	}
	return 0;
}

- (void)clap {
	if ([self isNotStopped] && objectType == TYPE_BUTTERFLY) {
		firstClapTime = [GameHelper getFloatRandomWithMin:2 andMax:5];
		state = BUTTERFLY_STATE_FIRST_CLAP;
		timestamp = [[NSDate date] timeIntervalSince1970];
	}
}

- (void)firstClap {
	if ([self isNotStopped] && objectType == TYPE_BUTTERFLY) {
		self.image = imageClap;
		state = BUTTERFLY_STATE_FIRST_CLAP_END;
		timestamp = [[NSDate date] timeIntervalSince1970];
	}
}

- (void)endFirstClap {
	if ([self isNotStopped] && objectType == TYPE_BUTTERFLY) {
		self.image = imageNormal;
		if ([GameHelper getBoolRandom]) {
			secondClapTime = [GameHelper getFloatRandomWithMin:0.25 andMax:0.5];
			state = BUTTERFLY_STATE_SECOND_CLAP;
			timestamp = [[NSDate date] timeIntervalSince1970];
		} else {
			[self clap];
		}
	}
}

- (void)secondClap {
	if ([self isNotStopped] && objectType == TYPE_BUTTERFLY) {
		self.image = imageClap;
		state = BUTTERFLY_STATE_SECOND_CLAP_END;
		timestamp = [[NSDate date] timeIntervalSince1970];
	}
}

- (void)endSecondClap {
	if ([self isNotStopped] && objectType == TYPE_BUTTERFLY) {
		self.image = imageNormal;
		state = BUTTERFLY_STATE_NO_CLAP;
		[self clap];
	}
}

- (void)update:(double)ts {
	switch (state) {
		case 1: // First Clap
			if (timestamp > 0 && ts - timestamp >= firstClapTime) {
				timestamp = 0;
				[self firstClap];
			}
			break;
		case 2: // End First Clap
			if (timestamp > 0 && ts - timestamp >= BUTTERFLY_CLAP_TIME) {
				timestamp = 0;
				[self endFirstClap];
			}
			break;
		case 3: // Second Clap
			if (timestamp > 0 && ts - timestamp >= secondClapTime) {
				timestamp = 0;
				[self secondClap];
			}
			break;
		case 4: // End Second Clap
			if (timestamp > 0 && ts - timestamp >= BUTTERFLY_CLAP_TIME) {
				timestamp = 0;
				[self endSecondClap];
			}
			break;
	}
}

- (void)start {
}

- (void)stop {
	shouldStop = YES;
	timestamp = 0;
}

- (void)resume {
	shouldStop = NO;
	stopped = NO;
	[self clap];
}

- (BOOL)isNotStopped {
	if (shouldStop) {
		stopped = YES;
		return NO;
	}
	return YES;
}

- (LakeView *)getLakeView {
	return (LakeView *)[iFroggiAppDelegate instance].lakeViewController.lakeView;
}

- (void)dealloc {
    [super dealloc];
}

@end
