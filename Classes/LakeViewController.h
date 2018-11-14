//
//  iFroggiViewController.h
//  iFroggi
//
//  Created by Oliver Klemenz on 06.01.10.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LakeView;

@interface LakeViewController : UIViewController {
	IBOutlet LakeView *lakeView;
}

@property(nonatomic, retain) IBOutlet LakeView *lakeView;

- (void)prepare;
- (void)startGame;

@end

