//
//  MenuView.m
//  iFroggi
//Performance

//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "MenuView.h"
#import "iFroggiAppDelegate.h"
#import "MenuViewController.h"
#import "UserData.h"

@implementation MenuView

@synthesize menuViewController;
@synthesize aNewGameButtonView, resumeGameButtonView, optionsButtonView, highscoreButtonView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"button1" ofType:@"caf"]], &buttonSound);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	aNewGameButtonView.hidden = YES;
	resumeGameButtonView.hidden = YES;
	optionsButtonView.hidden = YES;
	highscoreButtonView.hidden = YES;
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
	// New Game
	if (point.x >= aNewGameButtonView.frame.origin.x - self.frame.origin.x &&
        point.y >= aNewGameButtonView.frame.origin.y - self.frame.origin.y &&
		point.x <= aNewGameButtonView.frame.origin.x - self.frame.origin.x + aNewGameButtonView.frame.size.width &&
        point.y <= aNewGameButtonView.frame.origin.y - self.frame.origin.y + aNewGameButtonView.frame.size.height) {
		aNewGameButtonView.hidden = NO;
	}
	// Resume Game
	if (point.x >= resumeGameButtonView.frame.origin.x - self.frame.origin.x &&
        point.y >= resumeGameButtonView.frame.origin.y - self.frame.origin.y &&
		point.x <= resumeGameButtonView.frame.origin.x - self.frame.origin.x + resumeGameButtonView.frame.size.width &&
        point.y <= resumeGameButtonView.frame.origin.y - self.frame.origin.y + resumeGameButtonView.frame.size.height) {
		resumeGameButtonView.hidden = NO;
	}
	// Options Game
	if (point.x >= optionsButtonView.frame.origin.x - self.frame.origin.x &&
        point.y >= optionsButtonView.frame.origin.y - self.frame.origin.y &&
		point.x <= optionsButtonView.frame.origin.x - self.frame.origin.x + optionsButtonView.frame.size.width &&
        point.y <= optionsButtonView.frame.origin.y - self.frame.origin.y + optionsButtonView.frame.size.height) {
		optionsButtonView.hidden = NO;
	}
	// Highscore
    if (point.x >= highscoreButtonView.frame.origin.x - self.frame.origin.x &&
        point.y >= highscoreButtonView.frame.origin.y - self.frame.origin.y &&
        point.x <= highscoreButtonView.frame.origin.x - self.frame.origin.x + highscoreButtonView.frame.size.width &&
        point.y <= highscoreButtonView.frame.origin.y - self.frame.origin.y + highscoreButtonView.frame.size.height) {
        highscoreButtonView.hidden = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!menuViewController.inTransition) {
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint point = [touch locationInView:self];
		// New Game
		if (point.x >= aNewGameButtonView.frame.origin.x - self.frame.origin.x &&
            point.y >= aNewGameButtonView.frame.origin.y - self.frame.origin.y &&
			point.x <= aNewGameButtonView.frame.origin.x - self.frame.origin.x + aNewGameButtonView.frame.size.width &&
            point.y <= aNewGameButtonView.frame.origin.y - self.frame.origin.y + aNewGameButtonView.frame.size.height) {
			if ([UserData instance].sound) {
				AudioServicesPlaySystemSound(buttonSound);
			}
			[[iFroggiAppDelegate instance] newGame];
		}
		// Resume Game
		if (point.x >= resumeGameButtonView.frame.origin.x - self.frame.origin.x &&
            point.y >= resumeGameButtonView.frame.origin.y - self.frame.origin.y &&
			point.x <= resumeGameButtonView.frame.origin.x - self.frame.origin.x + resumeGameButtonView.frame.size.width &&
            point.y <= resumeGameButtonView.frame.origin.y - self.frame.origin.y + resumeGameButtonView.frame.size.height) {
			if ([UserData instance].sound) {
				AudioServicesPlaySystemSound(buttonSound);
			}
			[[iFroggiAppDelegate instance] resumeGame];
		}
		// Options Game
		if (point.x >= optionsButtonView.frame.origin.x - self.frame.origin.x &&
            point.y >= optionsButtonView.frame.origin.y - self.frame.origin.y &&
			point.x <= optionsButtonView.frame.origin.x - self.frame.origin.x + optionsButtonView.frame.size.width &&
            point.y <= optionsButtonView.frame.origin.y - self.frame.origin.y + optionsButtonView.frame.size.height) {
			if (!menuViewController.inOptions) {
				if ([UserData instance].sound) {
					AudioServicesPlaySystemSound(buttonSound);
				}
				[menuViewController showOptionDialog];
			}
		}
        // Highscore
        if (point.x >= highscoreButtonView.frame.origin.x - self.frame.origin.x &&
            point.y >= highscoreButtonView.frame.origin.y - self.frame.origin.y &&
            point.x <= highscoreButtonView.frame.origin.x - self.frame.origin.x + highscoreButtonView.frame.size.width &&
            point.y <= highscoreButtonView.frame.origin.y - self.frame.origin.y + highscoreButtonView.frame.size.height) {
            if ([UserData instance].sound) {
                AudioServicesPlaySystemSound(buttonSound);
            }
            [[iFroggiAppDelegate instance] showHighscore];
        }
	}
	aNewGameButtonView.hidden = YES;
	resumeGameButtonView.hidden = YES;
	optionsButtonView.hidden = YES;
	highscoreButtonView.hidden = YES;
}

- (void)dealloc {
    [super dealloc];
}

@end
