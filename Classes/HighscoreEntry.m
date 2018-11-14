//
//  HighscoreEntry.m
//  iFroggi
//
//  Created by Oliver Klemenz on 05.11.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "HighscoreEntry.h"

@implementation HighscoreEntry

@synthesize name, score;

- (id)initWithName:(NSString *)aName andScore:(int)aScore {
    if (self = [super init]) {
		self.name = aName;
		self.score = aScore;
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:name forKey:@"name"];
    [coder encodeInt:score forKey:@"score"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [[HighscoreEntry alloc] init];
    if (self != nil) {
        name = [coder decodeObjectForKey:@"name"];
        score = [coder decodeIntForKey:@"score"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
	HighscoreEntry *entry = [[[self class] allocWithZone:zone] init];
	entry.name  = self.name;
	entry.score = self.score;
	return entry;
}

@end
