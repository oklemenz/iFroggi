//
//  Lake.m
//  iFroggi
//
//  Created by Oliver Klemenz on 11.04.09. 
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "LakeView.h"
#import "iFroggiAppDelegate.h"
#import "ReedView.h"
#import "WaterView.h"
#import "GrassView.h"

#import "WaterReedView.h"
#import "WaterReedMirrorView.h"
#import "WaterLilyPadView.h"
#import "ObjectView.h"

#import "StoneView.h"
#import "FrogView.h"
#import "GameBarView.h"
#import "LevelView.h"
#import "PauseView.h"

#import "GameHelper.h"
#import "UserData.h"
#import "MusicHandler.h"
#import "NumberView.h"
#import "ImageCache.h"

@implementation LakeView

@synthesize waterView,  grassView, stoneView, opponentStoneView, frogView, opponentFrogView, gameBarView, pauseView,
    pauseButtonView, dragStartPoint, dragStarted, pausePressed;
@synthesize status, waterLilyPadCount, scrollX, scrollY, gameView, levelView, levelNumberView, goView, deadView, gameOverView, outOfTimeView, levelDoneView, youWonView, youLostView, gameBarMoveView;
@synthesize timer, secondTimestamp, bonusTimestamp, hideTimestamp, firstAcceleration;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.1;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        CMAcceleration acceleration = motion.gravity;
        if (status != STATUS_INIT) {
            if (firstAcceleration) {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:1.0];
            }
            [grassView notifyAcceleration:acceleration];
            for (ReedView *reedView in reedViews) {
                [reedView notifyAcceleration:acceleration];
            }
            if (firstAcceleration) {
                [UIView commitAnimations];
            }
            firstAcceleration = NO;
        }
    }];
    
	waterReedViews = [[NSMutableArray alloc] init];
	waterReedMirrorViews = [[NSMutableArray alloc] init];
	waterLilyPadViews = [[NSMutableArray alloc] init];
	waterLilyPadViewsToRelease = [[NSMutableArray alloc] init];
	reedViews = [[NSMutableArray alloc] init];
	frogView = [[FrogView alloc] initWithRow:0 andColumn:0 andType:FROG_TYPE_PLAYER];
	opponentFrogView = [[FrogView alloc] initWithRow:[UserData instance].rows-1 andColumn:[UserData instance].columns-1 andType:FROG_TYPE_OPPONENT];
	gameBarMoveView = [[UIImageView alloc] init];
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"go" ofType:@"caf"]], &goSound);
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"level_success" ofType:@"caf"]], &successSound);
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"level_failed" ofType:@"caf"]], &failedSound);
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"new_life" ofType:@"caf"]], &newLifeSound);
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"button1" ofType:@"caf"]], &buttonSound);
}

