//
//  LevelView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 27.09.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "LevelView.h"
#import "iFroggiAppDelegate.h"
#import "LevelViewController.h"

#import "UserData.h"
#import "ImageCache.h"

#define HORIZ_SWIPE_DRAG_MIN  12
#define VERT_SWIPE_DRAG_MAX   10

@implementation LevelView

@synthesize levelViewController, menuButtonView, arrowLeft, arrowRight, swipe;

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
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
	swipe = NO;
	if (point.y < 270) {
		if (touch.tapCount == 2) {
			[levelViewController switchStartEnd];
		}
		swipeStart = [touch locationInView:self];
	} 
	[self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	arrowLeft.image = [[ImageCache instance] getImage:IMAGE_ARROW_LEFT];
	arrowRight.image = [[ImageCache instance] getImage:IMAGE_ARROW_RIGHT];
	UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
	// Arrow Left
	if (point.x >= arrowLeft.frame.origin.x &&
        point.y >= arrowLeft.frame.origin.y &&
		point.x <= arrowLeft.frame.origin.x + arrowLeft.frame.size.width &&
        point.y <= arrowLeft.frame.origin.y + arrowLeft.frame.size.height) {
		if (touch.tapCount == 1) {
			arrowLeft.image = [[ImageCache instance] getImage:IMAGE_ARROW_LEFT_P];
		}
	} else if (point.x >= arrowRight.frame.origin.x &&
               point.y >= arrowRight.frame.origin.y &&
			   point.x <= arrowRight.frame.origin.x + arrowRight.frame.size.width &&
               point.y <= arrowRight.frame.origin.y + arrowRight.frame.size.height) {
		if (touch.tapCount == 1) {
			arrowRight.image = [[ImageCache instance] getImage:IMAGE_ARROW_RIGHT_P];
		}
	} else if (point.y < 270 && !swipe && fabs(swipeStart.x - point.x) >= HORIZ_SWIPE_DRAG_MIN && fabs(swipeStart.y - point.y) <= VERT_SWIPE_DRAG_MAX) {
		swipe = YES;
        if (swipeStart.x < point.x) {
			if ([event allTouches].count == 1) {
				[levelViewController decreaseLevel];
			} else {
				[levelViewController decreaseLevelByTen];
			}
        } else {
			if ([event allTouches].count == 1) {
				[levelViewController increaseLevel];
			} else {
				[levelViewController increaseLevelByTen];
			}
		}
    }
	// Menu
	menuButtonView.hidden = YES;
	if (point.x >= menuButtonView.frame.origin.x &&
        point.y >= menuButtonView.frame.origin.y &&
		point.x <= menuButtonView.frame.origin.x + menuButtonView.frame.size.width &&
        point.y <= menuButtonView.frame.origin.y + menuButtonView.frame.size.height) {
		menuButtonView.hidden = NO;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// Game
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.tapCount == 1 && !swipe) {
		CGPoint point = [touch locationInView:self];
		// Arrow Left
		if (arrowLeft.alpha > 0 &&
            point.x >= arrowLeft.frame.origin.x &&
            point.y >= arrowLeft.frame.origin.y &&
			point.x <= arrowLeft.frame.origin.x + arrowLeft.frame.size.width &&
            point.y <= arrowLeft.frame.origin.y + arrowLeft.frame.size.height) {
			if ([UserData instance].sound) {
				AudioServicesPlaySystemSound(buttonSound);
			}
			[levelViewController decreaseLevel];
		} else if (arrowRight.alpha > 0 &&
                   point.x >= arrowRight.frame.origin.x &&
                   point.y >= arrowRight.frame.origin.y &&
				   point.x <= arrowRight.frame.origin.x + arrowRight.frame.size.width &&
                   point.y <= arrowRight.frame.origin.y + arrowRight.frame.size.height) {
			if ([UserData instance].sound) {
				AudioServicesPlaySystemSound(buttonSound);
			}
			[levelViewController increaseLevel];			
		} else if (point.x >= 115 && point.x <= 355 && point.y >= 120 && point.y <= 280 && !levelViewController.inMove && !levelViewController.inTransition) { 
			if ([UserData instance].sound) {
				AudioServicesPlaySystemSound(buttonSound);
			}
			[levelViewController stopPulsating];
			[levelViewController selectGrowAndFadeOut];
			[[UserData instance] store];
		}
	}
	// Menu
	if (!levelViewController.inTransition) {
		if (touch.tapCount == 1 && !swipe) {
			CGPoint point = [touch locationInView:self];
			if (point.x >= menuButtonView.frame.origin.x  &&
                point.y >= menuButtonView.frame.origin.y &&
				point.x <= menuButtonView.frame.origin.x + menuButtonView.frame.size.width &&
                point.y <= menuButtonView.frame.origin.y + menuButtonView.frame.size.height) {
				if ([UserData instance].sound) {
					AudioServicesPlaySystemSound(buttonSound);
				}
				[levelViewController stopPulsating];
				[[UserData instance] store];
				[[iFroggiAppDelegate instance] showMenu];
			}
		}		
	}
	menuButtonView.hidden = YES;
	arrowLeft.image = [[ImageCache instance] getImage:IMAGE_ARROW_LEFT];
	arrowRight.image = [[ImageCache instance] getImage:IMAGE_ARROW_RIGHT];
}

- (void)dealloc {
    [super dealloc];
}

@end
