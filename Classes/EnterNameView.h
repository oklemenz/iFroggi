//
//  EnterNameView.h
//  iFroggi
//
//  Created by Oliver Klemenz on 05.11.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HighscoreView, NumberView;

@interface EnterNameView : UIView {

    IBOutlet UIView *blackView;
    IBOutlet HighscoreView *highscoreView;
    IBOutlet NumberView *scoreView;
    IBOutlet UITextField *textField;

}

@property(nonatomic, retain) IBOutlet UIView *blackView;
@property(nonatomic, retain) IBOutlet HighscoreView *highscoreView;
@property(nonatomic, retain) IBOutlet NumberView *scoreView;
@property(nonatomic, retain) IBOutlet UITextField *textField;

@end