- (void)prepare {
	// Lake
	self.transform = CGAffineTransformIdentity;
	self.frame = CGRectMake(0, 0, WATER_WIDTH_2 * [UserData instance].columns, WATER_HEIGHT_2 * [UserData instance].rows);
	CGRect lakeRect = CGRectMake(WATER_OFFSET_LEFT-WATER_WIDTH_2, WATER_OFFSET_TOP-WATER_HEIGHT_2, WATER_WIDTH_2 * ([UserData instance].columns + 2) + WATER_OFFSET_LEFT, WATER_HEIGHT_2 * ([UserData instance].rows + 2) + WATER_OFFSET_TOP);
	// Water
	if (waterView) {
		[waterView resetWithFrame:lakeRect];
		[waterView resume];
	} else {
		waterView = [[WaterView alloc] initWithFrame:lakeRect];
	}	
	[self addSubview:waterView];
	// Grass
	if (grassView) {
		[grassView resetWithFrame:lakeRect];
	} else {
		grassView = [[GrassView alloc] initWithFrame:lakeRect];
	}
	[self addSubview:grassView];
	// Frogs
	[frogView reset];
	[opponentFrogView reset];
	// Water Reed (incl. mirror)
	int index = 0;
	for (int i = 0; i < [UserData instance].rows - 1; i++) {
		for (int j = 0; j < [UserData instance].columns - 1; j++) {
			if ([GameHelper getFloatRandomWithMin:0 andMax:1] >= 0.5) {
				WaterReedView *waterReedView;
				WaterReedMirrorView *waterReedMirrorView;
				if (index < [waterReedViews count]) {
					waterReedView = [waterReedViews objectAtIndex:index];
					waterReedMirrorView = [waterReedMirrorViews objectAtIndex:index];
					[waterReedView resetWithRow:i andColumn:j];
					[waterReedMirrorView resetWithRow:i andColumn:j];
					[waterReedView resume];
					[waterReedMirrorView resume];
					[self addSubview:waterReedMirrorView];
				} else {
					waterReedView = [[WaterReedView alloc] initWithRow:i andColumn:j];
					[waterReedViews addObject:waterReedView];
					waterReedMirrorView = [[WaterReedMirrorView alloc] initWithRow:i andColumn:j andWaterReed:waterReedView];
					[waterReedMirrorViews addObject:waterReedMirrorView];
					[self addSubview:waterReedMirrorView];
					[waterReedView release];
					[waterReedMirrorView release];
				}
				index++;
			}
		}
	}
	int waterReedCount = index;
	if ([waterReedViews count] > index) {
		for (int i = (int)[waterReedViews count]-1; i >= index; i--) {
			WaterReedView *waterReedView = [waterReedViews objectAtIndex:i];
			WaterReedMirrorView *waterReedMirrorView = [waterReedMirrorViews objectAtIndex:i];
			[waterReedView removeFromSuperview];
			[waterReedMirrorView removeFromSuperview];
			if (waterReedView.stopped && waterReedMirrorView.stopped) {
				[waterReedViews removeObjectAtIndex:i];
				[waterReedMirrorViews removeObjectAtIndex:i];
			}			
		}
	}
	// Stones
	if (stoneView) {
		[stoneView removeFromSuperview];
	}
	if (opponentStoneView) {
		[opponentStoneView removeFromSuperview];
	}
	// Diamonds
	for (int i = 0; i < DIAMOND_COUNT; i++) {
		diamondStatus[i] = DIAMOND_STATUS_DEFAULT;
	}
	// Waterlily pad
	for (WaterLilyPadView *waterLilyPadView in waterLilyPadViews) {
		[waterLilyPadView removeFromSuperview];
		[waterLilyPadViewsToRelease addObject:waterLilyPadView];
	}
	[waterLilyPadViews removeAllObjects];
	index = 0;
	for (int i = 0; i < [UserData instance].rows; i++) {
		for (int j = 0; j < [UserData instance].columns; j++) {
			if (i == 0 && j == 0) {
				// Stone
				if (!stoneView) {
					stoneView = [[StoneView alloc] initWithRow:i andColumn:j];
				} else {
					[stoneView resetWithRow:i andColumn:j];
				}
				stoneView.flagView.hidden = [UserData instance].levelType != LEVEL_TYPE_FLAG;
				[self addSubview:stoneView];
			} else if (i == [UserData instance].rows-1 && j == [UserData instance].columns-1 && 
					  ([UserData instance].levelType == LEVEL_TYPE_OPPONENT || [UserData instance].levelType == LEVEL_TYPE_FLAG)) {
				// Opponent stone
				if (!opponentStoneView) {
					opponentStoneView = [[StoneView alloc] initWithRow:i andColumn:j];
				} else {
					[opponentStoneView resetWithRow:i andColumn:j];
				}
				opponentStoneView.flagView.hidden = [UserData instance].levelType != LEVEL_TYPE_FLAG;
				[self addSubview:opponentStoneView];
			} else {
				// Waterlily pad
				WaterLilyPadView *waterLilyPadView = [[WaterLilyPadView alloc] initWithRow:i andColumn:j];
				[waterLilyPadViews addObject:waterLilyPadView];
				[self addSubview:waterLilyPadView];
				[waterLilyPadView release];
				index++;
			}
		}
	}
	waterLilyPadCount = index;
	for (int i = (int)[waterLilyPadViewsToRelease count]-1; i >= 0; i--) {
		WaterLilyPadView *waterLilyPadView = [waterLilyPadViewsToRelease objectAtIndex:i];
		if (waterLilyPadView.stopped) {
			[waterLilyPadViewsToRelease removeObjectAtIndex:i];
		}
	}
	// Frog
	[self addSubview:frogView];
	// Water reed (layering)
	for (int i = 0; i < waterReedCount; i++) {
		[self addSubview:[waterReedViews objectAtIndex:i]];
	}
	// OpponentFrog
	if ([UserData instance].levelType == LEVEL_TYPE_OPPONENT || [UserData instance].levelType == LEVEL_TYPE_FLAG) {
		[self addSubview:opponentFrogView];
	} else {
		[opponentFrogView removeFromSuperview];
	}
	// Reed
	index = 0;
	for (int i = 0; i < [UserData instance].columns; i++) {
		ReedView *reedView;
		if (index < [reedViews count]) {
			reedView = [reedViews objectAtIndex:i];
			[reedView resetWithType:i];
			[reedView resume];
			[gameView insertSubview:reedView aboveSubview:self];
		} else {
			reedView = [[ReedView alloc] initWithType:i];
			[reedViews addObject:reedView];
			[gameView insertSubview:reedView aboveSubview:self];
			[reedView release];
		}
		index++;
	}
	if ([reedViews count] > index) {
		for (int i = (int)[reedViews count]-1; i >= index; i--) {
			ReedView *reedView = [reedViews objectAtIndex:i];
			[reedView removeFromSuperview];
			if (reedView.stopped) {
				[reedViews removeObjectAtIndex:i];
			}			
		}
	}
	// Game bar
	gameBarView.diamondNumberView.hidden = [UserData instance].levelType != LEVEL_TYPE_DIAMOND && [UserData instance].levelType != LEVEL_TYPE_OPPONENT;
	gameBarView.butterflyNumberView.hidden = [UserData instance].levelType == LEVEL_TYPE_DIAMOND || [UserData instance].levelType == LEVEL_TYPE_OPPONENT || [UserData instance].levelType == LEVEL_TYPE_FLAG;
	gameBarView.frogFlagView.hidden = [UserData instance].levelType != LEVEL_TYPE_FLAG;
	gameBarView.frogFlagView.alpha = 0.0;
	gameBarView.opponentFrogFlagView.hidden = [UserData instance].levelType != LEVEL_TYPE_FLAG;
	gameBarView.opponentFrogFlagView.alpha = 0.0;
	[gameBarView update];
	// PauseView
	pauseView.alpha = 0.0;
	pauseView.blackView.alpha = 0.0;
	pauseButtonView.alpha = 0.0;
	status = STATUS_INIT;
}

- (void)startGame {
	for (WaterLilyPadView *waterLilyPadView in waterLilyPadViews) {
		[waterLilyPadView start];
	}
	[[MusicHandler instance] resetSeek];
	[[MusicHandler instance] playGameMusic];
	[[MusicHandler instance] playGameAmbience];
	[UserData instance].previousScore = [UserData instance].score;
	[self showLevelText];
	[self startTimer];
	[UserData instance].gameStarted = YES;
	firstAcceleration = YES;
}

- (void)showLevelText {
	levelView.hidden = NO;
	levelView.alpha = 0.0;
	levelView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(showLevelNumber)];
	levelView.alpha = 1.0;
	levelView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

- (void)showLevelNumber {
	levelNumberView.hidden = NO;
	levelNumberView.alpha = 0.0;
	levelNumberView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	levelNumberView.type = TYPE_LARGE;
	levelNumberView.alignX = ALIGN_X_CENTER;
	[levelNumberView setNumber:[UserData instance].level];
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(showGo)];
	levelView.alpha = 0.0;
	levelView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	levelNumberView.alpha = 1.0;
	levelNumberView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

- (void)showGo {
	levelView.hidden = YES;
	goView.hidden = NO;
	goView.alpha = 0.0;
	goView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideGo)];
	levelNumberView.alpha = 0.0;
	levelNumberView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	goView.alpha = 1.0;
	goView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

- (void)hideGo {
	if ([UserData instance].sound) {
		AudioServicesPlaySystemSound(goSound);
	}
	levelNumberView.hidden = YES;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	goView.alpha = 0.0;
	goView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	[UIView commitAnimations];
	[self play];
}

- (void)showDead {
	status = STATUS_DEAD;
	deadView.hidden = NO;
	deadView.alpha = 0.0;
	deadView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationDelegate:self];
	deadView.alpha = 1.0;
	deadView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
	hideTimestamp = [[NSDate date] timeIntervalSince1970];
}

