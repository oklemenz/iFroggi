//
//  OptionViewController.m
//  iFroggi
//
//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "MenuViewController.h"
#import	"iFroggiAppDelegate.h"
#import "MenuView.h"
#import "OptionView.h"
#import "GameHelper.h"

@implementation MenuViewController

@synthesize inOptions, inTransition, menuView, optionView;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initMenuDialog {
	[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(showMenuDialog) userInfo:NULL repeats:NO];
}

- (void)showMenuDialog {
	inTransition = YES;
	menuView.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView	setAnimationDidStopSelector:@selector(hideOptionDialog)];
	menuView.alpha = 1.0;
	optionView.alpha = 0.0;
	[UIView	commitAnimations];	
}

- (void)showOptionDialog {
	inTransition = YES;
	inOptions = YES;
	optionView.hidden = NO;
	[optionView reload];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView	setAnimationDidStopSelector:@selector(hideMenuDialog)];
	optionView.alpha = 1.0;
	menuView.alpha = 0.0;
	[UIView	commitAnimations];	
}		

- (void)hideMenuDialog {
	menuView.hidden = YES;
	inOptions = YES;
	inTransition = NO;
}

- (void)hideOptionDialog {
	optionView.hidden = YES;
	inOptions = NO;
	inTransition = NO;
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
