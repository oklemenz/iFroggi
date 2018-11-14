//
//  CopyrightView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CopyrightViewController;

@interface CopyrightView : UIImageView {
	IBOutlet CopyrightViewController *copyrightViewController;
	
}

@property(nonatomic, retain) IBOutlet CopyrightViewController *copyrightViewController;

@end