- (void)hideDead {
	hideTimestamp = 0;
	[self continueGame];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	deadView.alpha = 0.0;
	deadView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	[UIView commitAnimations];
}

- (void)showGameOver {
	status = STATUS_GAME_OVER;
	gameOverView.hidden = NO;
	gameOverView.alpha = 0.0;
	gameOverView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationDelegate:self];
	gameOverView.alpha = 1.0;
	gameOverView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
	if ([UserData instance].sound) {
		AudioServicesPlaySystemSound(failedSound);
	}
}

- (void)hideGameOver {
	status = STATUS_INIT;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	gameOverView.alpha = 0.0;
	gameOverView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	[UIView commitAnimations];
	[self end];
}

- (void)showLevelDone {
	status = STATUS_LEVEL_DONE;
	levelDoneView.hidden = NO;
	levelDoneView.alpha = 0.0;
	levelDoneView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationDelegate:self];
	levelDoneView.alpha = 1.0;
	levelDoneView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
	if ([UserData instance].sound) {
		AudioServicesPlaySystemSound(successSound);
	}
	[self countBonus];
}

- (void)hideLevelDone {
	status = STATUS_INIT;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	levelDoneView.alpha = 0.0;
	levelDoneView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	[UIView commitAnimations];
	[self nextLevel];
}

- (void)showOutOfTime{
	if (!frogView.stealth) {
		status = STATUS_OUT_OF_TIME;
		outOfTimeView.hidden = NO;
		outOfTimeView.alpha = 0.0;
		outOfTimeView.transform = CGAffineTransformMakeScale(0.01, 0.01);
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.5];
		[UIView setAnimationDelegate:self];
		outOfTimeView.alpha = 1.0;
		outOfTimeView.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
		[self die];
		hideTimestamp = [[NSDate date] timeIntervalSince1970];
	} else {
		[[UserData instance] resetTime];
		[gameBarView update];
		secondTimestamp = [[NSDate date] timeIntervalSince1970] + 1;
	}
}

- (void)hideOutOfTime{
	hideTimestamp = 0;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	outOfTimeView.alpha = 0.0;
	outOfTimeView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	[UIView commitAnimations];
	if ([UserData instance].lives < 0) {
		[self showGameOver];
	} else {
		[self continueGame];
		[[UserData instance] resetTime];
		[gameBarView update];
	}
}

- (void)showYouLost {
	if ([UserData instance].levelType == LEVEL_TYPE_FLAG) {
		status = STATUS_YOU_LOST;
		youLostView.hidden = NO;
		youLostView.alpha = 0.0;
		youLostView.transform = CGAffineTransformMakeScale(0.01, 0.01);
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.5];
		[UIView setAnimationDelegate:self];
		youLostView.alpha = 1.0;
		youLostView.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
		if ([UserData instance].sound) {
			AudioServicesPlaySystemSound(failedSound);
		}
	}
}

- (void)hideYouLost {
	if ([UserData instance].levelType == LEVEL_TYPE_FLAG) {
		status = STATUS_INIT;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.0];
		youLostView.alpha = 0.0;
		youLostView.transform = CGAffineTransformMakeScale(0.01, 0.01);
		[UIView commitAnimations];
		if ([UserData instance].lives < 0) {
			[self showGameOver];
		} else {
			[self continueGame];
			[[UserData instance] resetTime];
			[gameBarView update];
		}
	}
}

- (void)showYouWon {
	if ([UserData instance].levelType == LEVEL_TYPE_FLAG) {
		status = STATUS_YOU_WON;
		youWonView.hidden = NO;
		youWonView.alpha = 0.0;
		youWonView.transform = CGAffineTransformMakeScale(0.01, 0.01);
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.5];
		[UIView setAnimationDelegate:self];
		youWonView.alpha = 1.0;
		youWonView.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
		if ([UserData instance].sound) {
			AudioServicesPlaySystemSound(successSound);
		}
		[self countBonus];
	}
}

- (void)hideYouWon {
	if ([UserData instance].levelType == LEVEL_TYPE_FLAG) {
		status = STATUS_INIT;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.0];
		youWonView.alpha = 0.0;
		youWonView.transform = CGAffineTransformMakeScale(0.01, 0.01);
		[UIView commitAnimations];
		[self nextLevel];
	}
}

- (void)continueGame {
	status = STATUS_PLAY;
	if ([UserData instance].levelType == LEVEL_TYPE_OPPONENT || [UserData instance].levelType == LEVEL_TYPE_FLAG) {
		[opponentFrogView resume];
	}
}

- (void)play {
	status = STATUS_PLAY;
	secondTimestamp = [[NSDate date] timeIntervalSince1970] + 1;
	[self checkForPauseButton];
	if ([UserData instance].levelType == LEVEL_TYPE_OPPONENT || [UserData instance].levelType == LEVEL_TYPE_FLAG) {
		if (!opponentFrogView.stopped) {
			[opponentFrogView start];
		} else {
			[opponentFrogView resume];
		}		
	}
	
}

- (void)pause {
	if (status != STATUS_PAUSE) {
		pauseView.hidden = NO;
		pauseView.alpha = 0.0;
		pauseView.blackView.alpha = 0.0;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.0];
		pauseView.alpha = 1.0;
		pauseView.blackView.alpha = 0.7;
		[UIView commitAnimations];
		for (WaterLilyPadView *waterLilyPadView in waterLilyPadViews) {
			[waterLilyPadView stop];
		}
		if ([UserData instance].levelType == LEVEL_TYPE_OPPONENT || [UserData instance].levelType == LEVEL_TYPE_FLAG) {
			[opponentFrogView stop];
		}
		status = STATUS_PAUSE;
		[pauseView reload];
	}
}

- (void)resume {
	if (status == STATUS_PAUSE) {
		if ([UserData instance].levelType == LEVEL_TYPE_OPPONENT || [UserData instance].levelType == LEVEL_TYPE_FLAG) {
			[opponentFrogView resume];
		}
		for (WaterLilyPadView *waterLilyPadView in waterLilyPadViews) {
			[waterLilyPadView resume];
		}
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView	setAnimationDelegate:self];
		[UIView	setAnimationDidStopSelector:@selector(continued)];
		pauseView.alpha = 0.0;
		pauseView.blackView.alpha = 0.0;
		[UIView commitAnimations];
	}
}	

