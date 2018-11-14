//
//  ImageCache.h
//  iFroggi
//
//  Created by Oliver Klemenz on 03.11.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *IMAGE_SMALL_NUMBER  = @"number_s_";
static NSString *IMAGE_MEDIUM_NUMBER = @"number_m_";
static NSString *IMAGE_LARGE_NUMBER  = @"number_l_";

static NSString *IMAGE_SMALL_SLASH   = @"number_s_slash";
static NSString *IMAGE_MEDIUM_SLASH  = @"number_m_slash";
static NSString *IMAGE_LARGE_SLASH   = @"number_l_slash";

static NSString *IMAGE_FLY           = @"fly";
static NSString *IMAGE_BUTTERFLY     = @"butterfly";
static NSString *IMAGE_CATERPILLAR   = @"caterpillar";
static NSString *IMAGE_COIN          = @"coin";
static NSString *IMAGE_LADYBUG       = @"ladybug";
static NSString *IMAGE_WATERLILY     = @"waterlily";
static NSString *IMAGE_DIAMOND       = @"diamond";
static NSString *IMAGE_FLAG          = @"flag";

static NSString *IMAGE_WATER    	 = @"water";
static NSString *IMAGE_WATERWAVE	 = @"waterwave";
static NSString *IMAGE_WATERLILY_PAD = @"waterlily_pad";
static NSString *IMAGE_STONE         = @"stone";
static NSString *IMAGE_REED          = @"reed";
static NSString *IMAGE_WATERREED     = @"waterreed";

static NSString *IMAGE_LIVES_GB		 = @"lives";
static NSString *IMAGE_TIME_GB 		 = @"time";
static NSString *IMAGE_DIAMOND_GB    = @"diamond";
static NSString *IMAGE_COIN_GB 		 = @"coin";
static NSString *IMAGE_BUTTERFLY_GB  = @"butterfly_s";
static NSString *IMAGE_FROG_FLAG     = @"flag1_s";
static NSString *IMAGE_OPP_FROG_FLAG = @"flag2_s";

static NSString *IMAGE_FROG			 = @"frog";
static NSString *IMAGE_OPP_FROG  	 = @"opp_frog";

static NSString *IMAGE_OPTION_ON	 = @"options_on";
static NSString *IMAGE_OPTION_OFF	 = @"options_off";

static NSString *IMAGE_LAKE		     = @"lake";
static NSString *IMAGE_PRESENTS  	 = @"presents";
static NSString *IMAGE_COPYRIGHT  	 = @"copyright";

static NSString *IMAGE_GRASS_TOP	 = @"grass_top";
static NSString *IMAGE_GRASS_LEFT	 = @"grass_left";
static NSString *IMAGE_GRASS_RIGHT	 = @"grass_right";

static NSString *IMAGE_GRASS_TOP_M	 = @"grass_top_m";
static NSString *IMAGE_GRASS_LEFT_M	 = @"grass_left_m";
static NSString *IMAGE_GRASS_RIGHT_M = @"grass_right_m";

static NSString *IMAGE_LEVEL		 = @"level";
static NSString *IMAGE_OK		     = @"ok_btn";
static NSString *IMAGE_OK_P		     = @"ok_btn_p";
static NSString *IMAGE_PAUSE	     = @"pause_btn";
static NSString *IMAGE_PAUSE_P	     = @"pause_btn_p";
static NSString *IMAGE_ARROW_LEFT    = @"arrow_left";
static NSString *IMAGE_ARROW_LEFT_P  = @"arrow_left_p";
static NSString *IMAGE_ARROW_RIGHT   = @"arrow_right";
static NSString *IMAGE_ARROW_RIGHT_P = @"arrow_right_p";


@interface ImageCache : NSObject {
	NSMutableDictionary *images;
}

- (id)init;
+ (ImageCache *)instance;

- (UIImage *)getImage:(NSString *)name;
- (UIImage *)getImage:(NSString *)name andIndex:(int)index;
- (UIImage *)getImage:(NSString *)name andIndex:(int)index andSuffix:(NSString *)suffix;
- (UIImage *)getImage:(NSString *)name andType:(int)type andIndex:(int)index;

+ (UIImage *)newImageNamed:(NSString *)name;
+ (UIImage *)newImageFromResource:(NSString *)filename;  

@end
