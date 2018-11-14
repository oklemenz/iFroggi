//
//  NumberView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 20.07.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

static int TYPE_SMALL  = 1;
static int TYPE_MEDIUM = 2;
static int TYPE_LARGE  = 3;

static int ALIGN_X_LEFT   = 1;
static int ALIGN_X_CENTER = 2;
static int ALIGN_X_RIGHT  = 3;

static int ALIGN_Y_TOP    = 1;
static int ALIGN_Y_MIDDLE = 2;
static int ALIGN_Y_BOTTOM = 3;

static CGFloat NUMBER_SPACE_SMALL  = -5;
static CGFloat NUMBER_SPACE_MEDIUM = -2;
static CGFloat NUMBER_SPACE_LARGE  = -0;

static CGFloat NUMBER_SPACE_WIDTH  = 0;

@interface NumberView : UIView {
	int type;
	int alignX;
	int alignY;
	CGFloat posX;
	CGFloat posY;
	CGFloat maxWidth;
	CGFloat maxHeight;
	
	UIImage *frontImage;
	int frontImageOffsetX;
	int frontImageOffsetY;
	int num;	
	int maxNum;
}

@property int type;
@property int alignX;
@property int alignY;
@property CGFloat posX;
@property CGFloat posY;
@property CGFloat maxWidth;
@property CGFloat maxHeight;

@property(nonatomic, retain) UIImage *frontImage;
@property int frontImageOffsetX;
@property int frontImageOffsetY;
@property int num;
@property int maxNum;

- (id)initWithType:(int)aType andX:(CGFloat)x andY:(CGFloat)y andXAlign:(int)xAlign andYAlign:(int)yAlign;
- (id)initWithType:(int)aType andX:(CGFloat)x andY:(CGFloat)y andWidth:(CGFloat)w andHeight:(CGFloat)h andXAlign:(int)xAlign andYAlign:(int)yAlign;
- (void)setNumber:(int)number;
- (void)setNumber:(int)number andMaxNumber:(int)maxNumber;
- (void)setImage:(UIImage *)image;
- (void)setImage:(UIImage *)image andOffsetX:(int)x andOffsetY:(int)y;

@end
