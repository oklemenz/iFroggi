//
//  StoneView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 18.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "StoneView.h"
#import "WaterView.h"
#import "ImageCache.h"
#import "ObjectView.h"
#import "LakeView.h"
#import "GameBarView.h"
#import "UserData.h"

@implementation StoneView

@synthesize posI, posJ, kind, flagView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
	}
    return self;
}

- (id)initWithRow:(int)i andColumn:(int)j {
	if (self = [super initWithFrame:CGRectZero]) {
		[self resetWithRow:i andColumn:j];
		kind = -1;
		if (i == 0 && j == 0) {
			kind = KIND_FLAG_FROG;
		} else if (i == [UserData instance].rows - 1 && j == [UserData instance].columns - 1) {
			kind = KIND_FLAG_OPP_FROG;
		}
		if (kind != -1) {
			flagView = [[ObjectView alloc] initWithRow:i andColumn:j andType:TYPE_FLAG andKind:kind];
			[self addSubview:flagView];
		}
	}
    return self;
}

- (void)resetWithRow:(int)i andColumn:(int)j {
	posI = i;
	posJ = j;
	self.image = [[ImageCache instance] getImage:IMAGE_STONE];
	self.frame = CGRectMake(STONE_LEFT + j * WATER_WIDTH_2, STONE_TOP + i * WATER_HEIGHT_2, self.image.size.width, self.image.size.height);
}

- (BOOL)checkObjectCatched {
	if (!flagView.hidden) {
		flagView.hidden = YES;
		LakeView *lakeView = (LakeView *)[self superview];
		if (kind == KIND_FLAG_FROG) {
			[lakeView moveGameBarView:flagView atPoint:self.center toPoint:lakeView.gameBarView.frogFlagView.center];
		} else if (kind == KIND_FLAG_OPP_FROG) {
			[lakeView moveGameBarView:flagView atPoint:self.center toPoint:lakeView.gameBarView.opponentFrogFlagView.center];
		}
		return YES;
	} 
	return NO;
}

- (void)dealloc {
    [super dealloc];
}

@end
