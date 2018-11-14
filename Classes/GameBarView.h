//
//  GameBarView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 26.09.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NumberView;

@interface GameBarView : UIView {
	
	NumberView *livesNumberView;
	NumberView *clockNumberView;
	NumberView *diamondNumberView;
	NumberView *butterflyNumberView;
	NumberView *scoreNumberView;

	UIImageView *frogFlagView;
	UIImageView *opponentFrogFlagView;
	
}

@property(nonatomic, retain) NumberView *livesNumberView;	
@property(nonatomic, retain) NumberView *clockNumberView;	
@property(nonatomic, retain) NumberView *diamondNumberView;	
@property(nonatomic, retain) NumberView *butterflyNumberView;
@property(nonatomic, retain) NumberView *scoreNumberView;	

@property(nonatomic, retain) UIImageView *frogFlagView;
@property(nonatomic, retain) UIImageView *opponentFrogFlagView;

- (void)update;

@end
