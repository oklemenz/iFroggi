//
//  FrogView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 18.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "FrogView.h"
#import "WaterView.h"
#import "LakeView.h" 
#import "LevelView.h"
#import "ObjectView.h" 
#import "ImageCache.h"
#import "UserData.h"

@implementation FrogView

@synthesize type, posI, posJ, targetPosI, targetPosJ, state, direction, targetDirection, rotateDir, doJump, isDead, stealth, stealthBlink, flagCatched;
@synthesize shouldStop, stopped, rotateTimestamp, stealthTimestamp, blinkTimestamp, moveTimestamp, moveSpeed;
 
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (id)initWithRow:(int)i andColumn:(int)j andType:(int)t {
	if (self = [super initWithFrame:CGRectZero]) {
		self.type = t;
		self.posI = i;
		self.posJ = j;
		NSString *imageName;
		if (self.type == FROG_TYPE_PLAYER) {
			imageName = IMAGE_FROG;
		} else {
			imageName = IMAGE_OPP_FROG;
		}
		// 5 4 3
		// 6   2
		// 7 0 1
		NSString *imageFullName;
		imageFullName = [[NSString alloc] initWithFormat:@"%@_s", imageName];
		frogSit[0]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_so", imageName];
		frogSit[1]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_o", imageName];
		frogSit[2]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_no", imageName];
		frogSit[3]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_n", imageName];
		frogSit[4]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_nw", imageName];
		frogSit[5]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_w", imageName];
		frogSit[6]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_sw", imageName];
		frogSit[7]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_x_s", imageName];
		frogJump[0]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_x_so", imageName];
		frogJump[1]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_x_o", imageName];
		frogJump[2]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_x_no", imageName];
		frogJump[3]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_x_n", imageName];
		frogJump[4]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_x_nw", imageName];
		frogJump[5]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_x_w", imageName];
		frogJump[6]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		imageFullName = [[NSString alloc] initWithFormat:@"%@_x_sw", imageName];
		frogJump[7]  = [[ImageCache instance] getImage:imageFullName];
		[imageFullName release];
		[imageName release];
		state = FROG_STATE_SIT;
		if (self.type == FROG_TYPE_PLAYER) { 
			direction = DIRECTION_S;
			rotateDir = ROTATE_DIR_CW;
		} else if (self.type == FROG_TYPE_OPPONENT) { 
			direction = DIRECTION_N;
			rotateDir = ROTATE_DIR_CCW;
		}
		self.image = frogSit[direction];
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"frog_croak" ofType:@"caf"]], &croakSound);
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"frog_jump" ofType:@"caf"]], &jumpSound);
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"frog_land" ofType:@"caf"]], &landSound);
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"frog_dive" ofType:@"caf"]], &diveSound);
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"frog_shriek1" ofType:@"caf"]], &shriekSound1);
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"frog_shriek2" ofType:@"caf"]], &shriekSound2);
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"frog_catched" ofType:@"caf"]], &catchedSound);
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"stealth_start" ofType:@"caf"]], &stealthStartSound);
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"stealth_end" ofType:@"caf"]], &stealthEndSound);
		self.frame = [self getFrameWithRow:posI andColumn:posJ andState:state];
	}
    return self;
}

- (CGFloat)getHeight:(int)aState {
	if (aState == FROG_STATE_SIT || aState == FROG_STATE_ROTATE) {
		return frogSit[direction].size.height;
	} else if (aState == FROG_STATE_JUMP || aState == FROG_STATE_LAND) {
		return frogJump[direction].size.height;
	}
	return 0;
}

- (CGFloat)getWidth:(int)aState {
	if (aState == FROG_STATE_SIT || aState == FROG_STATE_ROTATE) {
		return frogSit[direction].size.width;
	} else if (aState == FROG_STATE_JUMP || aState == FROG_STATE_LAND) {
		return frogJump[direction].size.width;
	}
	return 0;
}


