//
//  EnterNameView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 05.11.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "EnterNameView.h"
#import "HighscoreView.h"
#import "NumberView.h"

@implementation EnterNameView

@synthesize blackView, highscoreView, scoreView, textField;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
