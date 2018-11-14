//
//  GameBarView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 26.09.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "GameBarView.h"
#import "UserData.h"
#import "NumberView.h"
#import "ImageCache.h"
#import "LevelView.h"

@implementation GameBarView

@synthesize livesNumberView, clockNumberView, diamondNumberView, butterflyNumberView, scoreNumberView, frogFlagView, opponentFrogFlagView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
	}
	return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	livesNumberView	= [[NumberView alloc] initWithType:TYPE_SMALL andX:2 andY:3 andXAlign:ALIGN_X_LEFT andYAlign:ALIGN_Y_TOP];
	[livesNumberView setNumber:[UserData instance].lives];
	[livesNumberView setImage:[[ImageCache instance] getImage:IMAGE_LIVES_GB] andOffsetX:0 andOffsetY:-2];
	[self addSubview:livesNumberView];
	
	clockNumberView	= [[NumberView alloc] initWithType:TYPE_SMALL andX:130 andY:3 andXAlign:ALIGN_X_LEFT andYAlign:ALIGN_Y_TOP];
	[clockNumberView setImage:[[ImageCache instance] getImage:IMAGE_TIME_GB] andOffsetX:-1 andOffsetY:-6];
	[self addSubview:clockNumberView];
	
	diamondNumberView = [[NumberView alloc] initWithType:TYPE_SMALL andX:230 andY:3 andXAlign:ALIGN_X_LEFT andYAlign:ALIGN_Y_TOP];
	[diamondNumberView setImage:[[ImageCache instance] getImage:IMAGE_DIAMOND_GB] andOffsetX:-1 andOffsetY:-8];
	[self addSubview:diamondNumberView];
	
	butterflyNumberView = [[NumberView alloc] initWithType:TYPE_SMALL andX:230 andY:3 andXAlign:ALIGN_X_LEFT andYAlign:ALIGN_Y_TOP];
	[butterflyNumberView setImage:[[ImageCache instance] getImage:IMAGE_BUTTERFLY_GB] andOffsetX:-1 andOffsetY:-8];
	[self addSubview:butterflyNumberView];
	
	frogFlagView = [[UIImageView alloc] initWithImage:[[ImageCache instance] getImage:IMAGE_FROG_FLAG]];
	frogFlagView.center = CGPointMake(240, 14);
	frogFlagView.hidden = YES;
	[self addSubview:frogFlagView];
	
	opponentFrogFlagView = [[UIImageView alloc] initWithImage:[[ImageCache instance] getImage:IMAGE_OPP_FROG_FLAG]];
	opponentFrogFlagView.center = CGPointMake(270, 14);
	opponentFrogFlagView.hidden = YES;
	[self addSubview:opponentFrogFlagView];
	
	scoreNumberView = [[NumberView alloc] initWithType:TYPE_SMALL andX:2 andY:3 andXAlign:ALIGN_X_RIGHT andYAlign:ALIGN_Y_TOP];
	[scoreNumberView setNumber:[UserData instance].score];
	[scoreNumberView setImage:[[ImageCache instance] getImage:IMAGE_COIN_GB] andOffsetX:-1 andOffsetY:-1];
	[self addSubview:scoreNumberView];
}

- (void)update {
	[livesNumberView setNumber:[UserData instance].lives >= 0 ? [UserData instance].lives : 0];
	[clockNumberView setNumber:[UserData instance].time];
	[butterflyNumberView setNumber:[UserData instance].butterflies andMaxNumber:[UserData instance].maxButterflies];
	[diamondNumberView setNumber:[UserData instance].diamonds andMaxNumber:[UserData instance].maxDiamonds];
	[scoreNumberView setNumber:[UserData instance].score];
}

- (void)dealloc {
    [super dealloc];
}

@end
