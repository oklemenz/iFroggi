//
//  OptionView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "OptionView.h"
#import "MenuViewController.h"
#import "UserData.h"
#import "MusicHandler.h"
#import "ImageCache.h"

@implementation OptionView

@synthesize menuViewController, backButtonView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"button1" ofType:@"caf"]], &button1Sound);
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"button2" ofType:@"caf"]], &button2Sound);
	for (int i = 0; i < 2; i++) {
		optionOn[i] = [[ImageCache instance] getImage:IMAGE_OPTION_ON andIndex:i+1];
		optionOff[i] = [[ImageCache instance] getImage:IMAGE_OPTION_OFF andIndex:i+1];
	}
    for (int i = 0; i < 3; i++) {
		optionOnViews[i] = [[UIImageView alloc] initWithImage:optionOn[0]];
		optionOnViews[i].frame = CGRectMake(OPTION_ON_X_OFFSET[i], OPTION_ON_Y_OFFSET[i], optionOn[0].size.width, optionOn[0].size.height);
		[self addSubview:optionOnViews[i]];
		optionOffViews[i] = [[UIImageView alloc] initWithImage:optionOff[0]];
		optionOffViews[i].frame = CGRectMake(OPTION_OFF_X_OFFSET[i], OPTION_OFF_Y_OFFSET[i], optionOff[0].size.width, optionOff[0].size.height);
		[self addSubview:optionOffViews[i]];
	}
}

- (void)reload {
	UserData *userData = [UserData instance];
	optionOnViews[0].image  = userData.music == YES ? optionOn[0] : optionOn[1];
	optionOffViews[0].image = userData.music == NO  ? optionOff[0] : optionOff[1];
	optionOnViews[1].image  = userData.sound == YES ? optionOn[0] : optionOn[1];
	optionOffViews[1].image = userData.sound == NO  ? optionOff[0] : optionOff[1];
	optionOnViews[2].image  = userData.vibration == YES ? optionOn[0] : optionOn[1];
	optionOffViews[2].image = userData.vibration == NO  ? optionOff[0] : optionOff[1];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
	UserData *userData = [UserData instance];
	// Music
	if (point.x >= 19 && point.x <= 200 && point.y >= 55 && point.y <= 75) { 
		if (userData.music == NO) {
			userData.music = YES;
			[[MusicHandler instance] playMenuMusic];
			optionOnViews[0].image = optionOn[0];
			optionOffViews[0].image = optionOff[1];
		} else {
			userData.music = NO;
			[[MusicHandler instance] stopMusic];
			optionOnViews[0].image = optionOn[1];
			optionOffViews[0].image = optionOff[0];
		}
		if (userData.sound) {
			AudioServicesPlaySystemSound(button2Sound);
		}
	}
	// Sound
	if (point.x >= 17 && point.x <= 200 && point.y >= 110 && point.y <= 130) { 
		if (userData.sound == NO) {
			userData.sound = YES;
			optionOnViews[1].image = optionOn[0];
			optionOffViews[1].image = optionOff[1];
		} else {
			userData.sound = NO;
			optionOnViews[1].image = optionOn[1];
			optionOffViews[1].image = optionOff[0];
		}
		if (userData.sound) {
			AudioServicesPlaySystemSound(button2Sound);
		}
	}
	// Vibration
	if (point.x >= 14 && point.x <= 250 && point.y >= 170 && point.y <= 190) { 
		if (userData.vibration == NO) {
			userData.vibration = YES;
			optionOnViews[2].image = optionOn[0];
			optionOffViews[2].image = optionOff[1];
		} else {
			userData.vibration = NO;
			optionOnViews[2].image = optionOn[1];
			optionOffViews[2].image = optionOff[0];
		}
		if (userData.sound) {
			AudioServicesPlaySystemSound(button2Sound);
		}
	} else {
		[self touchesMoved:touches withEvent:event];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	backButtonView.hidden = YES;
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
	// Back
	if (point.x >= backButtonView.frame.origin.x - self.frame.origin.x &&
        point.y >= backButtonView.frame.origin.y - self.frame.origin.y &&
		point.x <= backButtonView.frame.origin.x - self.frame.origin.x + backButtonView.frame.size.width &&
        point.y <= backButtonView.frame.origin.y - self.frame.origin.y + backButtonView.frame.size.height) {
		backButtonView.hidden = NO;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!menuViewController.inTransition) {	
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint point = [touch locationInView:self];
		// Back
		if (point.x >= backButtonView.frame.origin.x - self.frame.origin.x &&
            point.y >= backButtonView.frame.origin.y - self.frame.origin.y &&
			point.x <= backButtonView.frame.origin.x - self.frame.origin.x + backButtonView.frame.size.width &&
            point.y <= backButtonView.frame.origin.y - self.frame.origin.y + backButtonView.frame.size.height) {
			if (menuViewController.inOptions == YES && menuViewController.inTransition == NO) {
				UserData *userData = [UserData instance];
				[userData store];
				if (userData.sound) {
					AudioServicesPlaySystemSound(button1Sound);
				}
				[menuViewController showMenuDialog];
			}
		}
	}
	backButtonView.hidden = YES;
}

- (void)dealloc {
    [super dealloc];
}

@end
