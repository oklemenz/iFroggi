//
//  CopyrightViewController.h
//  iFroggi
//
//  Created by Oliver Klemenz on 18.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CopyrightView;

@interface CopyrightViewController : UIViewController {
	UIImageView *presentsImageView;
	CopyrightView *copyrightImageView;
	NSTimer *timer;
}

- (void)showPresents;
- (void)showCopyright;
- (void)showMenu;

@end
