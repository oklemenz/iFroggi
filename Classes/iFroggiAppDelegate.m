//
//  iFroggiAppDelegate.m
//  iFroggi
//
//  Created by Oliver Klemenz on 06.01.10.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "iFroggiAppDelegate.h"
#import "CopyrightViewController.h"
#import "MenuViewController.h"
#import "HighscoreViewController.h"
#import "LevelViewController.h"
#import "LakeViewController.h"
#import "HighscoreView.h"
#import "EnterNameView.h"
#import "MenuView.h"
#import "LakeView.h"
#import "UserData.h"
#import "MusicHandler.h"
#import "ImageCache.h"

@implementation iFroggiAppDelegate

@synthesize window, rootViewController, copyrightViewController, menuViewController, levelViewController, lakeViewController, highscoreViewController, swipeToNextLevel;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"button1" ofType:@"caf"]], &button1Sound);
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    
    self.rootViewController = [[UIViewController alloc] init];
    self.rootViewController.view.bounds = CGRectMake(0, 0, 480, 320);

    CGFloat scaleX = bounds.size.width / self.rootViewController.view.bounds.size.width;
    CGFloat scaleY = bounds.size.height / self.rootViewController.view.bounds.size.height;
    self.rootViewController.view.transform = CGAffineTransformMakeScale(scaleX, scaleY);
    self.rootViewController.view.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
    
    window.rootViewController = rootViewController;
    [window addSubview:rootViewController.view];
    
    [rootViewController.view addSubview:copyrightViewController.view];
	copyrightViewController.view.alpha = 0.0;
    
    [window makeKeyAndVisible];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	copyrightViewController.view.alpha = 1.0;
	[UIView	commitAnimations];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[UserData instance] store];
}

- (void)showMenu {
	[[MusicHandler instance] resetSeek];
	[[MusicHandler instance] playMenuMusic];
	menuViewController.view.alpha = 0.0;
	if ([UserData instance].gameOver) {
		[[UserData instance] reset];
	}
	[window.rootViewController.view addSubview:menuViewController.view];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(menuDisplayed)];
	menuViewController.inTransition = YES;
	menuViewController.view.alpha = 1.0;
	[UIView	commitAnimations];
}

- (void)menuDisplayed {
	[highscoreViewController.view removeFromSuperview];
	[levelViewController.view removeFromSuperview];
	[lakeViewController.view removeFromSuperview];
	[menuViewController initMenuDialog];
}

- (void)showHighscore {
	[window.rootViewController.view addSubview:highscoreViewController.view];
	highscoreViewController.view.alpha = 0.0;
	[highscoreViewController.highscoreView reset];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(highscoreDisplayed)];
	highscoreViewController.inTransition = YES;
	highscoreViewController.view.alpha = 1.0;
	[UIView	commitAnimations];
}

- (void)showGameHighscore {
	[window.rootViewController.view addSubview:highscoreViewController.view];
	highscoreViewController.view.alpha = 0.0;
	[highscoreViewController.highscoreView reset];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(gameHighscoreDisplayed)];
	highscoreViewController.inTransition = YES;
	highscoreViewController.view.alpha = 1.0;
	[UIView	commitAnimations];
}

- (void)highscoreDisplayed {
	highscoreViewController.inTransition = NO;
	
}

- (void)gameHighscoreDisplayed {
	[self highscoreDisplayed];
	if ([[UserData instance] isScoreInHighscore] != -1 && [UserData instance].score > 0) {
		[highscoreViewController.highscoreView showEnterName];
	}
}

- (void)showLevel {
	[[MusicHandler instance] resetSeek];
	[[MusicHandler instance] playMenuMusic];
	[window.rootViewController.view addSubview:levelViewController.view];
	levelViewController.view.alpha = 0.0;
	[levelViewController initLevel];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(levelDisplayed)];
	levelViewController.inTransition = YES;
	levelViewController.view.alpha = 1.0;
	[UIView	commitAnimations];
}

- (void)levelDisplayed {
	levelViewController.inTransition = NO;
	[menuViewController.view removeFromSuperview];
	if (swipeToNextLevel) {
		[levelViewController increaseLevel];
		[[UserData instance] store];
		swipeToNextLevel = NO;
	}
}

- (void)showGame {
	[[UserData instance] clear];
	[lakeViewController prepare];
	[lakeViewController startGame];
	[levelViewController.view removeFromSuperview];
	[window.rootViewController.view addSubview:lakeViewController.view];
}

- (void)nextLevel {
	if ([UserData instance].level == [UserData instance].maxLevel) {
		[UserData instance].maxLevel += 1;
	}
	swipeToNextLevel = YES;
	[self showLevel];
}

- (void)newGame {
	if ([[UserData instance] gameStarted]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Quit current game?"
                                                                       message:@"Do you really want to quit current game?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    if ([UserData instance].sound) {
                                                        AudioServicesPlaySystemSound(button1Sound);
                                                    }
                                                    [[UserData instance] reset];
                                                    [self showLevel];
                                                }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"No"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction * action) {
                                                    if ([UserData instance].sound) {
                                                        AudioServicesPlaySystemSound(button1Sound);
                                                    }
                                                }]];
        
        [[[[iFroggiAppDelegate instance] window] rootViewController] presentViewController:alert animated:YES completion:nil];
	} else {
		[[UserData instance] reset];
		[self showLevel];
	}
}

- (void)resumeGame {
	if ([UserData instance].lives >= 0) {
		[self showLevel];
	} else {
		[[UserData instance] reset];
		[self showLevel];
	}
}

+ (iFroggiAppDelegate *)instance {
	return (iFroggiAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)dealloc {
	[copyrightViewController release];
	[menuViewController release];
	[highscoreViewController release];
	[levelViewController release];
	[lakeViewController release];
    [window release];
    [super dealloc];
}

@end
