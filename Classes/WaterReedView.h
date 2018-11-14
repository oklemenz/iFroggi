//
//  WaterReedView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 25.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static CGFloat WATERREED_TOP[2]  = { 53, 55 };
static CGFloat WATERREED_LEFT[2] = { 75, 85 };

@interface WaterReedView : UIImageView {
	int type;	
	BOOL shouldStop;
	BOOL stopped;
}

@property int type;
@property BOOL shouldStop;
@property BOOL stopped;

- (id)initWithRow:(int)i andColumn:(int)j;
- (void)resetWithRow:(int)i andColumn:(int)j;

- (void)sway:(float)duration andAngle:(float)angle;

- (void)start;
- (void)stop;
- (void)resume;
- (BOOL)isNotStopped;

@end
