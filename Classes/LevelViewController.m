//
//  LevelViewController.m
//  iFroggi
//
//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "LevelViewController.h"
#import "iFroggiAppDelegate.h"
#import "NumberView.h"
#import "UserData.h"
#import "GameHelper.h"
#import "ImageCache.h"

@implementation LevelViewController

@synthesize levelNumber1, levelNumber2, speedNumber1, speedNumber2, sizeNumber1, sizeNumber2, levelImage1, levelImage2, leftArrow, rightArrow, inTransition, inMove, swap, shouldPulsate, pulsate;

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

- (void)awakeFromNib {
    [super awakeFromNib];
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"woosh1" ofType:@"caf"]], &wooshSound1);
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"woosh2" ofType:@"caf"]], &wooshSound2);	
	for (int i = 0; i < 10; i++) {
		levelType[i] = [[ImageCache instance] getImage:IMAGE_LEVEL andIndex:i+1];
	}
}

- (void)initLevel {
	if ([UserData instance].level == [UserData instance].maxLevel) {
		rightArrow.alpha = 0.0;
	} else {
		rightArrow.alpha = 1.0;
	}
	if ([UserData instance].level == 1) {
		leftArrow.alpha = 0;
	} else {
		leftArrow.alpha = 1.0;
	}
	[UserData instance].levelType = ([UserData instance].level-1) % 10 + 1;
	levelImage1.transform = CGAffineTransformIdentity;
	levelImage1.image = levelType[[UserData instance].levelType-1];
	levelNumber1.transform = CGAffineTransformIdentity; 
	levelNumber1.posY = 8;
	levelNumber1.type = TYPE_LARGE;
	levelNumber1.alignX = ALIGN_X_CENTER;
	[levelNumber1 setNumber:[UserData instance].level];
	levelImage2.transform = CGAffineTransformIdentity;
	levelImage2.image = levelType[[UserData instance].levelType-1];
	levelNumber2.transform = CGAffineTransformIdentity; 
	levelNumber2.posY = 8;
	levelNumber2.type = TYPE_LARGE;
	levelNumber2.alignX = ALIGN_X_CENTER;
	[levelNumber2 setNumber:[UserData instance].level];
	if (swap) {
		levelImage2.alpha = 1.0;
	} else {
		levelImage1.alpha = 1.0;		
	}	
	
	[[UserData instance] setSpeed:([UserData instance].level-1) / 10 + 1];
	speedNumber1.posY = 8;
	speedNumber1.type = TYPE_MEDIUM;
	speedNumber1.alignX = ALIGN_X_LEFT;
	[speedNumber1 setNumber:[UserData instance].speed];	
	speedNumber2.posY = 8;
	speedNumber2.type = TYPE_MEDIUM;
	speedNumber2.alignX = ALIGN_X_LEFT;
	[speedNumber2 setNumber:[UserData instance].speed];	
	
	[UserData instance].size = ([UserData instance].level-1) / 10 + 5;
	sizeNumber1.posY = 6;
	sizeNumber1.type = TYPE_MEDIUM;
	sizeNumber1.alignX = ALIGN_X_LEFT;
	[sizeNumber1 setNumber:[UserData instance].size];	
	sizeNumber2.posY = 6;
	sizeNumber2.type = TYPE_MEDIUM;
	sizeNumber2.alignX = ALIGN_X_LEFT;
	[sizeNumber2 setNumber:[UserData instance].size];	
	
	shouldPulsate = YES;
	if (!pulsate) {
		[self pulsateShrink];
	}
}

- (void)switchStartEnd {
	if (inMove) {
		return;
	}
	if ([UserData instance].level >= 1 && [UserData instance].level < [UserData instance].maxLevel) {
		[UserData instance].level = [UserData instance].maxLevel;
		[self flow:YES];
	} else if ([UserData instance].level == [UserData instance].maxLevel && [UserData instance].level > 1) {
		[UserData instance].level = 1;
		[self flow:NO];
	}
}

