//
//  WaterReedMirrorView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 25.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class WaterReedView;

@interface WaterReedMirrorView : UIImageView {
	int type;

	BOOL shouldStop;
	BOOL stopped;
	double timestamp;
	float waitTime;
	
	WaterReedView *waterReedView;
}

@property int type;
@property BOOL shouldStop;
@property BOOL stopped;
@property double timestamp;
@property float waitTime;

@property(nonatomic, retain) WaterReedView *waterReedView;

- (id)initWithRow:(int)i andColumn:(int)j andWaterReed:(WaterReedView *)waterReed;
- (void)resetWithRow:(int)i andColumn:(int)j;

- (void)wait;
- (void)swayLeft;
- (void)swayRight;

- (void)update:(double)ts;
- (void)start;
- (void)stop;
- (void)resume;
- (BOOL)isNotStopped;

@end
