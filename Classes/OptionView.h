//
//  OptionView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class MenuViewController;

static CGFloat OPTION_ON_X_OFFSET[3]  = { 108, 108, 157 };
static CGFloat OPTION_ON_Y_OFFSET[3]  = {  59, 117, 175 };

static CGFloat OPTION_OFF_X_OFFSET[3] = { 155, 155, 203 };
static CGFloat OPTION_OFF_Y_OFFSET[3] = {  54, 112, 170 };

@interface OptionView : UIImageView {
	IBOutlet MenuViewController *menuViewController;
	BOOL music;

	UIImage *optionOn[2];
	UIImage *optionOff[2];
	UIImageView *optionOnViews[3];
	UIImageView *optionOffViews[3];
	IBOutlet UIImageView *backButtonView;
	
	SystemSoundID button1Sound;
	SystemSoundID button2Sound;
	
}

@property(nonatomic, retain) IBOutlet MenuViewController *menuViewController;
@property(nonatomic, retain) IBOutlet UIImageView *backButtonView;

- (void)reload;

@end
