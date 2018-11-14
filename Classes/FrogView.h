//
//  FrogView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 18.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

static CGFloat FROG_TOP  = 37;
static CGFloat FROG_LEFT = 28;
									      //  S   SO    O   NO    N   NW    W   SW
static CGFloat FROG_SIT_OFFSET_TOP[8]   = {   0,  -7,  -6,  -8,  -6, -10,  -6,  -6 };
static CGFloat FROG_SIT_OFFSET_LEFT[8]  = {   0,  -1,   9,   1,   1,  -3,   2,  -1 };

static CGFloat FROG_JUMP_OFFSET_TOP[8]  = {   0,  -9, -12, -34, -28, -35, -12,  -8 };
static CGFloat FROG_JUMP_OFFSET_LEFT[8] = {  -8,  -1,   8,   2,  -4, -30, -18, -33 };

static CGFloat FROG_LAND_OFFSET_TOP[8]  = { -27, -29, -12, -18,  -4, -15, -12, -30 };
static CGFloat FROG_LAND_OFFSET_LEFT[8] = {  -8, -21, -14, -14,  -4, -10,   2, -11 };

								 // S  SO  O  NO   N  NW   W  SW
static int FROG_JUMP_DIR_ROW[8] = { 1,  1, 0, -1, -1, -1,  0,  1};
static int FROG_JUMP_DIR_COL[8] = { 0,  1, 1,  1,  0, -1, -1, -1};

static int FROG_STATE_SIT    = 0;
static int FROG_STATE_ROTATE = 1;
static int FROG_STATE_JUMP   = 3;
static int FROG_STATE_LAND   = 4;

static int ROTATE_DIR_CW  = 0;
static int ROTATE_DIR_CCW = 1;

static int DIRECTION_S  = 0;
static int DIRECTION_SO = 1;
static int DIRECTION_O  = 2;
static int DIRECTION_NO = 3;
static int DIRECTION_N  = 4;
static int DIRECTION_NW = 5;
static int DIRECTION_W  = 6;
static int DIRECTION_SW = 7;

static float FROG_JUMP_TIME     = 0.2;
static float FROG_ROTATE_TIME   = 0.0125;
static float FROG_DIE_TIME      = 1;
static float FROG_STEALTH_TIME  = 5;
static float FROG_STEALTH_BLINK = 0.25;
static float FROG_STEALTH_COUNT = 8;

static int FROG_TYPE_PLAYER   = 1;
static int FROG_TYPE_OPPONENT = 2;

static float FROG_MOVE_SPEED_MIN = 0.50;
static float FROG_MOVE_SPEED_MAX = 2.00;

static float FROG_STEALTH_ALPHA = 0.6;

@class LakeView;

@interface FrogView : UIImageView {

	int type;
	int posI;
	int posJ;
	int targetPosI;
	int targetPosJ;
	int state;
	int direction;
	int targetDirection;
	int rotateDir;
	BOOL doJump;
	BOOL isDead;
	BOOL stealth;
	int stealthBlink;
	BOOL flagCatched;
	
	BOOL shouldStop;
	BOOL stopped;

	double rotateTimestamp;
	double stealthTimestamp;
	double blinkTimestamp;
	double moveTimestamp;
	float moveSpeed;
	
	UIImage *frogSit[8];
	UIImage *frogJump[8];

	SystemSoundID croakSound;
	SystemSoundID jumpSound;
	SystemSoundID landSound;
	SystemSoundID diveSound;
	SystemSoundID shriekSound1;
	SystemSoundID shriekSound2;
	SystemSoundID catchedSound;
	SystemSoundID stealthStartSound;
	SystemSoundID stealthEndSound;
	
}

@property int type;
@property int posI;
@property int posJ;
@property int targetPosI;
@property int targetPosJ;
@property int state;
@property int direction;
@property int targetDirection;
@property int rotateDir;
@property BOOL doJump;
@property BOOL isDead;
@property BOOL stealth;
@property int stealthBlink;
@property BOOL flagCatched;

@property BOOL shouldStop;
@property BOOL stopped;

@property double rotateTimestamp;
@property double stealthTimestamp;
@property double blinkTimestamp;
@property double moveTimestamp;
@property float moveSpeed;

- (CGFloat)getHeight:(int)aState;
- (CGFloat)getWidth:(int)aState;
- (CGFloat)getYOfRow:(int)i andState:(int)aState;
- (CGFloat)getXOfColumn:(int)j andState:(int)aState;
- (CGFloat)getCenterYOfRow:(int)i andState:(int)aState;
- (CGFloat)getCenterXOfColumn:(int)j andState:(int)aState;
- (CGRect)getFrameWithRow:(int)i andColumn:(int)j andState:(int)aState;
- (CGPoint)getCenterWithRow:(int)i andColumn:(int)j andState:(int)aState;

- (id)initWithRow:(int)i andColumn:(int)j andType:(int)t;

- (void)update:(double)ts;
- (void)beginRotating;
- (void)beginJumping;
- (void)endJumping;
- (void)objectCatched:(int)objectType;

- (void)rotating;
- (void)rotateTo:(int)toDirection andJump:(BOOL)jump;
- (void)setState;
- (void)dead;
- (void)setStealthMode;
- (void)leaveStealthMode;
- (void)resetStealthMode;
- (void)reset;
- (void)start;
- (void)stop;
- (void)resume;
- (BOOL)isNotStopped;
- (void)move;
- (void)wait;

- (LakeView *)getLakeView;

@end
