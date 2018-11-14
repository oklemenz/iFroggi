//
//  StoneView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 18.04.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat STONE_TOP  = 17;
static CGFloat STONE_LEFT = 12;

@class ObjectView;

@interface StoneView : UIImageView {

	int posI;
	int posJ;
	int kind;
	
	ObjectView *flagView;
}

@property int posI;
@property int posJ;
@property int kind;

@property (nonatomic, retain) ObjectView *flagView;

- (id)initWithRow:(int)i andColumn:(int)j;
- (void)resetWithRow:(int)i andColumn:(int)j;

- (BOOL)checkObjectCatched;

@end
