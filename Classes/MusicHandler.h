//
//  MusicHandler.h
//  iFroggi
//
//  Created by Oliver Klemenz on 26.09.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicHandler : NSObject <AVAudioPlayerDelegate> {

	AVAudioPlayer *introMusicPlayer;
	AVAudioPlayer *menuMusicPlayer;
	AVAudioPlayer *gameMusicPlayer;
	AVAudioPlayer *gameAmbiencePlayer;
	
}

- (id)init;
+ (MusicHandler *)instance;

- (void)playIntroMusic;
- (void)playMenuMusic;
- (void)playGameMusic;
- (void)playGameAmbience;

- (void)stopMusic;
- (void)stopIntro;
- (void)stopSound;
- (void)resetSeek;

@end
