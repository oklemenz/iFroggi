//
//  UserData.m
//  iFroggi
//
//  Created by Oliver Klemenz on 28.06.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "UserData.h"
#import "LakeView.h"
#import "HighscoreEntry.h"

@implementation UserData

@synthesize level, maxLevel, lives, score, speed, size, gameStarted, newLifePoints, levelType, previousScore, gameOver, maxDiamonds, maxButterflies;
@synthesize highscore, music, sound, vibration, speedSqrt, time, diamonds, butterflies, rows, columns;

- (id)init {
    if (self = [super init]) {
		[self load];
    }
    return self;
}

+ (UserData *)instance {
	static UserData *_instance;
	@synchronized(self) {
		if (!_instance) {
			_instance = [[UserData alloc] init];
		}
	}
	return _instance;
}

- (void)store {
	NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
	[preferences setInteger:1 forKey:@"init"];
	[preferences setInteger:level forKey:@"level"];
	[preferences setInteger:maxLevel forKey:@"maxLevel"];
	[preferences setInteger:lives forKey:@"lives"];
	[preferences setInteger:score forKey:@"score"];
	[preferences setInteger:speed forKey:@"speed"];
	[preferences setInteger:size forKey:@"size"];
	[preferences setBool:gameStarted forKey:@"gameStarted"];
	[preferences setInteger:newLifePoints forKey:@"newLifePoints"];
	
	NSMutableData *highscoreData = [NSMutableData data];
	NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:highscoreData];
	[encoder encodeObject:highscore forKey:@"highscore"];
	[encoder finishEncoding];
	[encoder release];
	
	[preferences setObject:highscoreData forKey:@"highscore"];
	[preferences setBool:music forKey:@"music"];
	[preferences setBool:sound forKey:@"sound"];
	[preferences setBool:vibration forKey:@"vibration"];
	[preferences synchronize];
	rows = size;
	columns = size;	
}

- (void)load {
	NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
	if ([preferences integerForKey:@"init"] == 1) {
		level = (int)[preferences integerForKey:@"level"];
		maxLevel = (int)[preferences integerForKey:@"maxLevel"];
		lives = (int)[preferences integerForKey:@"lives"];
		score = (int)[preferences integerForKey:@"score"];
		speed = (int)[preferences integerForKey:@"speed"];
		size = (int)[preferences integerForKey:@"size"];
		gameStarted = [preferences boolForKey:@"gameStarted"];
		newLifePoints = (int)[preferences integerForKey:@"newLifePoints"];
		
		NSData *highscoreData = (NSData *)[preferences objectForKey:@"highscore"];
		NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:highscoreData];
		highscore = [[NSMutableArray alloc] initWithArray:[[decoder decodeObjectForKey:@"highscore"] retain] copyItems:YES];
		[decoder finishDecoding];
		[decoder release];
		
		music = [preferences boolForKey:@"music"];
		sound = [preferences boolForKey:@"sound"];
		vibration = [preferences boolForKey:@"vibration"];
		
		[self derive];
	} else {
		highscore = [[NSMutableArray alloc] init];
		[self reset];
		music = YES;
		sound = YES;
		vibration = NO;
		maxLevel = 1;
	}
}

- (void)derive {
	speedSqrt = sqrt(speed);
	rows = size;
	columns = size;
	levelType = (level-1) % 10 + 1;
	[self clear];
}

- (void)reset {
	level = 1;
    if (maxLevel == 0) {
        maxLevel = 1;
    }
	lives = 3;
	score = 0;
	speed = 1;
	speedSqrt = 1;
	size = DEFAULT_LAKE_SIZE;
	gameStarted = NO;
	newLifePoints = NEW_LIFE_POINTS_BASE + NEW_LIFE_POINTS;
	gameOver = NO;
	[self derive];
	[self store];
}

- (void)clear {
	[self resetTime];
	previousScore = 0;
	diamonds = 0;
	butterflies = 0;
	maxDiamonds = 4;
	maxButterflies = 15 + 5 * speed;
}

- (int)getSpeed {
    return speed;
}

- (void)setSpeed:(int)aSpeed {
    speed = aSpeed;
    speedSqrt = sqrt(speed);
}

- (void)resetTime {
	time = 99;
}

- (NSMutableArray *)getHighscore {
	return highscore;
}

- (int)isScoreInHighscore {
	int i = 0;
	for (HighscoreEntry *entry in highscore) {
		if (self.score > entry.score) {
			return i;
		}
		i++;
		if (i == 10) {
			return -1;
		}
	}
	return i;
}

- (void)addScoreForName:(NSString *)name {
	if (name && ![name isEqualToString:@""]) {
		int scoreEntered = NO;
		HighscoreEntry *newEntry = [[HighscoreEntry alloc] initWithName:name andScore:self.score];
		int i = 0;
		for (HighscoreEntry *entry in [[NSMutableArray alloc] initWithArray:highscore]) {
			if (self.score > entry.score) {
				[highscore insertObject:newEntry atIndex:i];
				scoreEntered = YES;
				break;
			}
			i++;
		}
		if (!scoreEntered && [highscore count] < 10) {
			[highscore addObject:newEntry];
		}
		for (i = (int)[highscore count]-1; i >= 10; i--) {
			[highscore removeObjectAtIndex:i];
		}
		[newEntry release];
	}
}

- (void)clearHighscore {
	[highscore removeAllObjects];
}

@end
