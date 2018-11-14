//
//  GrassView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 21.01.10.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "GrassView.h"
#import "WaterView.h"

#import "ImageCache.h"
#import "UserData.h"

@implementation GrassView

@synthesize lakePos;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.opaque = NO;
		lakePos = self.center;
    }
    return self;
}

- (void)resetWithFrame:(CGRect)frame {
	self.frame = frame;
	lakePos = self.center;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
    CGImageRef newImage = CGImageRetain([[ImageCache instance] getImage:IMAGE_GRASS_LEFT_M].CGImage);
	CGRect imageRect = CGRectMake(GRASS_OFFSET_LEFT+WATER_WIDTH_2-CGImageGetWidth(newImage)+GRASS_MIRROR_OFFSET, 0, CGImageGetWidth(newImage), CGImageGetHeight(newImage));
    CGContextClipToRect(context, CGRectMake(GRASS_OFFSET_LEFT+WATER_WIDTH_2-(CGImageGetWidth(newImage)-GRASS_MIRROR_OFFSET), WATER_HEIGHT_2-25, imageRect.size.width, rect.size.height));
    CGContextDrawTiledImage(context, imageRect, newImage);
	CGImageRelease(newImage);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
    newImage = CGImageRetain([[ImageCache instance] getImage:IMAGE_GRASS_RIGHT_M].CGImage);
	imageRect = CGRectMake(GRASS_OFFSET_RIGHT+WATER_WIDTH_2 * ([UserData instance].columns+1)-GRASS_MIRROR_OFFSET, 0, CGImageGetWidth(newImage), CGImageGetHeight(newImage));
    CGContextClipToRect(context, CGRectMake(GRASS_OFFSET_RIGHT+WATER_WIDTH_2 * ([UserData instance].columns+1)-GRASS_MIRROR_OFFSET, WATER_HEIGHT_2-25, imageRect.size.width, rect.size.height));
    CGContextDrawTiledImage(context, imageRect, newImage);
	CGImageRelease(newImage);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
    newImage = CGImageRetain([[ImageCache instance] getImage:IMAGE_GRASS_TOP_M].CGImage);
	imageRect = CGRectMake(0, GRASS_OFFSET_TOP+WATER_HEIGHT_2-CGImageGetHeight(newImage)+GRASS_MIRROR_OFFSET, CGImageGetWidth(newImage), CGImageGetHeight(newImage));
    CGContextClipToRect(context, CGRectMake(WATER_WIDTH_2-25, GRASS_OFFSET_TOP+WATER_HEIGHT_2-CGImageGetHeight(newImage)+GRASS_MIRROR_OFFSET, rect.size.width, imageRect.size.height));
    CGContextDrawTiledImage(context, imageRect, newImage);
	CGImageRelease(newImage);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
    newImage = CGImageRetain([[ImageCache instance] getImage:IMAGE_GRASS_LEFT].CGImage);
	imageRect = CGRectMake(GRASS_OFFSET_LEFT+WATER_WIDTH_2-CGImageGetWidth(newImage), 0, CGImageGetWidth(newImage), CGImageGetHeight(newImage));
    CGContextClipToRect(context, CGRectMake(GRASS_OFFSET_LEFT+WATER_WIDTH_2-CGImageGetWidth(newImage), WATER_HEIGHT_2-25, imageRect.size.width, rect.size.height));
    CGContextDrawTiledImage(context, imageRect, newImage);
	CGImageRelease(newImage);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
    newImage = CGImageRetain([[ImageCache instance] getImage:IMAGE_GRASS_RIGHT].CGImage);
	imageRect = CGRectMake(GRASS_OFFSET_RIGHT+WATER_WIDTH_2 * ([UserData instance].columns+1), 0, CGImageGetWidth(newImage), CGImageGetHeight(newImage));
    CGContextClipToRect(context, CGRectMake(GRASS_OFFSET_RIGHT+WATER_WIDTH_2 * ([UserData instance].columns+1), WATER_HEIGHT_2-25, imageRect.size.width, rect.size.height));
    CGContextDrawTiledImage(context, imageRect, newImage);
	CGImageRelease(newImage);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);	
    newImage = CGImageRetain([[ImageCache instance] getImage:IMAGE_GRASS_TOP].CGImage);
	imageRect = CGRectMake(0, GRASS_OFFSET_TOP+WATER_HEIGHT_2-CGImageGetHeight(newImage), CGImageGetWidth(newImage), CGImageGetHeight(newImage));
    CGContextClipToRect(context, CGRectMake(WATER_WIDTH_2-25, GRASS_OFFSET_TOP+WATER_HEIGHT_2-CGImageGetHeight(newImage), rect.size.width, imageRect.size.height));
    CGContextDrawTiledImage(context, imageRect, newImage);
	CGImageRelease(newImage);
	CGContextRestoreGState(context);
}

- (void)notifyAcceleration:(CMAcceleration)acceleration {
	CGPoint point = lakePos;
	double offsetX = acceleration.y;
	double offsetY = acceleration.x;
	if (offsetX > 0.5) {
		offsetX = 0.5;
	}
	if (offsetX < -0.5) {
		offsetX = -0.5;
	}
	if (offsetY > 0.5) {
		offsetY = 0.5;
	}
	if (offsetY < -0.5) {
		offsetY = -0.5;
	}
	point.x += GRASS_MOVE_MAX * offsetX * 2;
	point.y += GRASS_MOVE_MAX * offsetY * 2;
	self.center = point;
}

- (void)dealloc {
    [super dealloc];
}

@end