- (void)startTimer {
	timer = [NSTimer timerWithTimeInterval:0.005 target:self selector: @selector(runLoop) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)stopTimer {
	[timer invalidate];
}

- (void)runLoop {
	double ts = [[NSDate date] timeIntervalSince1970];
	if (secondTimestamp > 0 && ts - secondTimestamp >= SECOND) {
		[self decreaseSecond];
		secondTimestamp = ts;
	}
	if (bonusTimestamp > 0 && ts - bonusTimestamp >= BONUS_TIME) {
		[self countBonus];
	}
	if (hideTimestamp > 0 && ts - hideTimestamp >= HIDE_TIME) {
		if (status == STATUS_DEAD) {
			[self hideDead];
		} else if (status == STATUS_OUT_OF_TIME) {
			[self hideOutOfTime];
		}		
	}
	[frogView update:ts];
	if ([UserData instance].levelType == LEVEL_TYPE_OPPONENT ||	[UserData instance].levelType == LEVEL_TYPE_FLAG) {
		[opponentFrogView update:ts];
	}
	for (WaterLilyPadView *waterLilyPadView in waterLilyPadViews) {
		[waterLilyPadView update:ts];
	}
	for (WaterReedMirrorView *waterReedMirrorView in waterReedMirrorViews) {
		[waterReedMirrorView update:ts];
	}
	for (ReedView *reedView in reedViews) {
		[reedView update:ts];
	}
	[waterView update:ts];
}

- (void)nextLevel {
	[self cleanup];
    [[iFroggiAppDelegate instance] nextLevel];
}

- (void)exit {
	[self cleanup];
	[UserData instance].score = [UserData instance].previousScore;
	[UserData instance].previousScore = 0;
	[[iFroggiAppDelegate instance] showMenu];
}

- (void)end {
	[self cleanup];
	[UserData instance].gameOver = YES;
    [[iFroggiAppDelegate instance] showGameHighscore];
}

- (void)cleanup {
	[[MusicHandler instance] stopSound];
	[waterView stop];
	for (WaterReedView *waterReedView in waterReedViews) {
		[waterReedView stop];
	}
	for (WaterReedMirrorView *waterReedMirrorView in waterReedMirrorViews) {
		[waterReedMirrorView stop];
	}
	for (WaterLilyPadView *waterLilyPadView in waterLilyPadViews) {
		[waterLilyPadView stop];
	}
	for (ReedView *reedView in reedViews) {
		[reedView stop];
	}
	[frogView resetStealthMode];
	[opponentFrogView stop];
	status = STATUS_INIT;
	bonusTimestamp = 0;
	secondTimestamp = 0;
	[self stopTimer];
}

- (void)continued {
	pauseView.hidden = YES;
	status = STATUS_PLAY;
}

- (void)decreaseSecond {
	if (status == STATUS_PLAY) {
		if ([UserData instance].time > 0) {
			[UserData instance].time -= 1;
			[gameBarView update];
		} else {
			if ([UserData instance].levelType == LEVEL_TYPE_FLY ||
				[UserData instance].levelType == LEVEL_TYPE_BUTTERFLY ||
				[UserData instance].levelType == LEVEL_TYPE_CATERPILLAR || 
				[UserData instance].levelType == LEVEL_TYPE_LADYBUG ||
				[UserData instance].levelType == LEVEL_TYPE_WATERLILY ||
				[UserData instance].levelType == LEVEL_TYPE_COIN) {
			} else if ([UserData instance].levelType == LEVEL_TYPE_TIME ||
					   [UserData instance].levelType == LEVEL_TYPE_DIAMOND ||
					   [UserData instance].levelType == LEVEL_TYPE_OPPONENT ||
					   [UserData instance].levelType == LEVEL_TYPE_FLAG) {
				[frogView dead];
				[self showOutOfTime];
			}
		}
	}
}

- (void)addScore:(int)score {
	[UserData instance].score += score;
	if ([UserData instance].score < 0) {
		[UserData instance].score = 0;
	}
	if ([UserData instance].score >= [UserData instance].newLifePoints) {
		if ([UserData instance].sound) {
			AudioServicesPlaySystemSound(newLifeSound);
		}
		[UserData instance].lives += 1;
		[UserData instance].newLifePoints += NEW_LIFE_POINTS_BASE + NEW_LIFE_POINTS * [UserData instance].speed;
	}
}

- (void)countBonus {
	if ([UserData instance].time == 0) {
		bonusTimestamp = 0;
	} else {
		if ([UserData instance].time >= BONUS_COUNT_STEP) {
			[self addScore:BONUS_COUNT_STEP * BONUS_TIME_POINTS * [UserData instance].speed];
			[UserData instance].time -= BONUS_COUNT_STEP;
		} else {
			[self addScore:[UserData instance].time * BONUS_TIME_POINTS * [UserData instance].speed];
			[UserData instance].time = 0;
		}
		[gameBarView update];
		bonusTimestamp = [[NSDate date] timeIntervalSince1970];
	}
}

- (void)addRestBonus {
	bonusTimestamp = 0;
	[self addScore:[UserData instance].time * BONUS_TIME_POINTS * [UserData instance].speed];
	[UserData instance].time = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];	
	CGPoint point = [touch locationInView:self];
	if (status == STATUS_PLAY || status == STATUS_DEAD || status == STATUS_OUT_OF_TIME) {
        if (point.x >= pauseButtonView.frame.origin.x &&
            point.y >= pauseButtonView.frame.origin.y &&
            point.x <= pauseButtonView.frame.origin.x + pauseButtonView.frame.size.width &&
            point.y <= pauseButtonView.frame.origin.y + pauseButtonView.frame.size.height) {
            pauseButtonView.image = [[ImageCache instance] getImage:IMAGE_PAUSE_P];
            pausePressed = YES;
        } else {
            pauseButtonView.image = [[ImageCache instance] getImage:IMAGE_PAUSE];
            dragStartPoint = point;
            dragStarted = YES;
        }
	}
	if (status == STATUS_DEAD) {
		[self hideDead];
	} else if (status == STATUS_OUT_OF_TIME) {
		[self hideOutOfTime];
	} else if (status == STATUS_GAME_OVER) {
		[self hideGameOver];
	} else if (status == STATUS_LEVEL_DONE) {
		[self addRestBonus];
		[self hideLevelDone];
	} else if (status == STATUS_YOU_WON) {
		[self addRestBonus];
		[self hideYouWon];
	} else if (status == STATUS_YOU_LOST) {
		[self hideYouLost];
	}
	[self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
	if (status == STATUS_PLAY && dragStarted) {
        CGPoint dragEndPoint = point;
        CGFloat distance = [LakeView getDistanceFromStart:dragStartPoint toEnd:dragEndPoint];
        if (distance >= 30) {
            int direction = [LakeView getDirectionFromStart:dragStartPoint toEnd:dragEndPoint];
            [frogView rotateTo:direction andJump:YES];
            dragStarted = NO;
        }
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
	if (status == STATUS_PLAY) {
        if (pausePressed) {
            if (point.x >= pauseButtonView.frame.origin.x &&
                point.y >= pauseButtonView.frame.origin.y &&
                point.x <= pauseButtonView.frame.origin.x + pauseButtonView.frame.size.width &&
                point.y <= pauseButtonView.frame.origin.y + pauseButtonView.frame.size.height) {
                // Pause
                if (frogView.posI == 0 && frogView.posJ == 0) {
                    if ([UserData instance].sound) {
                        AudioServicesPlaySystemSound(buttonSound);
                    }
                    [self pause];
                }
            }
        }
        if (dragStarted) {
            CGPoint dragEndPoint = point;
            CGFloat distance = [LakeView getDistanceFromStart:dragStartPoint toEnd:dragEndPoint];
            if (distance >= 15) {
                int direction = [LakeView getDirectionFromStart:dragStartPoint toEnd:dragEndPoint];
                [frogView rotateTo:direction andJump:YES];
            }
        }
	}
	pauseButtonView.image = [[ImageCache instance] getImage:IMAGE_PAUSE];
	dragStarted = NO;
    pausePressed = NO;
}

+ (CGFloat)getDistanceFromStart:(CGPoint)start toEnd:(CGPoint)end {
	return sqrt(pow((end.x - start.x), 2) + pow((start.y - end.y), 2));
}

+ (int)getDirectionFromStart:(CGPoint)start toEnd:(CGPoint)end {
	CGFloat angle = 0;
	if (end.x - start.x == 0) {
		angle = end.y > start.y ? M_PI_2 : -M_PI_2;
	} else {
		angle = atan((start.y - end.y) / (end.x - start.x));
	}
	BOOL right = end.x > start.x;
	if (angle >= 3 * DEGREE && angle <= 4 * DEGREE) {
		return right ? DIRECTION_N : DIRECTION_S;
	} else if (angle >= DEGREE && angle <= 3*DEGREE) {
		return right ? DIRECTION_NO : DIRECTION_SW;
	} else if (angle >= -DEGREE && angle <= DEGREE) {
		return right ? DIRECTION_O : DIRECTION_W;
	} else if (angle >= -3 * DEGREE && angle <= -DEGREE) {
		return right ? DIRECTION_SO : DIRECTION_NW;
	} else if (angle >= -4 * DEGREE && angle <= -3 * DEGREE) {
		return right ? DIRECTION_S : DIRECTION_N;
	}
	return DIRECTION_S;
}

- (void)notifyFrogJump:(FrogView *)frog {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:FROG_JUMP_TIME];
	[UIView setAnimationDelegate:frog];
	[UIView setAnimationDidStopSelector:@selector(endJumping)];
	CGPoint point = frog.center;
	point.x = [frog getCenterXOfColumn:frog.targetPosJ andState:FROG_STATE_LAND];
	point.y = [frog getCenterYOfRow:frog.targetPosI andState:FROG_STATE_LAND];
	frog.center = point;
	// Down
	if (frog.direction == 0 || frog.direction == 1 || frog.direction == 7) {
		[self doFrogLayering:frog andTarget:point];
	} 
	if (frog.type == FROG_TYPE_PLAYER) {
		scrollX = point.x - SCREEN_WIDTH_2;
		if (scrollX + SCREEN_WIDTH >= [self getLakeWidth]) {
			scrollX = [self getLakeWidth] - SCREEN_WIDTH;
		}
		if (scrollX < 0) {
			scrollX = 0;
		}
		scrollY = point.y - SCREEN_HEIGHT_2;
		if (scrollY + SCREEN_HEIGHT >= [self getLakeHeight]) {
			scrollY = [self getLakeHeight] - SCREEN_HEIGHT;
		}
		if (scrollY < 0) {
			scrollY = 0;
		}
		self.transform = CGAffineTransformMakeTranslation(-scrollX, -scrollY);
	}
	[UIView commitAnimations];
}

- (void)doFrogLayering:(FrogView *)frog andTarget:(CGPoint)target{
	if (status == STATUS_PLAY && !frog.isDead) {
		if ([waterReedViews count] > 0) {
			WaterReedView *swapWaterReedView = nil;
			for (WaterReedView *waterReedView in waterReedViews) {
				if (frog.direction == 0 || frog.direction == 1 || frog.direction == 7) {
					// Jump Down
					if (target.y > waterReedView.center.y) {
						swapWaterReedView = waterReedView;
					}
				} else if (frog.direction == 3 || frog.direction == 4 || frog.direction == 5) {
					// Jump Up
					if (target.y < waterReedView.center.y) {
						swapWaterReedView = waterReedView;
						break;
					}
				}
			}
			if (swapWaterReedView) {
				if (frog.direction == 0 || frog.direction == 1 || frog.direction == 7) {
					[self insertSubview:frog aboveSubview:swapWaterReedView];
				} else if (frog.direction == 3 || frog.direction == 4 || frog.direction == 5) {
					[self insertSubview:frog belowSubview:swapWaterReedView];
				}
			}
		}
	}
}

- (void)resetFrogLayering:(FrogView *)frog {
	if ([waterReedViews count] > 0) {
		if (frog.type == FROG_TYPE_PLAYER) {
			WaterReedView *waterReedView = [waterReedViews objectAtIndex:0]; 
			if (waterReedView) {
				[self insertSubview:frog belowSubview:waterReedView];
			}
		} else if (frog.type == FROG_TYPE_OPPONENT) {
			WaterReedView *waterReedView = [waterReedViews objectAtIndex:[waterReedViews count]-1]; 
			if (waterReedView) {
				[self insertSubview:frog aboveSubview:waterReedView];
			}
		}
	}
}

- (BOOL)isFrogInView:(FrogView *)frog {
	if (frog.type == FROG_TYPE_PLAYER) {
		return YES;
	} else {
		return frog.center.x >= scrollX && frog.center.x <= scrollX + SCREEN_WIDTH && 
			   frog.center.y >= scrollY && frog.center.y <= scrollY + SCREEN_HEIGHT; 		
	}
}

- (BOOL)isWaterLilyPadInView:(WaterLilyPadView *)waterLilyPad {
	return waterLilyPad.center.x >= scrollX && waterLilyPad.center.x <= scrollX + SCREEN_WIDTH && 
		   waterLilyPad.center.y >= scrollY && waterLilyPad.center.y <= scrollY + SCREEN_HEIGHT; 		
}

- (void)checkForPauseButton {
	if (frogView.posI != 0 || frogView.posJ != 0) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		pauseButtonView.alpha = 0.0;
		[UIView	commitAnimations];
	} else if (frogView.posI == 0 && frogView.posJ == 0) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		pauseButtonView.alpha = 1.0;
		[UIView	commitAnimations];
	}
}