- (void)switchStart {
	if (inMove) {
		return;
	}
	if ([UserData instance].level > 1) {
		[UserData instance].level = 1;
		[self flow:YES];
	}
}

- (void)switchEnd {
	if (inMove) {
		return;
	}
	if ([UserData instance].level < [UserData instance].maxLevel) {
		[UserData instance].level = [UserData instance].maxLevel;
		[self flow:YES];
	}
}

- (void)increaseLevel {
	if (inMove) {
		return;
	}
	if ([UserData instance].level < [UserData instance].maxLevel) {
		[UserData instance].level += 1;
		[self flow:YES];
	}
}

- (void)decreaseLevel {
	if (inMove) {
		return;
	}
	if ([UserData instance].level > 1) {
		[UserData instance].level -= 1;
		[self flow:NO];
	}
}


- (void)increaseLevelByTen {
	if (inMove) {
		return;
	}
	if ([UserData instance].level < [UserData instance].maxLevel) {
		[UserData instance].level += 10;
		if ([UserData instance].level > [UserData instance].maxLevel) {
			[UserData instance].level = [UserData instance].maxLevel;
		}
		[self flow:YES];
	}
}

- (void)decreaseLevelByTen {
	if (inMove) {
		return;
	}
	if ([UserData instance].level > 1) {
		[UserData instance].level -= 10;
		if ([UserData instance].level < 1) {
			[UserData instance].level = 1;
		}
		[self flow:NO];
	}
}

	
- (void)flow:(BOOL)left {
	[UserData instance].levelType = ([UserData instance].level-1) % 10 + 1;
	int newSpeed = ([UserData instance].level-1) / 10 + 1;
	int newSize = ([UserData instance].level-1) / 10 + 5;
	if (swap) {
		levelImage1.image = levelType[[UserData instance].levelType-1];
		if (left) {
			levelImage1.frame = CGRectMake([GameHelper getScreenWidth]+levelImage1.frame.size.width / 2, levelImage1.frame.origin.y, levelImage1.frame.size.width, levelImage1.frame.size.height);
		} else {
			levelImage1.frame = CGRectMake(-levelImage1.frame.size.width, levelImage1.frame.origin.y, levelImage1.frame.size.width, levelImage1.frame.size.height);
		}
		levelImage1.alpha = 0.0;
		levelNumber1.transform = CGAffineTransformMakeScale(0.01, 0.01);
		levelNumber1.alpha = 0.0;
		[levelNumber1 setNumber:[UserData instance].level];
		if ([UserData instance].speed != newSpeed) {
			speedNumber1.transform = CGAffineTransformMakeScale(0.01, 0.01);
			speedNumber1.alpha = 0.0;
			[speedNumber1 setNumber:newSpeed];
		} else {
			speedNumber1.transform = CGAffineTransformIdentity;
			speedNumber1.alpha = 1.0;
			[speedNumber1 setNumber:[UserData instance].speed];
			speedNumber2.transform = CGAffineTransformMakeScale(0.01, 0.01);
			speedNumber2.alpha = 0.0;
		}
		if ([UserData instance].size != newSize) {
			sizeNumber1.transform = CGAffineTransformMakeScale(0.01, 0.01);
			sizeNumber1.alpha = 0.0;
			[sizeNumber1 setNumber:newSize];
		} else {
			sizeNumber1.transform = CGAffineTransformIdentity;
			sizeNumber1.alpha = 1.0;
			[sizeNumber1 setNumber:[UserData instance].size];
			sizeNumber2.transform = CGAffineTransformMakeScale(0.01, 0.01);
			sizeNumber2.alpha = 0.0;
		}
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(transitionEnded)];
		levelImage1.frame = CGRectMake(levelImage2.frame.origin.x, levelImage2.frame.origin.y, levelImage2.frame.size.width, levelImage2.frame.size.height);
		levelImage1.alpha = 1.0;
		if (left) {
			levelImage2.frame = CGRectMake(-levelImage2.frame.size.width, levelImage2.frame.origin.y, levelImage2.frame.size.width, levelImage2.frame.size.height);
		} else {
			levelImage2.frame = CGRectMake([GameHelper getScreenWidth]+levelImage2.frame.size.width / 2, levelImage2.frame.origin.y, levelImage2.frame.size.width, levelImage2.frame.size.height);
		}
		levelImage2.alpha = 0.0;
		levelNumber1.transform = CGAffineTransformIdentity;
		levelNumber1.alpha = 1.0;
		levelNumber2.transform = CGAffineTransformMakeScale(0.01, 0.01);
		levelNumber2.alpha = 0.0;
		if ([UserData instance].speed != newSpeed) {
			[[UserData instance] setSpeed:newSpeed];
			speedNumber1.transform = CGAffineTransformIdentity;
			speedNumber1.alpha = 1.0;
			speedNumber2.transform = CGAffineTransformMakeScale(0.01, 0.01);
			speedNumber2.alpha = 0.0;
		}
		if ([UserData instance].size != newSize) {
			[UserData instance].size = newSize;
			sizeNumber1.transform = CGAffineTransformIdentity;
			sizeNumber1.alpha = 1.0;
			sizeNumber2.transform = CGAffineTransformMakeScale(0.01, 0.01);
			sizeNumber2.alpha = 0.0;
		}
		if ([UserData instance].level == [UserData instance].maxLevel) {
			rightArrow.alpha = 0.0;
		} else {
			rightArrow.alpha = 1.0;
		}
		if ([UserData instance].level == 1) {
			leftArrow.alpha = 0.0;
		} else {
			leftArrow.alpha = 1.0;
		}
		[UIView	commitAnimations];		
	} else {
		levelImage2.image = levelType[[UserData instance].levelType-1];
		if (left) {
			levelImage2.frame = CGRectMake([GameHelper getScreenWidth]+levelImage2.frame.size.width / 2, levelImage2.frame.origin.y, levelImage2.frame.size.width, levelImage2.frame.size.height);
		} else {
			levelImage2.frame = CGRectMake(-levelImage2.frame.size.width, levelImage2.frame.origin.y, levelImage2.frame.size.width, levelImage2.frame.size.height);
		}
		levelImage2.alpha = 0.0;
		levelNumber2.transform = CGAffineTransformMakeScale(0.01, 0.01);
		levelNumber2.alpha = 0.0;
		[levelNumber2 setNumber:[UserData instance].level];
		if ([UserData instance].speed != newSpeed) {
			speedNumber2.transform = CGAffineTransformMakeScale(0.01, 0.01);
			speedNumber2.alpha = 0.0;
			[speedNumber2 setNumber:newSpeed];
		} else {
			speedNumber2.transform = CGAffineTransformIdentity;
			speedNumber2.alpha = 1.0;
			[speedNumber2 setNumber:[UserData instance].speed];
			speedNumber1.transform = CGAffineTransformMakeScale(0.01, 0.01);
			speedNumber1.alpha = 0.0;
		}
		if ([UserData instance].size != newSize) {
			sizeNumber2.transform = CGAffineTransformMakeScale(0.01, 0.01);
			sizeNumber2.alpha = 0.0;
			[sizeNumber2 setNumber:newSize];
		}  else {
			sizeNumber2.transform = CGAffineTransformIdentity;
			sizeNumber2.alpha = 1.0;
			[sizeNumber2 setNumber:[UserData instance].size];
			sizeNumber1.transform = CGAffineTransformMakeScale(0.01, 0.01);
			sizeNumber1.alpha = 0.0;
		}
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(transitionEnded)];
		levelImage2.frame = CGRectMake(levelImage1.frame.origin.x, levelImage1.frame.origin.y, levelImage1.frame.size.width, levelImage1.frame.size.height);
		levelImage2.alpha = 1.0;
		if (left) {
			levelImage1.frame = CGRectMake(-levelImage1.frame.size.width, levelImage1.frame.origin.y, levelImage1.frame.size.width, levelImage1.frame.size.height);
		} else {
			levelImage1.frame = CGRectMake([GameHelper getScreenWidth]+levelImage1.frame.size.width / 2, levelImage1.frame.origin.y, levelImage1.frame.size.width, levelImage1.frame.size.height);
		}
		levelImage1.alpha = 0.0;
		levelNumber2.transform = CGAffineTransformIdentity;
		levelNumber2.alpha = 1.0;
		levelNumber1.transform = CGAffineTransformMakeScale(0.01, 0.01);
		levelNumber1.alpha = 0.0;
		if ([UserData instance].speed != newSpeed) {
			[[UserData instance] setSpeed:newSpeed];
			speedNumber2.transform = CGAffineTransformIdentity;
			speedNumber2.alpha = 1.0;
			speedNumber1.transform = CGAffineTransformMakeScale(0.01, 0.01);
			speedNumber1.alpha = 0.0;
		}
		if ([UserData instance].size != newSize) {
			[UserData instance].size = newSize;
			sizeNumber2.transform = CGAffineTransformIdentity;
			sizeNumber2.alpha = 1.0;
			sizeNumber1.transform = CGAffineTransformMakeScale(0.01, 0.01);
			sizeNumber1.alpha = 0.0;
		}
		if ([UserData instance].level == [UserData instance].maxLevel) {
			rightArrow.alpha = 0.0;
		} else {
			rightArrow.alpha = 1.0;
		}
		if ([UserData instance].level == 1) {
			leftArrow.alpha = 0.0;
		} else {
			leftArrow.alpha = 1.0;
		}
		[UIView	commitAnimations];
	}
	[[UserData instance] setSpeed:newSpeed];
	[UserData instance].size = newSize;
	inMove = YES;
	if ([UserData instance].sound) {
		AudioServicesPlaySystemSound(wooshSound1);
	}
}