- (CGFloat)getYOfRow:(int)i andState:(int)aState {
	if (aState == FROG_STATE_SIT || aState == FROG_STATE_ROTATE) {
		return FROG_TOP + i * WATER_HEIGHT_2 + FROG_SIT_OFFSET_TOP[direction];
	} else if (aState == FROG_STATE_JUMP) {
		return FROG_TOP + i * WATER_HEIGHT_2 + FROG_JUMP_OFFSET_TOP[direction];
	} else if (aState == FROG_STATE_LAND) {
		return FROG_TOP + i * WATER_HEIGHT_2 + FROG_LAND_OFFSET_TOP[direction];
	}
	return 0;
}

- (CGFloat)getXOfColumn:(int)j andState:(int)aState {
	if (aState == FROG_STATE_SIT || aState == FROG_STATE_ROTATE) {
		return FROG_LEFT + j * WATER_WIDTH_2 + FROG_SIT_OFFSET_LEFT[direction];
	} else if (aState == FROG_STATE_JUMP) {
		return FROG_LEFT + j * WATER_WIDTH_2 + FROG_JUMP_OFFSET_LEFT[direction];
	} else if (aState == FROG_STATE_LAND) {
		return FROG_LEFT + j * WATER_WIDTH_2 + FROG_LAND_OFFSET_LEFT[direction];
	}		
	return 0;
}

- (CGFloat)getCenterYOfRow:(int)i andState:(int)aState {
	return [self getYOfRow:i andState:aState] + [self getHeight:aState] / 2;
}

- (CGFloat)getCenterXOfColumn:(int)j andState:(int)aState {
	return [self getXOfColumn:j andState:aState] + [self getWidth:aState] / 2;
}

- (CGRect)getFrameWithRow:(int)i andColumn:(int)j andState:(int)aState {
	return CGRectMake([self getXOfColumn:i andState:aState], [self getYOfRow:j andState:aState], [self getWidth:aState], [self getHeight:aState]);
}

- (CGPoint)getCenterWithRow:(int)i andColumn:(int)j andState:(int)aState {
	return CGPointMake([self getCenterXOfColumn:j andState:aState], [self getCenterYOfRow:i andState:aState]);
}

- (void)update:(double)ts {
	if (state == FROG_STATE_ROTATE && rotateTimestamp > 0 && ts - rotateTimestamp >= FROG_ROTATE_TIME) {
		[self rotating];
	}
	if (stealthTimestamp > 0 && ts - stealthTimestamp >= FROG_STEALTH_TIME) {
		[self leaveStealthMode];
	}
	if (blinkTimestamp > 0 && ts - blinkTimestamp >= FROG_STEALTH_BLINK) {
		[self leaveStealthMode];
	}
	if (moveTimestamp > 0 && ts - moveTimestamp >= moveSpeed) {
		[self move];
	}
}

- (void)rotateTo:(int)toDirection andJump:(BOOL)jump {
	if (isDead || state == FROG_STATE_JUMP) {
		return;
	}
	if (jump) {
		doJump = jump;
		targetPosI = posI + FROG_JUMP_DIR_ROW[toDirection];
		targetPosJ = posJ + FROG_JUMP_DIR_COL[toDirection];
		if (targetPosI >= 0 && targetPosJ >= 0 && targetPosI < [UserData instance].rows && targetPosJ < [UserData instance].columns) {
			doJump = jump;
		} else {
			doJump = NO;
			targetPosI = posI;
			targetPosJ = posJ;
		}
	}
	if (direction == toDirection) {
		if (doJump) {
			[self beginJumping];
		}
		return;
	}
	targetDirection = toDirection;
	int cw = 0;
	int ccw = 0;
	if (direction > targetDirection) {
		cw = direction - targetDirection;
		ccw = 8 - direction + targetDirection;
	} else {
		ccw = targetDirection - direction;
		cw = 8 - targetDirection + direction;
	}
	if (cw < ccw) {
		rotateDir = ROTATE_DIR_CW;
	} else if (cw > ccw) {
		rotateDir = ROTATE_DIR_CCW;
	}
	[self beginRotating];
}

- (void)beginRotating {
	state = FROG_STATE_ROTATE;
	[self rotating];
}

