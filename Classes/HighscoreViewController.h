//
//  HighscoreViewController.h
//  iFroggi
//
//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HighscoreView;

@interface HighscoreViewController : UIViewController {
	
	IBOutlet HighscoreView *highscoreView;

	BOOL inTransition;
}

@property(nonatomic, retain) IBOutlet HighscoreView *highscoreView;

@property BOOL inTransition;

@end