- (void)resetLakeScrolling {
	[self checkForPauseButton];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:FROG_JUMP_TIME];
	scrollX = 0;
	scrollY = 0;
	self.transform = CGAffineTransformMakeTranslation(0, 0);	
	[UIView commitAnimations];
}

- (void)checkFrogsDeath {
	if (status == STATUS_PLAY) {
		[self checkFrogDeath:frogView];
		if ([UserData instance].levelType == LEVEL_TYPE_OPPONENT ||	[UserData instance].levelType == LEVEL_TYPE_FLAG) {
			[self checkFrogDeath:opponentFrogView];		
		}
	}
}

- (void)die {
	[UserData instance].lives -= 1;
	if ([UserData instance].lives >= 0)	{
		[gameBarView update];
	}
	[self showFlag:frogView];
	[self showFlag:opponentFrogView];
	[opponentFrogView reset];
	[self checkGameOver];
}

- (void)checkGameOver {
	if (status != STATUS_YOU_LOST && status != STATUS_OUT_OF_TIME) {
		if ([UserData instance].lives < 0) {
			[self showGameOver];
		} else {
			[self showDead];
		}
	}
}

- (BOOL)checkFrogDeath:(FrogView *)frog {
	if (status == STATUS_PLAY) {
		if ([UserData instance].levelType == LEVEL_TYPE_OPPONENT || [UserData instance].levelType == LEVEL_TYPE_FLAG) {
			if (frogView.posI == opponentFrogView.posI && frogView.posJ == opponentFrogView.posJ &&	!frogView.doJump && !frogView.isDead && !opponentFrogView.doJump && !opponentFrogView.isDead) {
				int index = frog.posI * [UserData instance].columns + frog.posJ - 1;
				if (index >= 0 && index < waterLilyPadCount) {
					WaterLilyPadView *waterLilyPadView = [waterLilyPadViews objectAtIndex:index];
					[waterLilyPadView waveAndCheckDeath:NO];
					waterLilyPadView.waveForced = YES;
				}
				if (!opponentFrogView.stealth) {
					[opponentFrogView dead];
					[self showFlag:opponentFrogView];
				}
				if (!frogView.stealth) {
					[frogView dead];
					[self die];
				}
				return frog.isDead;
			}
		}
		if (!frog.stealth) {
			int index = frog.posI * [UserData instance].columns + frog.posJ - 1;
			if (index >= 0 && index < waterLilyPadCount && !frog.doJump && !frog.isDead) {
				WaterLilyPadView *waterLilyPadView = [waterLilyPadViews objectAtIndex:index];
				if (waterLilyPadView.state == WATERLILYPAD_STATE_AWAY || waterLilyPadView.state == WATERLILYPAD_STATE_WAVE) { 
					[frog dead];
					if (frog.type == FROG_TYPE_PLAYER) {
						[self die];
					} else if (frog.type == FROG_TYPE_OPPONENT) {
						[self showFlag:frog];
					}
					return YES;
				}
			}
		}
	}
	return NO;
}

