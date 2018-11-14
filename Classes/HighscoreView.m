//
//  HighscoreView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 26.09.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "HighscoreView.h"
#import "iFroggiAppDelegate.h"
#import "HighscoreViewController.h"
#import "EnterNameView.h"
#import "UserData.h"
#import "HighscoreEntry.h"
#import "ImageCache.h"
#import "NumberView.h"

@implementation HighscoreView

@synthesize highscoreViewController, enterNameView, okButtonView, backButtonView, clearButtonView, inNameEntering, newScorePos;

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
	okButtonView.image = [[ImageCache instance] getImage:IMAGE_OK];
	backButtonView.hidden = YES;
	clearButtonView.hidden = YES;
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
	// Ok
	if (inNameEntering &&
        point.x >= okButtonView.frame.origin.x + enterNameView.frame.origin.x &&
        point.y >= okButtonView.frame.origin.y + enterNameView.frame.origin.y &&
		point.x <= okButtonView.frame.origin.x + enterNameView.frame.origin.x + okButtonView.frame.size.width &&
        point.y <= okButtonView.frame.origin.y + enterNameView.frame.origin.y + okButtonView.frame.size.height) {
		okButtonView.image = [[ImageCache instance] getImage:IMAGE_OK_P];
	}
	// Back
	if (point.x >= backButtonView.frame.origin.x && point.y >= backButtonView.frame.origin.y && 
		point.x <= backButtonView.frame.origin.x + backButtonView.frame.size.width && point.y <= backButtonView.frame.origin.y + backButtonView.frame.size.height) {
		backButtonView.hidden = NO;
	}
	// Clear
	if (point.x >= clearButtonView.frame.origin.x && point.y >= clearButtonView.frame.origin.y && 
		point.x <= clearButtonView.frame.origin.x + clearButtonView.frame.size.width && point.y <= clearButtonView.frame.origin.y + clearButtonView.frame.size.height) {
		clearButtonView.hidden = NO;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
	// Ok
	if (inNameEntering &&
        point.x >= okButtonView.frame.origin.x + enterNameView.frame.origin.x &&
        point.y >= okButtonView.frame.origin.y + enterNameView.frame.origin.y &&
		point.x <= okButtonView.frame.origin.x + enterNameView.frame.origin.x + okButtonView.frame.size.width &&
        point.y <= okButtonView.frame.origin.y + enterNameView.frame.origin.y + okButtonView.frame.size.height) {
		if ([UserData instance].sound) {
			AudioServicesPlaySystemSound(buttonSound);
		}
		[enterNameView.textField resignFirstResponder];
		[self hideEnterName];
	}
	if (!highscoreViewController.inTransition) {
		// Back
		if (point.x >= backButtonView.frame.origin.x && point.y >= backButtonView.frame.origin.y && 
			point.x <= backButtonView.frame.origin.x + backButtonView.frame.size.width && point.y <= backButtonView.frame.origin.y + backButtonView.frame.size.height) {
			if ([UserData instance].sound) {
				AudioServicesPlaySystemSound(buttonSound);
			}
			[[UserData instance] store];
			[[iFroggiAppDelegate instance] showMenu];
		}
	}
	// Clear
	if (point.x >= clearButtonView.frame.origin.x && point.y >= clearButtonView.frame.origin.y && 
		point.x <= clearButtonView.frame.origin.x + clearButtonView.frame.size.width && point.y <= clearButtonView.frame.origin.y + clearButtonView.frame.size.height) {
		if ([UserData instance].sound) {
			AudioServicesPlaySystemSound(buttonSound);
		}
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you really want to clear highscores?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Clear Highscores"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * action) {
                                                    if ([UserData instance].sound) {
                                                        AudioServicesPlaySystemSound(buttonSound);
                                                    }
                                                    [[UserData instance] clearHighscore];
                                                    [self reset];
                                                }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction * action) {
                                                    if ([UserData instance].sound) {
                                                        AudioServicesPlaySystemSound(buttonSound);
                                                    }
                                                }]];
        
        [[[[iFroggiAppDelegate instance] window] rootViewController] presentViewController:alert animated:YES completion:nil];
    }
	okButtonView.image = [[ImageCache instance] getImage:IMAGE_OK];
	backButtonView.hidden = YES;
	clearButtonView.hidden = YES;
}

- (void)reset {
	newScorePos = -1;
	[self setNeedsDisplay];
}
			
- (void)drawRect:(CGRect)rect {
	UIFont *font = [UIFont fontWithName:@"Trebuchet-BoldItalic" size:14.0];
    NSDictionary *textAttributes = @{ NSFontAttributeName:font };

	CGContextRef context = UIGraphicsGetCurrentContext( );
	CGContextSetShouldAntialias(context, true);
	CGContextSetAllowsAntialiasing(context, true);
	CGContextSetShouldSmoothFonts(context, true);
	int i = 0;
	for (HighscoreEntry *entry in [[UserData instance] getHighscore]) {
		if (newScorePos >=0 && i == newScorePos) {
			CGContextSetRGBFillColor(context, 1, 1, 1, 1);
		} else {
			CGContextSetRGBFillColor(context, 0, 0, 0, 1);
		}
		NSString *line = [[NSString alloc] initWithFormat:@"%i.", i+1];
		[line drawAtPoint:CGPointMake(30, 45 + i*23) withAttributes:textAttributes];
		[line release];
        [entry.name drawAtPoint:CGPointMake(55, 45 + i*23) withAttributes:textAttributes];
		NSString *scoreString = [[NSString alloc] initWithFormat:@"%i", entry.score];
		CGSize size = [scoreString sizeWithAttributes:textAttributes];
		[scoreString drawAtPoint:CGPointMake(280 - size.width, 45 + i*23) withAttributes:textAttributes];
		[scoreString release];
		i++;
	}
	newScorePos = -1;
}

- (void)showEnterName {
	inNameEntering = YES;
	enterNameView.scoreView.posY = 6;
	enterNameView.scoreView.type = TYPE_SMALL;
	enterNameView.scoreView.alignX = ALIGN_X_CENTER;
	[enterNameView.scoreView setNumber:[UserData instance].score];
	enterNameView.hidden = NO;
	enterNameView.alpha = 0.0;
	enterNameView.blackView.alpha = 0.0;
	enterNameView.textField.text = @"";
	[enterNameView.textField becomeFirstResponder];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	enterNameView.alpha = 1.0;
	enterNameView.blackView.alpha = 0.3;
	[UIView commitAnimations];
}

- (void)hideEnterName {
	inNameEntering = NO;
	newScorePos = -1;
	if (![enterNameView.textField.text isEqualToString:@""]) {
		newScorePos = [[UserData instance] isScoreInHighscore];
		if (newScorePos >= 0)
		{
			[[UserData instance] addScoreForName:enterNameView.textField.text];
			[self setNeedsDisplay];
		}
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView	setAnimationDelegate:self];
	enterNameView.alpha = 0.0;
	enterNameView.blackView.alpha = 0.0;
	[UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[enterNameView.textField resignFirstResponder];
	return YES;
}

- (void)dealloc {
    [super dealloc];
}

@end
