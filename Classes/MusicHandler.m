//
//  MusicHandler.m
//  iFroggi
//
//  Created by Oliver Klemenz on 26.09.09.
//  Copyright 2010 KillerAppSoft. All rights reserved.
//

#import "MusicHandler.h"
#import "UserData.h"

@implementation MusicHandler

- (id)init {
    if (self = [super init]) {
		introMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"intro_music" ofType:@"caf"]] error:NULL];
		introMusicPlayer.delegate = self;
		introMusicPlayer.volume = 0.3;
		[introMusicPlayer prepareToPlay];
		
		menuMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"menu_music" ofType:@"caf"]] error:NULL];
		menuMusicPlayer.delegate = self;
		menuMusicPlayer.volume = 0.3;
		menuMusicPlayer.numberOfLoops = -1; // Indefinitely
		[menuMusicPlayer prepareToPlay];
		
		gameMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"game_music" ofType:@"caf"]] error:NULL];
		gameMusicPlayer.delegate = self;
		gameMusicPlayer.volume = 0.3;
		gameMusicPlayer.numberOfLoops = -1; // Indefinitely
		[gameMusicPlayer prepareToPlay];
		
		gameAmbiencePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"lake" ofType:@"caf"]] error:NULL];
		gameAmbiencePlayer.delegate = self;
		gameAmbiencePlayer.volume = 0.3;
		gameAmbiencePlayer.numberOfLoops = -1; // Indefinitely
		[gameAmbiencePlayer prepareToPlay];
    }
    return self;
}

+ (MusicHandler *)instance {
	static MusicHandler *_instance;
	@synchronized(self) {
		if (!_instance) {
			_instance = [[MusicHandler alloc] init];
		}
	}
	return _instance;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
}

- (void)playIntroMusic {
	if ([UserData instance].sound) {
		if (![introMusicPlayer isPlaying]) {
			[self stopMusic];
			[self stopSound];
			[introMusicPlayer play];
		}	
	}
}

- (void)playMenuMusic {
	if ([UserData instance].music) {
		if (![menuMusicPlayer isPlaying]) {
			[self stopMusic];
			[self stopSound];
			[menuMusicPlayer play];
		}	
	}
}

- (void)playGameMusic {
	if ([UserData instance].music) {
		if (![gameMusicPlayer isPlaying]) {
			[self stopMusic];
			[gameMusicPlayer play];
		}
	}
}

- (void)playGameAmbience {
	if ([UserData instance].sound) {
		if (![gameAmbiencePlayer isPlaying]) {
			[gameAmbiencePlayer play];
		}
	}
}

- (void)stopMusic {
	if ([introMusicPlayer isPlaying]) {
		[introMusicPlayer stop];
		[introMusicPlayer prepareToPlay];
	} else if ([menuMusicPlayer isPlaying]) {
		[menuMusicPlayer stop];
		[menuMusicPlayer prepareToPlay];
	} else if ([gameMusicPlayer isPlaying]) {
		[gameMusicPlayer stop];
		[gameMusicPlayer prepareToPlay];
	}	
}

- (void)stopIntro {
	if ([introMusicPlayer isPlaying]) {
		[introMusicPlayer stop];
		[introMusicPlayer prepareToPlay];
	}		
}

- (void)resetSeek {
	if (![introMusicPlayer isPlaying]) {
		introMusicPlayer.currentTime = 0;
	}
	if (![menuMusicPlayer isPlaying]) {
		menuMusicPlayer.currentTime = 0;
	}
	if (![gameMusicPlayer isPlaying]) {
		gameMusicPlayer.currentTime = 0;
	}
}

- (void)stopSound {
	if ([gameAmbiencePlayer isPlaying]) {
		[gameAmbiencePlayer stop];
	}
}

- (void)dealloc {
	[self stopMusic];
	[self stopSound];
	[introMusicPlayer release];
	[menuMusicPlayer release];
	[gameMusicPlayer release];
	[gameAmbiencePlayer release];
    [super dealloc];
}

@end
