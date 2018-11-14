//
//  iFroggiAppDelegate.h
//  iFroggi
//
//  Created by Oliver Klemenz on 06.01.10.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class CopyrightViewController;
@class MenuViewController;
@class HighscoreViewController;
@class LevelViewController;
@class LakeViewController;

@interface iFroggiAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIViewController *rootViewController;
	IBOutlet CopyrightViewController *copyrightViewController;
	IBOutlet MenuViewController *menuViewController;
	IBOutlet HighscoreViewController *highscoreViewController;
	IBOutlet LevelViewController *levelViewController;
	IBOutlet LakeViewController *lakeViewController;
	
	SystemSoundID button1Sound;
	BOOL swipeToNextLevel;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIViewController *rootViewController;
@property (nonatomic, retain) IBOutlet CopyrightViewController *copyrightViewController;
@property (nonatomic, retain) IBOutlet MenuViewController *menuViewController;
@property (nonatomic, retain) IBOutlet HighscoreViewController *highscoreViewController;
@property (nonatomic, retain) IBOutlet LevelViewController *levelViewController;
@property (nonatomic, retain) IBOutlet LakeViewController *lakeViewController;

@property BOOL swipeToNextLevel;

+ (iFroggiAppDelegate *)instance;

- (void)showMenu;
- (void)showHighscore;
- (void)showGameHighscore;
- (void)showLevel;
- (void)showGame;

- (void)newGame;
- (void)resumeGame;
- (void)nextLevel;

@end

