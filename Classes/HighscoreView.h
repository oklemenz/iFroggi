//
//  HighscoreView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 26.09.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class HighscoreViewController, EnterNameView;

@interface HighscoreView : UIView <UITextFieldDelegate> {

	IBOutlet HighscoreViewController *highscoreViewController;
	IBOutlet EnterNameView *enterNameView;
	IBOutlet UIImageView *okButtonView;
	IBOutlet UIImageView *clearButtonView;
	IBOutlet UIImageView *backButtonView;
	
	BOOL inNameEntering;
	int newScorePos;
	
	SystemSoundID buttonSound;
}

@property(nonatomic, retain) IBOutlet HighscoreViewController *highscoreViewController;
@property(nonatomic, retain) IBOutlet EnterNameView *enterNameView;
@property(nonatomic, retain) IBOutlet UIImageView *okButtonView;
@property(nonatomic, retain) IBOutlet UIImageView *clearButtonView;
@property(nonatomic, retain) IBOutlet UIImageView *backButtonView;

@property BOOL inNameEntering;
@property int newScorePos;

- (void)reset;
- (void)showEnterName;
- (void)hideEnterName;

@end