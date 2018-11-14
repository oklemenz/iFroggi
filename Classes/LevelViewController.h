//
//  LevelViewController.h
//  iFroggi
//
//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class NumberView;

@interface LevelViewController : UITableViewController {

	IBOutlet NumberView *levelNumber1;
	IBOutlet NumberView *levelNumber2;
	IBOutlet NumberView *speedNumber1;
	IBOutlet NumberView *speedNumber2;
	IBOutlet NumberView *sizeNumber1;
	IBOutlet NumberView *sizeNumber2;
	IBOutlet UIImageView *levelImage1;
	IBOutlet UIImageView *levelImage2;
	IBOutlet UIImageView *leftArrow;
	IBOutlet UIImageView *rightArrow;

	BOOL inTransition;
	BOOL inMove;
	BOOL pulsate;
	BOOL shouldPulsate;
	BOOL swap;
	
	UIImage *levelType[10];
	
	SystemSoundID wooshSound1;
	SystemSoundID wooshSound2;
	
}

@property(nonatomic, retain) IBOutlet UIView *levelNumber1;
@property(nonatomic, retain) IBOutlet UIView *levelNumber2;
@property(nonatomic, retain) IBOutlet UIView *speedNumber1;
@property(nonatomic, retain) IBOutlet UIView *speedNumber2;
@property(nonatomic, retain) IBOutlet UIView *sizeNumber1;
@property(nonatomic, retain) IBOutlet UIView *sizeNumber2;
@property(nonatomic, retain) IBOutlet UIImageView *levelImage1;
@property(nonatomic, retain) IBOutlet UIImageView *levelImage2;
@property(nonatomic, retain) IBOutlet UIImageView *leftArrow;
@property(nonatomic, retain) IBOutlet UIImageView *rightArrow;

@property BOOL inTransition;
@property BOOL inMove;
@property BOOL swap;
@property BOOL shouldPulsate;
@property BOOL pulsate;

- (void)initLevel;
- (void)switchStartEnd;
- (void)switchStart;
- (void)switchEnd;
- (void)increaseLevel;
- (void)decreaseLevel;
- (void)increaseLevelByTen;
- (void)decreaseLevelByTen;

- (void)flow:(BOOL)left;
- (void)pulsateShrink;
- (void)pulsateGrow;
- (void)selectGrowAndFadeOut;

- (void)stopPulsating;

@end