- (void)checkFrogsWaterLilyPad:(WaterLilyPadView *)waterLilyPad {
	if (status == STATUS_PLAY) {
		[self checkWaterLilyPad:frogView andWaterLilyPad:waterLilyPad];
		if ([UserData instance].levelType == LEVEL_TYPE_OPPONENT ||	[UserData instance].levelType == LEVEL_TYPE_FLAG) {
			[self checkWaterLilyPad:opponentFrogView andWaterLilyPad:waterLilyPad];		
		}
	}
}

- (void)checkWaterLilyPad:(FrogView *)frog {
	[self checkWaterLilyPad:frog andWaterLilyPad:nil];
}

- (void)checkWaterLilyPad:(FrogView *)frog andWaterLilyPad:(WaterLilyPadView *)waterLilyPad {
	[self checkForPauseButton];
	int index = frog.posI * [UserData instance].columns + frog.posJ - 1;
	if (index >= 0 && index < waterLilyPadCount && !frog.doJump && !frog.isDead) {
		WaterLilyPadView *waterLilyPadView = [waterLilyPadViews objectAtIndex:index];
		if (waterLilyPad && waterLilyPad != waterLilyPadView) {
			return;
		}
		int objectType = [waterLilyPadView checkObjectCatched];
		/*if (waterLilyPad && waterLilyPad == waterLilyPadView && objectType == 2) {
			NSLog(@"Test");
		}*/
		if (objectType != -1) {
			if (frog.type == FROG_TYPE_PLAYER) {
				[frog objectCatched:objectType];
				switch (objectType) {
					case 1: // Fly
						[self addScore:(20 + [waterLilyPadView objectView].kind) * [UserData instance].speed];
						if ([UserData instance].levelType == LEVEL_TYPE_FLY) {
							[UserData instance].butterflies += 1;
							if ([UserData instance].butterflies >= [UserData instance].maxButterflies) {
								[gameBarView update];
								[self showLevelDone];
								return;
							}
						}
						break;
					case 2: // Butterfly
						[UserData instance].butterflies += 1;
						[self addScore:(100 + [waterLilyPadView objectView].kind) * [UserData instance].speed];
						if ([UserData instance].butterflies >= [UserData instance].maxButterflies && 
							[UserData instance].levelType != LEVEL_TYPE_DIAMOND && [UserData instance].levelType != LEVEL_TYPE_OPPONENT && 
							[UserData instance].levelType != LEVEL_TYPE_FLAG) {
							[gameBarView update];
							[self showLevelDone];
							return;
						}
						break;
					case 3: // Caterpillar
						if (!frogView.stealth) {
							[self addScore:(-200 + [waterLilyPadView objectView].kind) * [UserData instance].speed];
						}
						break;
					case 4: // Ladybug
						if ([UserData instance].sound) {
							AudioServicesPlaySystemSound(newLifeSound);
						}
						[self moveGameBarView:waterLilyPadView.objectView atPoint:waterLilyPadView.center toPoint:CGPointMake(gameBarView.livesNumberView.posX, gameBarView.livesNumberView.posY)];
						[UserData instance].lives += 1;
						break;
					case 5: // Waterlily
						if (waterLilyPadView.state != WATERLILYPAD_STATE_WAVE) {
							[waterLilyPadView wave];
							waterLilyPadView.waveForced = YES;
						}
						break;
					case 6: // Coin
						[frog setStealthMode];
						break;
					case 7: // Diamond
						if ([UserData instance].levelType == LEVEL_TYPE_DIAMOND ||
							[UserData instance].levelType == LEVEL_TYPE_OPPONENT) {
							if (waterLilyPadView.objectView.kind >= 0 && waterLilyPadView.objectView.kind < DIAMOND_COUNT) {
								diamondStatus[waterLilyPadView.objectView.kind] = DIAMOND_STATUS_CATCHED;
								[self moveGameBarView:waterLilyPadView.objectView atPoint:waterLilyPadView.center toPoint:CGPointMake(gameBarView.diamondNumberView.posX, gameBarView.diamondNumberView.posY)];
								waterLilyPadView.objectView.objectType = 0;
								[UserData instance].diamonds += 1;
								if ([UserData instance].diamonds >= [UserData instance].maxDiamonds) {
									[gameBarView update];
									[self showLevelDone];
									return;
								}
							}
						}
						break;
					case 8: // Flag
						break;
				}
				[gameBarView update];
			} else if (frog.type == FROG_TYPE_OPPONENT) {
				switch (objectType) {
					case 5: // Waterlily
						if (waterLilyPadView.state != WATERLILYPAD_STATE_WAVE) {
							[waterLilyPadView wave];
							waterLilyPadView.waveForced = YES;
						}
						break;
					case 6: // Coin
						[frog setStealthMode];
						break;
					case 7: // Flag
						frog.flagCatched = YES;
						break;
				}
			}
		}
	} else if ([UserData instance].levelType == LEVEL_TYPE_FLAG) {
		if (frog.type == FROG_TYPE_PLAYER) {
			if (frog.posI == 0 && frog.posJ == 0 && frog.flagCatched) {
				[self showYouWon];
			} 
			if (frog.posI == [UserData instance].rows-1 && frog.posJ == [UserData instance].columns-1) {
				if ([opponentStoneView checkObjectCatched]) {
					[frog objectCatched:TYPE_FLAG];
					[UIView beginAnimations:nil context:NULL];
					[UIView setAnimationDuration:0.5];
					gameBarView.opponentFrogFlagView.alpha = 1.0;
					[UIView commitAnimations];
				}
			}
		} else if (frog.type == FROG_TYPE_OPPONENT) {
			if (frog.posI == [UserData instance].rows-1 && frog.posJ == [UserData instance].columns-1 && frog.flagCatched) {
				[frogView dead];
				[self showYouLost];
				[self die];
			} 
			if (frog.posI == 0 && frog.posJ == 0 && frog.type == FROG_TYPE_OPPONENT) {
				if ([stoneView checkObjectCatched]) {
					[frog objectCatched:TYPE_FLAG];
					[UIView beginAnimations:nil context:NULL];
					[UIView setAnimationDuration:0.5];
					gameBarView.frogFlagView.alpha = 1.0;
					[UIView commitAnimations];
				}
			} 
		}
	}
}

