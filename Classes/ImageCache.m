//
//  ImageCache.m
//  iFroggi
//
//  Created by Oliver Klemenz on 03.11.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache

- (id)init {
	if (self = [super init]) {
		images = [[NSMutableDictionary alloc] init];
		NSString *key;
		// Number
		for (int i = 0; i < 10; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_SMALL_NUMBER, i];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_MEDIUM_NUMBER, i];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_LARGE_NUMBER, i];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
		}
		// Slash
		key = [[NSString alloc] initWithFormat:@"%@", IMAGE_SMALL_SLASH];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@", IMAGE_MEDIUM_SLASH];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@", IMAGE_LARGE_SLASH];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		// Fly
		for (int i = 0; i < 4; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_FLY, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
		}
		// Butterfly
		for (int i = 0; i < 14; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_BUTTERFLY, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
			key = [[NSString alloc] initWithFormat:@"%@%ix", IMAGE_BUTTERFLY, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
		}
		// Caterpillar
		for (int i = 0; i < 6; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_CATERPILLAR, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
		}
		// Coin
		key = [[NSString alloc] initWithFormat:@"%@", IMAGE_COIN];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		// Ladybug
		for (int i = 0; i < 4; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_LADYBUG, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
		}
		// Waterlily
		for (int i = 0; i < 4; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_WATERLILY, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
		}
		// Diamond
		for (int i = 0; i < 4; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_DIAMOND, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
		}
		// Flag
		for (int i = 0; i < 2; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_FLAG, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
		}
		// Water
		for (int i = 0; i < 10; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_WATER, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
		}
		// Waterlily pad
		for (int i = 0; i < 4; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_WATERLILY_PAD, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
		}
		// Waterwave
		for (int i = 0; i < 4; i++) {
			for (int j = 0; j < 4; j++) {
				key = [[NSString alloc] initWithFormat:@"%@%i_%i", IMAGE_WATERWAVE, i+1, j+1];
				[images setObject:[ImageCache newImageFromResource:key] forKey:key];
				[key release];
			}
		}
		// Stone
		key = [[NSString alloc] initWithFormat:@"%@", IMAGE_STONE];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		// Reed
		for (int i = 0; i < 4; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_REED, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
		}
		// Water reed (incl. mirror)
		for (int i = 0; i < 2; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_WATERREED, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
			key = [[NSString alloc] initWithFormat:@"%@%i_m", IMAGE_WATERREED, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];			
		}
		// Gamebar
		// Lives
		[images setObject:[ImageCache newImageFromResource:IMAGE_LIVES_GB] forKey:IMAGE_LIVES_GB];
		// Time
		[images setObject:[ImageCache newImageFromResource:IMAGE_TIME_GB] forKey:IMAGE_TIME_GB];
		// Diamond
		[images setObject:[ImageCache newImageFromResource:IMAGE_DIAMOND_GB] forKey:IMAGE_DIAMOND_GB];
		// Coin
		[images setObject:[ImageCache newImageFromResource:IMAGE_COIN_GB] forKey:IMAGE_COIN_GB];
		// Butterfly
		[images setObject:[ImageCache newImageFromResource:IMAGE_BUTTERFLY_GB] forKey:IMAGE_BUTTERFLY_GB];
		// Flags
		key = [[NSString alloc] initWithFormat:@"%@", IMAGE_FROG_FLAG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@", IMAGE_OPP_FROG_FLAG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release]; 
		// Frog sit
		key = [[NSString alloc] initWithFormat:@"%@_s", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_so", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_o", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_no", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_n", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_nw", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_w", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_sw", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		// Frog jump
		key = [[NSString alloc] initWithFormat:@"%@_x_s", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_so", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_o", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_no", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_n", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_nw", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_w", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_sw", IMAGE_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		// Opponent Frog sit
		key = [[NSString alloc] initWithFormat:@"%@_s", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_so", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_o", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_no", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_n", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_nw", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_w", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_sw", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		// Opponent Frog jump
		key = [[NSString alloc] initWithFormat:@"%@_x_s", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_so", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_o", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_no", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_n", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_nw", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_w", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = [[NSString alloc] initWithFormat:@"%@_x_sw", IMAGE_OPP_FROG];
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		// Options
		for (int i = 0; i < 2; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_OPTION_ON, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_OPTION_OFF, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
		}
		key = IMAGE_LAKE;
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = IMAGE_PRESENTS;
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = IMAGE_COPYRIGHT;
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		// Grass
		key = IMAGE_GRASS_TOP;
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = IMAGE_GRASS_LEFT;
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = IMAGE_GRASS_RIGHT;
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = IMAGE_GRASS_TOP_M;
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = IMAGE_GRASS_LEFT_M;
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		key = IMAGE_GRASS_RIGHT_M;
		[images setObject:[ImageCache newImageFromResource:key] forKey:key];
		[key release];
		// Level
		for (int i = 0; i < 10; i++) {
			key = [[NSString alloc] initWithFormat:@"%@%i", IMAGE_LEVEL, i+1];
			[images setObject:[ImageCache newImageFromResource:key] forKey:key];
			[key release];
		}
		// Ok
		[images setObject:[ImageCache newImageFromResource:IMAGE_OK] forKey:IMAGE_OK];
		[images setObject:[ImageCache newImageFromResource:IMAGE_OK_P] forKey:IMAGE_OK_P];
		// Pause
		[images setObject:[ImageCache newImageFromResource:IMAGE_PAUSE] forKey:IMAGE_PAUSE];
		[images setObject:[ImageCache newImageFromResource:IMAGE_PAUSE_P] forKey:IMAGE_PAUSE_P];
		// Arrow
		[images setObject:[ImageCache newImageFromResource:IMAGE_ARROW_LEFT] forKey:IMAGE_ARROW_LEFT];
		[images setObject:[ImageCache newImageFromResource:IMAGE_ARROW_LEFT_P] forKey:IMAGE_ARROW_LEFT_P];
		[images setObject:[ImageCache newImageFromResource:IMAGE_ARROW_RIGHT] forKey:IMAGE_ARROW_RIGHT];
		[images setObject:[ImageCache newImageFromResource:IMAGE_ARROW_RIGHT_P] forKey:IMAGE_ARROW_RIGHT_P];
    }
    return self;
}

+ (ImageCache *)instance {
	static ImageCache *_instance;
	@synchronized(self) {
		if (!_instance) {
			_instance = [[ImageCache alloc] init];
		}
	}
	return _instance;
}

- (UIImage *)getImage:(NSString *)name {
	return [images objectForKey:name];
}

- (UIImage *)getImage:(NSString *)name andIndex:(int)index {
	NSString *key = [[NSString alloc] initWithFormat:@"%@%i", name, index];
	UIImage *image = [images objectForKey:key];
	[key release];
	return image;
}

- (UIImage *)getImage:(NSString *)name andIndex:(int)index andSuffix:(NSString *)suffix {
	NSString *key = [[NSString alloc] initWithFormat:@"%@%i%@", name, index, suffix]; 
	UIImage *image = [images objectForKey:key];
	[key release];
	return image;
}

- (UIImage *)getImage:(NSString *)name andType:(int)type andIndex:(int)index {
	NSString *key = [[NSString alloc] initWithFormat:@"%@%i_%i", name, type, index];
	UIImage *image = [images objectForKey:key];
	[key release];
	return image;
}

+ (UIImage *)newImageNamed:(NSString *)name {
	return [UIImage	imageNamed:name];
}

+ (UIImage *)newImageFromResource:(NSString *)filename {  
    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@.%@",  
						  [[NSBundle mainBundle] resourcePath], filename, @"png"];  
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageFile];  
    [imageFile release];  
    return image;  
}  

- (void)dealloc {
	for (UIImage *image in images) {
		[image release];
	}
	[images release];
    [super dealloc];
}

@end
