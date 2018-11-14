//
//  LevelView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 27.09.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class LevelViewController;

static int LEVEL_TYPE_FLY         = 1;
static int LEVEL_TYPE_BUTTERFLY   = 2;
static int LEVEL_TYPE_CATERPILLAR = 3;
static int LEVEL_TYPE_LADYBUG     = 4;
static int LEVEL_TYPE_WATERLILY   = 5;
static int LEVEL_TYPE_COIN        = 6;
static int LEVEL_TYPE_TIME        = 7;
static int LEVEL_TYPE_DIAMOND     = 8;
static int LEVEL_TYPE_OPPONENT    = 9;
static int LEVEL_TYPE_FLAG        = 10;

@interface LevelView : UIView {
	
	CGPoint swipeStart;
	CGPoint swipeStart2;
	BOOL swipe;
	
	IBOutlet LevelViewController *levelViewController;
	IBOutlet UIImageView *menuButtonView;
	IBOutlet UIImageView *arrowLeft;
	IBOutlet UIImageView *arrowRight;
	
	SystemSoundID buttonSound;
	
}

@property(nonatomic, retain) IBOutlet LevelViewController *levelViewController;
@property(nonatomic, retain) IBOutlet UIImageView *menuButtonView;
@property(nonatomic, retain) IBOutlet UIImageView *arrowLeft;
@property(nonatomic, retain) IBOutlet UIImageView *arrowRight;

@property BOOL swipe;

@end