- (void)beginJumping {
	state = FROG_STATE_JUMP;
	[self setState];
	if ([[self getLakeView] isFrogInView:self] && [UserData instance].sound) {
		AudioServicesPlaySystemSound(jumpSound);
	}
	[[self getLakeView] notifyFrogJump:self];
}

- (void)endJumping {
	doJump = false;
	state = FROG_STATE_SIT;
	posI = targetPosI;
	posJ = targetPosJ;
	if (![[self getLakeView] checkFrogDeath:self]) {
		if ([[self getLakeView] isFrogInView:self] && [UserData instance].sound) {
			AudioServicesPlaySystemSound(landSound);
		}
		[[self getLakeView] checkWaterLilyPad:self];
		[self setState];
		// Up
		if (direction == 3 || direction == 4 || direction == 5) {
			[[self getLakeView] doFrogLayering:self andTarget:self.center];
		} 
		if (type == FROG_TYPE_OPPONENT) {
			[self wait];
		}
	}	
}

- (void)objectCatched:(int)objectType {
	if (objectType == TYPE_FLAG) {
		flagCatched = YES;
	}
	if ([[self getLakeView] isFrogInView:self] && [UserData instance].sound) {
		switch (objectType) {
			case 1: // Frog
				AudioServicesPlaySystemSound(croakSound);
				break;
			case 2: // Butterfly
				AudioServicesPlaySystemSound(croakSound);
				break;
			case 3: // Caterpillar
				if (!stealth) {
					AudioServicesPlaySystemSound(shriekSound1);
				}
				break;
			case 4: // Ladybug
				break;
			case 5: // Waterlily
				break;
			case 6: // Coin
				break;
			case 7: // Diamond
				AudioServicesPlaySystemSound(catchedSound);
				break;
			case 8: // Flag
				AudioServicesPlaySystemSound(catchedSound);
				break;
		}
	}
}

- (void)rotating {
	if (rotateDir == ROTATE_DIR_CCW) {
		direction++;
		if (direction == 8) {
			direction = DIRECTION_S;
		}			
	} else if (rotateDir == ROTATE_DIR_CW) {
		direction--;
		if (direction == -1) {
			direction = DIRECTION_SW;
		}			
	}
	[self setState];
	if (direction == targetDirection) {
		state = FROG_STATE_SIT;
		rotateTimestamp = 0;
		if (doJump) {
			[self beginJumping];
		}
	} else {
		rotateTimestamp = [[NSDate date] timeIntervalSince1970];
	}
}

- (void)dead {
	if (!stealth) {
		isDead = YES;
		if ([[self getLakeView] isFrogInView:self] && [UserData instance].sound) {
			AudioServicesPlaySystemSound(shriekSound2);
		}
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:FROG_DIE_TIME];
		[UIView setAnimationDelegate:self];
		[UIView	setAnimationDidStopSelector:@selector(reset)];
		self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.5, 0.5), CGAffineTransformMakeRotation(2 * M_PI_2));
		self.alpha = 0;
		if ([[self getLakeView] isFrogInView:self] && [UserData instance].sound) {
			AudioServicesPlaySystemSound(diveSound);
		}
		if (type == FROG_TYPE_PLAYER && [UserData instance].vibration) {
			AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
		}
		[UIView	commitAnimations];
	}
}

- (void)reset {
	self.transform = CGAffineTransformIdentity;
	self.alpha = 1.0;
	if (type == FROG_TYPE_PLAYER) {
		posI = 0;
		posJ = 0;
		direction = DIRECTION_S;
	} else if (type == FROG_TYPE_OPPONENT) {
		posI = [UserData instance].rows-1;
		posJ = [UserData instance].columns-1;
		direction = DIRECTION_N;
	}
	isDead = NO;
	stealth = NO;
	flagCatched = NO;
	[self setState];
	[[self getLakeView] resetFrogLayering:self];
	if (type == FROG_TYPE_PLAYER) {
		[[self getLakeView] resetLakeScrolling];
	} else if (type == FROG_TYPE_OPPONENT) {
		[self wait];
	}
}

