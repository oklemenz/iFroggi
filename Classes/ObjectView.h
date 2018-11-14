//
//  ObjectView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 09.07.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

static int TYPE_FLY         = 1;
static int TYPE_BUTTERFLY   = 2;
static int TYPE_CATERPILLAR = 3;
static int TYPE_LADYBUG     = 4;
static int TYPE_WATERLILY   = 5;
static int TYPE_COIN        = 6;
static int TYPE_DIAMOND     = 7;
static int TYPE_FLAG        = 8;

static int KIND_FLAG_FROG     = 0;
static int KIND_FLAG_OPP_FROG = 1;

static int BUTTERFLY_STATE_NO_CLAP         = 0;
static int BUTTERFLY_STATE_FIRST_CLAP      = 1;
static int BUTTERFLY_STATE_FIRST_CLAP_END  = 2;
static int BUTTERFLY_STATE_SECOND_CLAP     = 3;
static int BUTTERFLY_STATE_SECOND_CLAP_END = 4;

static float BUTTERFLY_CLAP_TIME = 0.3;
										  // F     BF    CP    LB    WL    CO     DI    
static float OBJECT_OCCURENCES[10][7]  = { { 0.50, 0.00, 0.00, 0.00, 0.00, 0.00,  0.00 },   // Fly (F)
									       { 0.50, 0.50, 0.00, 0.00, 0.00, 0.00,  0.00 },   // Butterfly (BF)
										   { 0.50, 1.00, 1.00, 0.00, 0.00, 0.00,  0.00 },   // Caterpillar (CP)
										   { 0.50, 1.50, 1.00, 0.15, 0.00, 0.00,  0.00 },   // Ladybug (LB)
										   { 0.50, 1.50, 1.00, 0.05, 1.00, 0.00,  0.00 },   // Waterlily (WL)
										   { 0.50, 1.50, 1.00, 0.05, 0.80, 0.15,  0.00 },   // Coin (CO)
										   { 0.50, 2.50, 1.00, 0.05, 0.80, 0.15,  0.00 },   // Time
										   { 0.50, 0.50, 1.00, 0.05, 0.80, 0.15,  0.50 },   // Diamond (DI)
										   { 0.50, 0.50, 1.00, 0.05, 0.80, 0.15,  0.75 },   // Opponent
										   { 0.50, 0.50, 1.50, 0.05, 0.80, 0.15,  0.00 } }; // Flag

@class LakeView;

@interface ObjectView : UIImageView {
	
	int objectType;
	int kind;
	int state;
	
	int posI;
	int posJ;
	CGFloat objectLeft;
	CGFloat objectTop;	

	UIImage *imageNormal;
	UIImage *imageClap;
	
	BOOL shouldStop;
	BOOL stopped;
	
	double timestamp;
	float firstClapTime;
	float secondClapTime;

}

@property int objectType;
@property int kind;
@property int state;

@property int posI;
@property int posJ;
@property CGFloat objectLeft;
@property CGFloat objectTop;
@property BOOL shouldStop;
@property BOOL stopped;

@property double timestamp;
@property float firstClapTime;
@property float secondClapTime;

- (id)initWithRow:(int)i andColumn:(int)j;
- (id)initWithRow:(int)i andColumn:(int)j andType:(int)aType;
- (id)initWithRow:(int)i andColumn:(int)j andType:(int)aType andKind:(int)aKind;

- (void)changeType;
- (void)setObjectType:(int)aType andRandom:(BOOL)random;
- (int)chooseType;

- (void)clap;
- (void)firstClap;
- (void)endFirstClap;
- (void)secondClap;
- (void)endSecondClap;

- (void)update:(double)ts;
- (void)start;
- (void)stop;
- (void)resume;
- (BOOL)isNotStopped;

- (LakeView *)getLakeView;

@end