- (void)showFlag:(FrogView *)frog {
	if ([UserData instance].levelType == LEVEL_TYPE_FLAG && frog.flagCatched) {
		if (frog.type == FROG_TYPE_PLAYER) {
			frogView.flagCatched = NO;
			opponentStoneView.flagView.alpha = 0.0;
			opponentStoneView.flagView.hidden = NO;
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			opponentStoneView.flagView.alpha = 1.0;
			gameBarView.opponentFrogFlagView.alpha = 0.0;
			[UIView commitAnimations];
		} else if (frog.type == FROG_TYPE_OPPONENT) {
			opponentFrogView.flagCatched = NO;
			stoneView.flagView.alpha = 0.0;
			stoneView.flagView.hidden = NO;
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			stoneView.flagView.alpha = 1.0;
			gameBarView.frogFlagView.alpha = 0.0;
			[UIView commitAnimations];
		}
	}
}

- (int)decideOpponentFrogDirection {
	if (status == STATUS_PLAY) {
		int index = opponentFrogView.posI * [UserData instance].columns + opponentFrogView.posJ - 1;
		if (!opponentFrogView.doJump && !opponentFrogView.isDead) {
			CGFloat distance = 0;
			if ([UserData instance].levelType == LEVEL_TYPE_OPPONENT) {
				distance = sqrt(pow(opponentFrogView.posI - frogView.posI, 2) + pow(opponentFrogView.posJ - frogView.posJ, 2));	
			} else if ([UserData instance].levelType == LEVEL_TYPE_FLAG) {
				if (!opponentFrogView.flagCatched) {
					distance = sqrt(pow(opponentFrogView.posI, 2) + pow(opponentFrogView.posJ, 2));
				} else {
					distance = sqrt(pow(opponentFrogView.posI - [UserData instance].rows-1, 2) + pow(opponentFrogView.posJ - [UserData instance].columns-1, 2));
				}
			}
			NSMutableArray *possibleDirections = [[NSMutableArray alloc] init];
			for (int i = 0; i < 9; i++) {
				int newIndex = index - 1 + i % 3;
				if (i < 3) {
					newIndex -= [UserData instance].columns;
				}
				if (i >= 6) {
					newIndex += [UserData instance].columns;
				}
				if (newIndex != index &&
					(opponentFrogView.posI > 0 || i / 3 > 0) && (opponentFrogView.posI < [UserData instance].rows-1    || i / 3 < 2) && 
					(opponentFrogView.posJ > 0 || i % 3 > 0) && (opponentFrogView.posJ < [UserData instance].columns-1 || i % 3 < 2)) {		
					int dir = 0;
					switch (i) {
						case 0:
							dir = DIRECTION_NW;
							break;
						case 1:
							dir = DIRECTION_N;
							break;
						case 2:
							dir = DIRECTION_NO;
							break;
						case 3:
							dir = DIRECTION_W;
							break;
						case 4:
							continue;
						case 5:
							dir = DIRECTION_O;
							break;
						case 6:
							dir = DIRECTION_SW;
							break;
						case 7:
							dir = DIRECTION_S;
							break;
						case 8:
							dir = DIRECTION_SO;
							break;
					}
					BOOL dirOk = NO;
					int targetPosI = opponentFrogView.posI + FROG_JUMP_DIR_ROW[dir];
					int targetPosJ = opponentFrogView.posJ + FROG_JUMP_DIR_COL[dir];
					if (newIndex >= 0 && newIndex < waterLilyPadCount) {
						WaterLilyPadView *waterLilyPadView = [waterLilyPadViews objectAtIndex:newIndex];
						if (opponentFrogView.stealth ||
							((waterLilyPadView.state == WATERLILYPAD_STATE_GROW || waterLilyPadView.state == WATERLILYPAD_STATE_STAY || waterLilyPadView.state == WATERLILYPAD_STATE_SHRINK) && 
							 (waterLilyPadView.objectView.objectType != TYPE_WATERLILY && 
							!(frogView.posI == targetPosI && frogView.posJ == targetPosJ && (([UserData instance].levelType == LEVEL_TYPE_FLAG && !frogView.flagCatched) || frogView.stealth)) ))) {
							dirOk = YES;
						}
					} else {
						dirOk = YES;
					}
					if (dirOk) {
						if ([UserData instance].levelType == LEVEL_TYPE_OPPONENT) {
							CGFloat newDistance = sqrt(pow((targetPosI - frogView.posI), 2) + pow((targetPosJ - frogView.posJ), 2));
							if ((!frogView.stealth && newDistance <= distance) || (frogView.stealth && newDistance >= distance)) {
								[possibleDirections addObject:[[NSNumber alloc] initWithInt:dir]];
							}
						} else if ([UserData instance].levelType == LEVEL_TYPE_FLAG) {
							CGFloat newDistance;
							if (!opponentFrogView.flagCatched) {
								newDistance = sqrt(pow(targetPosI, 2) + pow(targetPosJ, 2));
							} else {
								newDistance = sqrt(pow((targetPosI - [UserData instance].rows-1), 2) + pow((targetPosJ - [UserData instance].columns-1), 2));
							}
							if (newDistance < distance) {
								[possibleDirections addObject:[[NSNumber alloc] initWithInt:dir]];
							}
						} else {
							[possibleDirections addObject:[[NSNumber alloc] initWithInt:dir]];
						}
					}
				}
			}
			if ([possibleDirections count] > 0) {
				NSNumber *decidedDir = (NSNumber *)[possibleDirections objectAtIndex:[GameHelper getRandomWithMin:0 andMax:(int)[possibleDirections count]]];
				return [decidedDir intValue];
			}
		}
	}
	return -1;
}

