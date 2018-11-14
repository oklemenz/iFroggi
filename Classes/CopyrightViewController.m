//
//  CopyrightViewController.m
//  iFroggi
//
//  Created by Oliver Klemenz on 18.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "iFroggiAppDelegate.h"
#import "CopyrightViewController.h"
#import "CopyrightView.h"
#import "GameHelper.h"
#import "UserData.h"
#import "MusicHandler.h"
#import "ImageCache.h"

@implementation CopyrightViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidLoad];
	float duration = 3.0;
	if ([UserData instance].sound) {
		duration = 6.0;
		[[MusicHandler instance] playIntroMusic];		
	}
	timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(showPresents) userInfo:NULL repeats:NO];
}

- (void)showPresents {
	((UIImageView *)self.view).image = [[ImageCache instance] getImage:IMAGE_LAKE];
	presentsImageView = [[UIImageView alloc] initWithImage:[[ImageCache instance] getImage:IMAGE_PRESENTS]];
    presentsImageView.frame = self.view.bounds;
    presentsImageView.contentMode = UIViewContentModeCenter;
	presentsImageView.alpha = 0.0;
	[self.view addSubview:presentsImageView];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	presentsImageView.alpha = 1.0;
	[UIView	commitAnimations];
	timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showCopyright) userInfo:NULL repeats:NO];
	[[MusicHandler instance] playMenuMusic];
}

- (void)showCopyright {
	copyrightImageView = [[CopyrightView alloc] initWithImage:[[ImageCache instance] getImage:IMAGE_COPYRIGHT]];
    copyrightImageView.frame = self.view.bounds;
    copyrightImageView.contentMode = UIViewContentModeCenter;
	copyrightImageView.alpha = 0.0;
	[self.view addSubview:copyrightImageView];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	presentsImageView.alpha = 0.0;
	copyrightImageView.alpha = 1.0;
	[UIView	commitAnimations];
	timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showMenu) userInfo:NULL repeats:NO];
}

- (void)showMenu {
	[[MusicHandler instance] stopIntro];
	[timer invalidate];
	[copyrightImageView removeFromSuperview];
	[presentsImageView release];
	[copyrightImageView release];
	[[iFroggiAppDelegate instance] showMenu];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

@end
