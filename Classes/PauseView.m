//
//  OptionView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "iFroggiAppDelegate.h"
#import "PauseView.h"
#import "LakeView.h"
#import "UserData.h"
#import "MusicHandler.h"
#import "ImageCache.h"

@implementation PauseView

@synthesize blackView, pauseTitleView, lakeView, exitButtonView, continueButtonView, pulsate, shouldPulsate;

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
	shouldPulsate = NO;
	pulsate = NO;
}

- (void)reload {
	UserData *userData = [UserData instance];
	optionOnViews[0].image  = userData.music == YES ? optionOn[0] : optionOn[1];
	optionOffViews[0].image = userData.music == NO  ? optionOff[0] : optionOff[1];
	optionOnViews[1].image  = userData.sound == YES ? optionOn[0] : optionOn[1];
	optionOffViews[1].image = userData.sound == NO  ? optionOff[0] : optionOff[1];
	optionOnViews[2].image  = userData.vibration == YES ? optionOn[0] : optionOn[1];
	optionOffViews[2].image = userData.vibration == NO  ? optionOff[0] : optionOff[1];
	shouldPulsate = YES;
	if (!pulsate) {
		[self shrinkPauseButton];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
	UserData *userData = [UserData instance];
	// Music
	if (point.x >= 119 && point.x <= 300 && point.y >= 111 && point.y <= 141) { 
		if (userData.music == NO) {
			userData.music = YES;
			[[MusicHandler instance] playGameMusic];
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
	if (point.x >= 117 && point.x <= 300 && point.y >= 176 && point.y <= 196) { 
		if (userData.sound == NO) {
			userData.sound = YES;
			[[MusicHandler instance] playGameAmbience];
			optionOnViews[1].image = optionOn[0];
			optionOffViews[1].image = optionOff[1];
		} else {
			userData.sound = NO;
			[[MusicHandler instance] stopSound];
			optionOnViews[1].image = optionOn[1];
			optionOffViews[1].image = optionOff[0];
		}
		if (userData.sound) {
			AudioServicesPlaySystemSound(button2Sound);
		}
	}
	// Vibration
	if (point.x >= 114 && point.x <= 350 && point.y >= 236 && point.y <= 256) { 
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
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
	exitButtonView.hidden = YES;
	continueButtonView.hidden = YES;
	// Exit
	if (point.x >= exitButtonView.frame.origin.x && point.y >= exitButtonView.frame.origin.y && 
		point.x <= exitButtonView.frame.origin.x + exitButtonView.frame.size.width && point.y <= exitButtonView.frame.origin.y + exitButtonView.frame.size.height) {
		exitButtonView.hidden = NO;
	}
	// Continue
	if (point.x >= continueButtonView.frame.origin.x && point.y >= continueButtonView.frame.origin.y && 
		point.x <= continueButtonView.frame.origin.x + continueButtonView.frame.size.width && point.y <= continueButtonView.frame.origin.y + continueButtonView.frame.size.height) {
		continueButtonView.hidden = NO;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
	UserData *userData = [UserData instance];
	// Exit
	if (point.x >= exitButtonView.frame.origin.x && point.y >= exitButtonView.frame.origin.y && 
		point.x <= exitButtonView.frame.origin.x + exitButtonView.frame.size.width && point.y <= exitButtonView.frame.origin.y + exitButtonView.frame.size.height) {
		[userData store];
		if (userData.sound) {
			AudioServicesPlaySystemSound(button1Sound);
		}
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Exit Game?" message:@"Do you really want to exit game?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    if ([UserData instance].sound) {
                                                        AudioServicesPlaySystemSound(button1Sound);
                                                    }
                                                    [[UserData instance] clearHighscore];
                                                    [lakeView exit];
                                                }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"No"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction * action) {
                                                    if ([UserData instance].sound) {
                                                        AudioServicesPlaySystemSound(button1Sound);
                                                    }
                                                }]];
        [[[[iFroggiAppDelegate instance] window] rootViewController] presentViewController:alert animated:YES completion:nil];
    }
	// Continue
	if (point.x >= continueButtonView.frame.origin.x && point.y >= continueButtonView.frame.origin.y && 
		point.x <= continueButtonView.frame.origin.x + continueButtonView.frame.size.width && point.y <= continueButtonView.frame.origin.y + continueButtonView.frame.size.height) {
		[userData store];
		if (userData.sound) {
			AudioServicesPlaySystemSound(button1Sound);
		}
		shouldPulsate = NO;
		[lakeView resume];
	}
	exitButtonView.hidden = YES;
	continueButtonView.hidden = YES;
}

- (void)shrinkPauseButton {
	if (!shouldPulsate) {
		pulsate = NO;
		return;
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growPauseButton)];
	pauseTitleView.transform = CGAffineTransformMakeScale(0.8, 0.8);
	[UIView commitAnimations];
	pulsate = YES;
}

- (void)growPauseButton {
	if (!shouldPulsate) {
		pulsate = NO;
		return;
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(shrinkPauseButton)];
	pauseTitleView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
	pulsate = YES;
}

- (void)stopPulsating {
	shouldPulsate = NO;
}

- (void)dealloc {
    [super dealloc];
}

@end
