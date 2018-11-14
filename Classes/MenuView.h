//
//  MenuView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class MenuViewController;

@interface MenuView : UIImageView {

	IBOutlet MenuViewController *menuViewController;

	IBOutlet UIImageView *aNewGameButtonView;
	IBOutlet UIImageView *resumeGameButtonView;
	IBOutlet UIImageView *optionsButtonView;
	IBOutlet UIImageView *highscoreButtonView;
	
	SystemSoundID buttonSound;
	
}

@property(nonatomic, retain) IBOutlet MenuViewController *menuViewController;

@property(nonatomic, retain) IBOutlet UIImageView *aNewGameButtonView;
@property(nonatomic, retain) IBOutlet UIImageView *resumeGameButtonView;
@property(nonatomic, retain) IBOutlet UIImageView *optionsButtonView;
@property(nonatomic, retain) IBOutlet UIImageView *highscoreButtonView;

@end
