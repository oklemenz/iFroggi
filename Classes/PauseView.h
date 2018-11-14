//
//  PauseView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 23.10.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class MenuViewController;
@class LakeView;

static CGFloat OPTION_ON_X_OFFSET[3]  = { 208, 208, 257 }; // +100
static CGFloat OPTION_ON_Y_OFFSET[3]  = { 125, 183, 241 }; // +66

static CGFloat OPTION_OFF_X_OFFSET[3] = { 255, 255, 303 };
static CGFloat OPTION_OFF_Y_OFFSET[3] = { 120, 178, 236 };

@interface PauseView : UIImageView {

	IBOutlet UIView	*blackView;
	IBOutlet UIImageView *pauseTitleView;
	IBOutlet LakeView *lakeView;
	IBOutlet UIImageView *exitButtonView;
	IBOutlet UIImageView *continueButtonView;
	
	BOOL shouldPulsate;
	BOOL pulsate;
	
	UIImage *optionOn[2];
	UIImage *optionOff[2];
	UIImageView *optionOnViews[3];
	UIImageView *optionOffViews[3];
	
	SystemSoundID button1Sound;
	SystemSoundID button2Sound;
	
}

@property(nonatomic, retain) IBOutlet MenuViewController *menuViewController;
@property(nonatomic, retain) IBOutlet UIView *blackView;
@property(nonatomic, retain) IBOutlet UIImageView *pauseTitleView;
@property(nonatomic, retain) IBOutlet LakeView *lakeView;
@property(nonatomic, retain) IBOutlet UIImageView *exitButtonView;
@property(nonatomic, retain) IBOutlet UIImageView *continueButtonView;

@property BOOL shouldPulsate;
@property BOOL pulsate;

- (void)reload;

- (void)shrinkPauseButton;
- (void)growPauseButton;
- (void)stopPulsating;

@end
