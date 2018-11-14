//
//  UserData.h
//  iFroggi
//
//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject {

	// Stored
	int level;
	int maxLevel;
	int lives;
	int score;
	int speed;
	int size;
	BOOL gameStarted;
	int newLifePoints;

	NSMutableArray *highscore;
	
	BOOL music;
	BOOL sound;
	BOOL vibration;
	
	// Not stored
	float speedSqrt;
	int time;
	int diamonds;
	int butterflies;
	int rows;
	int columns;
	int levelType;
	int previousScore;
	BOOL gameOver;
	int maxDiamonds;
	int maxButterflies;
	
}

@property int level;
@property int maxLevel;
@property int lives;
@property int score;
@property(nonatomic) int speed;
@property int size;
@property BOOL gameStarted;
@property int newLifePoints;

@property(nonatomic, retain) NSMutableArray *highscore;

@property BOOL music;
@property BOOL sound;
@property BOOL vibration;

@property float speedSqrt;
@property int time;
@property int diamonds;
@property int butterflies;
@property int rows;
@property int columns;
@property int levelType;
@property int previousScore;
@property BOOL gameOver;
@property int maxDiamonds;
@property int maxButterflies;

- (id)init;
+ (UserData *)instance;

- (void)store;
- (void)load;
- (void)derive;
- (void)reset;
- (void)clear;
- (void)resetTime;
- (void)setSpeed:(int)aSpeed;

- (NSMutableArray *)getHighscore;
- (int)isScoreInHighscore;
- (void)addScoreForName:(NSString *)name;
- (void)clearHighscore;

@end
