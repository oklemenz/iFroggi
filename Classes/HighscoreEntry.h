//
//  HighscoreEntry.h
//  iFroggi
//
//  Created by Oliver Klemenz on 05.11.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighscoreEntry : NSObject <NSCoding, NSCopying> {
	
	NSString *name;
	int score;
	
}

@property(nonatomic, retain) NSString *name;
@property int score;

- (id)initWithName:(NSString *)aName andScore:(int)aScore;

@end