- (void)setStealthMode {
	if ([self isNotStopped] && !stopped) {
		self.alpha = FROG_STEALTH_ALPHA;
		stealth = YES;
		stealthBlink = 0;
		blinkTimestamp = 0;
		stealthTimestamp = [[NSDate date] timeIntervalSince1970];
		if ([[self getLakeView] isFrogInView:self] && [UserData instance].sound) {
			AudioServicesPlaySystemSound(stealthStartSound);
		}
	}
}

- (void)leaveStealthMode {
	stealthTimestamp = 0;
	if (stealthBlink < FROG_STEALTH_COUNT) {
		if (stealthBlink % 2 == 0) {
			self.alpha = 1.0;
		} else {
			self.alpha = FROG_STEALTH_ALPHA;
		}
		stealthBlink++;
		blinkTimestamp = [[NSDate date] timeIntervalSince1970];
	} else {
		stealth = NO;
		stealthTimestamp = 0;
		blinkTimestamp = 0;
		self.alpha = 1.0;
		if ([[self getLakeView] isFrogInView:self] && [UserData instance].sound && ![self shouldStop] && !stopped) {
			AudioServicesPlaySystemSound(stealthEndSound);
		}
	}
}

- (void)resetStealthMode {
	stealth = NO;
	stealthTimestamp = 0;
	blinkTimestamp = 0;
	stealthBlink =0;
	self.alpha = 1.0;
}

- (void)switching {
	if (state == FROG_STATE_SIT) {
		state = FROG_STATE_LAND;
	} else {
		state = FROG_STATE_SIT;
	}
	[self setState];
}

- (void)setState {
	if (state == FROG_STATE_SIT || state == FROG_STATE_ROTATE) {
		self.image = frogSit[direction];
	} else if (state == FROG_STATE_JUMP || state == FROG_STATE_LAND) {
		self.image = frogJump[direction];
	}
	self.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
	self.center = [self getCenterWithRow:posI andColumn:posJ andState:state];
}

- (void)start {
	if (type == FROG_TYPE_OPPONENT) {
		shouldStop = NO;
		[self wait];
	}
}

- (void)stop {
	if (type == FROG_TYPE_OPPONENT) {
		shouldStop = YES;
		[self resetStealthMode];
	}
}

- (void)resume {
	if (type == FROG_TYPE_OPPONENT) {
		shouldStop = NO;
		stopped = NO;
		[self start];
	}
}

- (BOOL)isNotStopped {
	if (type == FROG_TYPE_OPPONENT) {
		if (shouldStop) {
			stopped = YES;
			return NO;
		}
		return YES;
	}
	return YES;
}

- (void)move {
	moveTimestamp = 0;
	if ([self isNotStopped] && type == FROG_TYPE_OPPONENT) {
		int dir = [[self getLakeView] decideOpponentFrogDirection];
		if (dir != -1) {
			[self rotateTo:dir andJump:YES];
		} else {
			[self wait];
		}
	}
}

- (void)wait {
	if ([self isNotStopped] && type == FROG_TYPE_OPPONENT) {
		moveSpeed = [GameHelper getFloatRandomWithMin:FROG_MOVE_SPEED_MIN / [UserData instance].speedSqrt andMax:FROG_MOVE_SPEED_MAX / [UserData instance].speedSqrt];
		if ([UserData instance].levelType == LEVEL_TYPE_FLAG) {
			moveSpeed /= 1.25;
		}
		moveTimestamp = [[NSDate date] timeIntervalSince1970];
	}
}

- (LakeView *)getLakeView {
	return (LakeView *)self.superview;
}

- (void)dealloc {
	AudioServicesDisposeSystemSoundID(croakSound);
	AudioServicesDisposeSystemSoundID(jumpSound);
	AudioServicesDisposeSystemSoundID(landSound);
	AudioServicesDisposeSystemSoundID(diveSound);
	AudioServicesDisposeSystemSoundID(shriekSound1);
	AudioServicesDisposeSystemSoundID(shriekSound2);
	AudioServicesDisposeSystemSoundID(catchedSound);
	AudioServicesDisposeSystemSoundID(stealthStartSound);
	AudioServicesDisposeSystemSoundID(stealthEndSound);
    [super dealloc];
}

@end
