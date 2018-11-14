//
//  NumberView.m
//  iFroggi
//
//  Created by Oliver Klemenz on 20.07.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "NumberView.h"
#import "GameHelper.h"
#import "ImageCache.h"

@implementation NumberView

@synthesize type, alignX, alignY, posX, posY, maxWidth, maxHeight, num, maxNum, frontImage, frontImageOffsetX, frontImageOffsetY;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	type = TYPE_LARGE;
	posX = 0;
	posY = 0;
	maxWidth = self.frame.size.width;
	maxHeight = self.frame.size.height;
	alignX = ALIGN_X_CENTER;
	alignY = ALIGN_Y_TOP;
}

- (id)initWithType:(int)aType andX:(CGFloat)x andY:(CGFloat)y andXAlign:(int)xAlign andYAlign:(int)yAlign {
	if (self = [super initWithFrame:[GameHelper getMainScreen]]) {
		self.opaque = false;
		self.type = aType;
		self.posX = x;
		self.posY = y;
		self.maxWidth = SCREEN_WIDTH;
		self.maxHeight = SCREEN_HEIGHT;
		self.alignX = xAlign;
		self.alignY = yAlign;
	}
    return self;
}

- (id)initWithType:(int)aType andX:(CGFloat)x andY:(CGFloat)y andWidth:(CGFloat)w andHeight:(CGFloat)h andXAlign:(int)xAlign andYAlign:(int)yAlign {
	if (self = [super initWithFrame:[GameHelper getMainScreen]]) {
		self.opaque = false;
		self.type = aType;
		self.posX = x;
		self.posY = y;
		self.maxWidth = w;
		self.maxHeight = h;
		self.alignX = xAlign;
		self.alignY = yAlign;
	}
    return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGFloat space = 0;
	CGFloat width = 0;
	CGFloat height = 0;
	if (type == TYPE_SMALL) {
		space = NUMBER_SPACE_SMALL; 
		height = [[ImageCache instance] getImage:IMAGE_SMALL_NUMBER andIndex:0].size.height;
	} else if (type == TYPE_MEDIUM) {
		space = NUMBER_SPACE_MEDIUM; 
		height = [[ImageCache instance] getImage:IMAGE_MEDIUM_NUMBER andIndex:0].size.height;
	} else if (type == TYPE_LARGE) {
		space = NUMBER_SPACE_LARGE; 
		height = [[ImageCache instance] getImage:IMAGE_LARGE_NUMBER andIndex:0].size.height;
	}
	CGFloat imageOffset = 0;
	if (frontImage) {
		imageOffset = frontImage.size.width + space;
	}
	NSString *numberString;
	if (maxNum == 0) {
	  numberString = [[NSString alloc] initWithFormat:@"%i", self.num];
	} else {
	  numberString = [[NSString alloc] initWithFormat:@"%i / %i", self.num, self.maxNum];
	}
	if (alignX == ALIGN_X_CENTER || alignX == ALIGN_X_RIGHT) {
		for (int i = 0; i < [numberString length]; i++) {		
			NSString *digitString = [numberString substringWithRange:NSMakeRange(i, 1)];
			if ([digitString isEqualToString:@"/"]) {
				if (type == TYPE_SMALL) {
					width += [[ImageCache instance] getImage:IMAGE_SMALL_SLASH].size.width; 
				} else if (type == TYPE_MEDIUM) {
					width += [[ImageCache instance] getImage:IMAGE_MEDIUM_SLASH].size.width; 
				} else if (type == TYPE_LARGE) {
					width += [[ImageCache instance] getImage:IMAGE_LARGE_SLASH].size.width; 
				}
			} else if ([digitString isEqualToString:@" "]) {
				width += NUMBER_SPACE_WIDTH;
			} else {
				int digit = [digitString intValue];
				if (type == TYPE_SMALL) {
					width += [[ImageCache instance] getImage:IMAGE_SMALL_NUMBER andIndex:digit].size.width; 
				} else if (type == TYPE_MEDIUM) {
					width += [[ImageCache instance] getImage:IMAGE_MEDIUM_NUMBER andIndex:digit].size.width; 
				} else if (type == TYPE_LARGE) {
					width += [[ImageCache instance] getImage:IMAGE_LARGE_NUMBER andIndex:digit].size.width; 
				}
			}
			width += space;
		}
	}
	width += imageOffset;
	CGFloat x = 0;
	for (int i = 0; i < [numberString length]; i++) {
		UIImage *numberImage = nil;
		NSString *digitString = [numberString substringWithRange:NSMakeRange(i, 1)];
		if ([digitString isEqualToString:@"/"]) {
			if (type == TYPE_SMALL) {
				numberImage = [[ImageCache instance] getImage:IMAGE_SMALL_SLASH]; 
			} else if (type == TYPE_MEDIUM) {
				numberImage = [[ImageCache instance] getImage:IMAGE_MEDIUM_SLASH]; 
			} else if (type == TYPE_LARGE) {
				numberImage = [[ImageCache instance] getImage:IMAGE_LARGE_SLASH]; 
			}
		} else if ([digitString isEqualToString:@" "]) {
			numberImage = nil;
		} else {
			int digit = [digitString intValue];
			if (type == TYPE_SMALL) {
				numberImage = [[ImageCache instance] getImage:IMAGE_SMALL_NUMBER andIndex:digit];
			} else if (type == TYPE_MEDIUM) {
				numberImage = [[ImageCache instance] getImage:IMAGE_MEDIUM_NUMBER andIndex:digit];
			} else if (type == TYPE_LARGE) {
				numberImage = [[ImageCache instance] getImage:IMAGE_LARGE_NUMBER andIndex:digit];
			}
		}
		CGFloat rectX = 0;
		CGFloat rectY = 0;
		if (alignX == ALIGN_X_LEFT) {
			 rectX = posX + x;
		} else if (alignX == ALIGN_X_CENTER) {
			if (posX > 0) {
				rectX = posX + (maxWidth - posX - width) / 2 + x;
			} else {
				rectX = (maxWidth + posX - width) / 2 + x;
			}
		} else if (alignX == ALIGN_X_RIGHT) {
			if (posX < 0) {
				posX -= posX;
			}
			rectX = maxWidth - width - posX + x;
		}
		if (alignY == ALIGN_Y_TOP) {
			rectY = posY;
		} else if (alignY == ALIGN_Y_MIDDLE) {
			if (posY > 0) {
				rectY = posY + (maxHeight - posY - height) / 2;
			} else {
				rectY = (maxHeight + posY - height) / 2;
			}
		} else if (alignY == ALIGN_Y_BOTTOM) {
			if (posY < 0) {
				posY -= posY;
			}
			rectY = maxHeight - height - posY;
		}
		if (i == 0 && frontImage) {
			[frontImage drawInRect:CGRectMake(rectX + frontImageOffsetX, rectY + frontImageOffsetY, frontImage.size.width, frontImage.size.height)];
		}
		if (numberImage) {
			[numberImage drawInRect:CGRectMake(rectX + imageOffset, rectY, numberImage.size.width, numberImage.size.height)];				
			x += numberImage.size.width + space; 
		} else {
			x += NUMBER_SPACE_WIDTH;
		}
	}
	[numberString release];
}

- (void)setNumber:(int)aNumber {
	self.num = aNumber;
	[self setNeedsDisplay];
}

- (void)setNumber:(int)number andMaxNumber:(int)maxNumber {
	[self setNumber:number];
	self.maxNum = maxNumber;
	[self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image {
	frontImage = image;
	[self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image andOffsetX:(int)x andOffsetY:(int)y {
	frontImage = image;
	self.frontImageOffsetX = x;
	self.frontImageOffsetY = y;
}

- (void)dealloc {
    [super dealloc];
}

@end
