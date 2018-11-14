//
//  CopyrightView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "CopyrightView.h"
#import "CopyrightViewController.h"
#import "MusicHandler.h"
#import "iFroggiAppDelegate.h"
#import "MenuViewController.h"

@implementation CopyrightView

@synthesize copyrightViewController;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![iFroggiAppDelegate instance].menuViewController.inTransition) {
        [copyrightViewController showMenu];
    }
}

- (void)dealloc {
    [super dealloc];
}


@end
