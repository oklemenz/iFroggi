//
//  GrassView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 21.01.10.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

static CGFloat GRASS_OFFSET_TOP   = 13;
static CGFloat GRASS_OFFSET_LEFT  = 13;
static CGFloat GRASS_OFFSET_RIGHT = -5;

static CGFloat GRASS_MOVE_MAX      = 5;
static CGFloat GRASS_MIRROR_OFFSET = 10;

@interface GrassView : UIView {
	CGPoint lakePos;
}

@property CGPoint lakePos;

- (void)resetWithFrame:(CGRect)frame;
- (void)notifyAcceleration:(CMAcceleration)acceleration;

@end
