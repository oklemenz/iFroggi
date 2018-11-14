//
//  WaterLayerView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 06.02.10.
//  Copyright 2010 KillerApp Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WaterLayerView : UIView {
	int index;
	NSMutableArray *water;
}

@property int index;

- (id)initWithFrame:(CGRect)frame andIndex:(int)i;
- (void)resetWithFrame:(CGRect)frame;

@end
