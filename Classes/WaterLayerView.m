//
//  WaterLayerView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 06.02.10.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "WaterLayerView.h"
#import "WaterView.h"
#import "ImageCache.h"

@implementation WaterLayerView

@synthesize index;

- (id)initWithFrame:(CGRect)frame andIndex:(int)i {
    if (self = [super initWithFrame:frame]) {
		water = [[NSMutableArray alloc] init];
		index = i;
		self.opaque = YES;
    }
    return self;
}

- (void)resetWithFrame:(CGRect)frame {
	self.frame = frame;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	/*CGRect waterRect = CGRectMake(WATER_WIDTH, WATER_HEIGHT, WATER_WIDTH, WATER_HEIGHT);
	 [[[ImageCache instance] getImage:IMAGE_WATER andIndex:1] drawInRect:waterRect];
	 return;*/
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef newImage = CGImageRetain([[ImageCache instance] getImage:IMAGE_WATER andIndex:index+1].CGImage);
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(newImage), CGImageGetHeight(newImage));
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));      
    CGContextDrawTiledImage(context, imageRect, newImage);
    CGImageRelease(newImage);
}

- (void)dealloc {
    [super dealloc];
}

@end
