//
//  Lake.h
//  iFroggi
//
//  Created by Oliver Klemenz on 11.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#import "GameHelper.h"
#import "Math.h"

@class UserData, MusicHandler, NumberView;
@class WaterView, GrassView, WaterLilyPadView, StoneView, FrogView, ReedView, GameBarView, PauseView;

static CGFloat DEGREE = M_PI / 8;  

static int WATERLILYPAD_ROWS = 5;
static int WATERLILYPAD_COLS = 5;
static int DEFAULT_LAKE_SIZE = 5;

static int STATUS_INIT        = 0;
static int STATUS_PLAY        = 1;
static int STATUS_PAUSE       = 2;
static int STATUS_DEAD        = 3;
static int STATUS_OUT_OF_TIME = 4;
static int STATUS_GAME_OVER   = 5;
static int STATUS_LEVEL_DONE  = 6;
static int STATUS_YOU_WON	  = 7;
static int STATUS_YOU_LOST	  = 8;

static int DIAMOND_STATUS_DEFAULT = 0;
static int DIAMOND_STATUS_ACTIVE  = 1;
static int DIAMOND_STATUS_CATCHED = 2;

static float SECOND = 1.0;
static float BONUS_TIME = 0.03;
static float HIDE_TIME = 3.0;
static float FRAME_RATE = 1.0 / 60.0;

static int DIAMOND_COUNT = 4;
static int BONUS_COUNT_STEP = 3;

static int NEW_LIFE_POINTS_BASE = 4000;
static int NEW_LIFE_POINTS      = 1000;
static int BONUS_TIME_POINTS	= 5;

@interface LakeView : UIView <UIApplicationDelegate> {

	WaterView *waterView;
	GrassView *grassView;
	StoneView *stoneView;
	StoneView *opponentStoneView;
	FrogView *frogView;
	FrogView *opponentFrogView;

	UIImageView *gameBarMoveView;

	IBOutlet UIView *gameView;
	IBOutlet PauseView *pauseView;
	IBOutlet UIImageView *pauseButtonView;
	IBOutlet GameBarView *gameBarView;
	IBOutlet UIImageView *levelView;
	IBOutlet NumberView *levelNumberView;
	IBOutlet UIImageView *goView;
	IBOutlet UIImageView *deadView;
	IBOutlet UIImageView *gameOverView;
	IBOutlet UIImageView *outOfTimeView;
	IBOutlet UIImageView *levelDoneView;
	IBOutlet UIImageView *youWonView;
	IBOutlet UIImageView *youLostView;
	
	NSMutableArray *reedViews;
	NSMutableArray *waterReedViews;
	NSMutableArray *waterReedMirrorViews;
	NSMutableArray *waterLilyPadViews;
	NSMutableArray *waterLilyPadViewsToRelease;
	
	CGFloat scrollX;
	CGFloat scrollY;
	
	BOOL firstAcceleration;
	CGPoint dragStartPoint;
	BOOL dragStarted;
    BOOL pausePressed;
	int status;
	
	int waterLilyPadCount;
	int diamondStatus[4];
	
	NSTimer *timer;
	double secondTimestamp;
	double bonusTimestamp;
	double hideTimestamp;
	
	SystemSoundID goSound;
	SystemSoundID failedSound;
	SystemSoundID successSound;
	SystemSoundID newLifeSound;
	SystemSoundID buttonSound;

}

@property(nonatomic, retain) WaterView *waterView; 
@property(nonatomic, retain) GrassView *grassView; 
@property(nonatomic, retain) StoneView *stoneView; 
@property(nonatomic, retain) StoneView *opponentStoneView; 
@property(nonatomic, retain) FrogView *frogView; 
@property(nonatomic, retain) FrogView *opponentFrogView; 

@property(nonatomic, retain) IBOutlet PauseView *pauseView;
@property(nonatomic, retain) IBOutlet UIImageView *pauseButtonView;
@property(nonatomic, retain) IBOutlet GameBarView *gameBarView;
@property(nonatomic, retain) IBOutlet UIView *gameView;
@property(nonatomic, retain) IBOutlet UIImageView *levelView;
@property(nonatomic, retain) IBOutlet NumberView *levelNumberView;
@property(nonatomic, retain) IBOutlet UIImageView *goView;
@property(nonatomic, retain) IBOutlet UIImageView *deadView;
@property(nonatomic, retain) IBOutlet UIImageView *gameOverView;
@property(nonatomic, retain) IBOutlet UIImageView *outOfTimeView;
@property(nonatomic, retain) IBOutlet UIImageView *levelDoneView;
@property(nonatomic, retain) IBOutlet UIImageView *youWonView;
@property(nonatomic, retain) IBOutlet UIImageView *youLostView;

@property(nonatomic, retain) UIImageView *gameBarMoveView;

@property CGFloat scrollX;
@property CGFloat scrollY;

@property BOOL firstAcceleration;
@property CGPoint dragStartPoint;
@property BOOL dragStarted;
@property BOOL pausePressed;
@property int status;

@property int waterLilyPadCount;

@property(nonatomic, retain) NSTimer *timer;
@property double secondTimestamp;
@property double bonusTimestamp;
@property double hideTimestamp;

@property (nonatomic, strong) CMMotionManager *motionManager;

+ (CGFloat)getDistanceFromStart:(CGPoint)start toEnd:(CGPoint)end;
+ (int)getDirectionFromStart:(CGPoint)start toEnd:(CGPoint)end;

- (void)showLevelText;
- (void)showLevelNumber;
- (void)showGo;

- (void)showDead;
- (void)hideDead;
- (void)showGameOver;
- (void)hideGameOver;
- (void)showLevelDone;
- (void)hideLevelDone;
- (void)showOutOfTime;
- (void)hideOutOfTime;
- (void)showYouLost;
- (void)hideYouLost;
- (void)showYouWon;
- (void)hideYouWon;

- (void)play;
- (void)prepare; 
- (void)startGame;
- (void)pause;
- (void)resume;

- (void)startTimer;
- (void)stopTimer;
- (void)runLoop;
- (void)decreaseSecond;

- (void)addScore:(int)score;

- (void)countBonus;
- (void)addRestBonus;

- (void)nextLevel;
- (void)cleanup;
- (void)exit;
- (void)end;
- (void)die;
- (void)checkGameOver;
- (void)continueGame;

- (void)notifyFrogJump:(FrogView *)frog;
- (void)doFrogLayering:(FrogView *)frog andTarget:(CGPoint)point;
- (void)resetFrogLayering:(FrogView *)frog;
- (BOOL)isFrogInView:(FrogView *)frog;
- (BOOL)isWaterLilyPadInView:(WaterLilyPadView *)waterLilyPad;
- (void)checkForPauseButton;
- (void)resetLakeScrolling;

- (void)checkFrogsDeath;
- (BOOL)checkFrogDeath:(FrogView *)frog;
- (void)checkFrogsWaterLilyPad:(WaterLilyPadView *)waterLilyPad;
- (void)checkWaterLilyPad:(FrogView *)frog;
- (void)checkWaterLilyPad:(FrogView *)frog andWaterLilyPad:(WaterLilyPadView *)waterLilyPad;
- (void)showFlag:(FrogView *)frog;

- (int)decideOpponentFrogDirection;
- (int)getNextDiamond;
- (void)resetDiamond:(int)diamond;
- (void)moveGameBarView:(UIImageView *)view atPoint:(CGPoint)atPoint toPoint:(CGPoint )toPoint;

- (CGFloat)getLakeWidth;
- (CGFloat)getLakeHeight;

@end