- (int)getNextDiamond {
	if (status == STATUS_PLAY) {
		int diamond = [GameHelper getRandomWithMin:0 inclMax:3];
		int startDiamond = diamond;
		while (diamondStatus[diamond] != DIAMOND_STATUS_DEFAULT) {
			diamond++;
			if (diamond >= DIAMOND_COUNT) {
				diamond = 0;
			}
			if (diamond == startDiamond) {
				diamond = -1;
				break;
			}
		}
		if (diamond != -1) {
			diamondStatus[diamond] = DIAMOND_STATUS_ACTIVE;
			//NSLog([[NSString alloc] initWithFormat:@"1. %i, %i, %i, %i", diamondStatus[0], diamondStatus[1], diamondStatus[2], diamondStatus[3]]);
		}
		return diamond;
	}
	return -1;	
}

- (void)resetDiamond:(int)diamond {
	if (status == STATUS_PLAY) {
		if (diamond >= 0 && diamond < DIAMOND_COUNT && diamondStatus[diamond] == DIAMOND_STATUS_ACTIVE) {
			diamondStatus[diamond] = DIAMOND_STATUS_DEFAULT;
		}
		/*int count1 = 0;
		for (int i = 0; i < 4; i++) {
			if (diamondStatus[i] == DIAMOND_STATUS_ACTIVE) {
				count1++;
			}
		}
		int count2 = 0;
		NSLog([[NSString alloc] initWithFormat:@"2. %i, %i, %i, %i", diamondStatus[0], diamondStatus[1], diamondStatus[2], diamondStatus[3]]);
		for (WaterLilyPadView *view in waterLilyPadViews) {
			if (view.objectView.objectType == 7) {
				count2++;
			}
			NSLog([[NSString alloc] initWithFormat:@"- %i : %i", view.objectView.objectType, view.objectView.kind]);
		}
		NSLog([[NSString alloc] initWithFormat:@"%i = %i", count1, count2]);
		if (count1 != count2) {
			NSLog(@"===============> Diamond Trap");
		}*/
	}
}

- (void)moveGameBarView:(UIImageView *)view atPoint:(CGPoint)atPoint toPoint:(CGPoint )toPoint {
	gameBarMoveView.image = view.image;
	gameBarMoveView.bounds = view.bounds;
	gameBarMoveView.center = CGPointMake(atPoint.x - scrollX, atPoint.y - scrollY);
	gameBarMoveView.alpha = 1.0;
	[self.superview addSubview:gameBarMoveView];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.7];
	gameBarMoveView.bounds = CGRectMake(0, 0, 10, 10);
	gameBarMoveView.center = toPoint; 
	gameBarMoveView.alpha = 0.0;
	[UIView	commitAnimations];
}

- (CGFloat)getLakeWidth {
	return [UserData instance].columns * WATER_WIDTH_2 + 30;
}

- (CGFloat)getLakeHeight {
	return [UserData instance].rows * WATER_HEIGHT_2 + 30;	
}

- (void)dealloc {
	AudioServicesDisposeSystemSoundID(buttonSound);
    [super dealloc];
}

@end
