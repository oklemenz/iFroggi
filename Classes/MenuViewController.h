//
//  OptionViewController.h
//  iFroggi
//
//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuView;
@class OptionView;

@interface MenuViewController : UIViewController {
	BOOL inOptions;
	BOOL inTransition;
	IBOutlet MenuView *menuView;
	IBOutlet OptionView *optionView;
}

@property BOOL inOptions;
@property BOOL inTransition;
@property(nonatomic, retain) IBOutlet MenuView *menuView;
@property(nonatomic, retain) IBOutlet OptionView *optionView;

- (void)initMenuDialog;
- (IBAction)showMenuDialog;
- (IBAction)showOptionDialog;

@end