- (void)transitionEnded {
	if (swap) {
		swap = NO;
	} else {
		swap = YES;
	}
	inMove = NO;
	if (!pulsate) {
		[self pulsateShrink];
	}
}

- (void)pulsateShrink {
	if (inMove || !shouldPulsate) {
		pulsate = NO;
		return;
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(pulsateGrow)];
	if (swap) {
		levelImage2.transform = CGAffineTransformMakeScale(0.9, 0.9);
	} else {
		levelImage1.transform = CGAffineTransformMakeScale(0.9, 0.9);		
	}	
	[UIView	commitAnimations];
	pulsate = YES;
}

- (void)pulsateGrow {
	if (inMove || !shouldPulsate) {
		pulsate = NO;
		return;
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(pulsateShrink)];
	if (swap) {
		levelImage2.transform = CGAffineTransformIdentity;
	} else {
		levelImage1.transform = CGAffineTransformIdentity;
	}	
	[UIView	commitAnimations];
	pulsate = YES;
}

- (void)selectGrowAndFadeOut {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(selectEnded)];
	if (swap) {
		levelImage2.transform = CGAffineTransformMakeScale(2.0, 2.0);
		levelImage2.alpha = 0.0;
	} else {
		levelImage1.transform = CGAffineTransformMakeScale(2.0, 2.0);
		levelImage1.alpha = 0.0;
	}
	[UIView	commitAnimations];	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	if (swap) {
		levelNumber2.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0.0, 45.0), CGAffineTransformMakeScale(1.5, 1.5));
		
	} else {
		levelNumber1.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0.0, 45.0), CGAffineTransformMakeScale(1.5, 1.5));
	}
	[UIView	commitAnimations];	
	if ([UserData instance].sound) {
		AudioServicesPlaySystemSound(wooshSound2);
	}
}

- (void)selectEnded {
	[[iFroggiAppDelegate instance] showGame];
}

- (void)stopPulsating {
	shouldPulsate = NO;
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

@end

