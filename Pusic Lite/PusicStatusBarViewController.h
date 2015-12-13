//
//  PusicStatusBarViewController.h
//  Pusic
//
//  Created by peter on 15/4/22.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Music.h"
#import <AVFoundation/AVFoundation.h>
#import "PusicUserDefaults.h"
#import "MusicDao.h"
#import "AYProgressIndicator.h"
@interface PusicStatusBarViewController : NSViewController<AVAudioPlayerDelegate>
{
    NSTimer *refreshTimer;
    NSMutableArray * songList;
    AVAudioPlayer *musicPlayer;
    NSInteger musicPlayingPosition;
    BOOL isCirculate ;
    BOOL isRandom;
    BOOL isList;
    MusicDao * musicDao;

    PusicUserDefaults *defaults;
    NSTimer *currentTimer;
    AYProgressIndicator *progressIndicator;
    
    
}
@property (strong) IBOutlet NSImageView *musicCover;
@property (strong) IBOutlet NSTextField *musicName;
@property (strong) IBOutlet NSTextField *songerName;
@property (strong) IBOutlet NSTextField *musicAlbume;
@property (strong) IBOutlet NSTextField *musicTime;
@property (strong) IBOutlet NSButton *play;
@property (strong) IBOutlet NSButton *pro;
@property (strong) IBOutlet NSButton *next;
@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSTextField *currentTime;
- (IBAction)shufflePlay:(id)sender;
- (IBAction)listPlay:(id)sender;
- (IBAction)repeatPlay:(id)sender;
@property (strong) IBOutlet NSImageView *shuffleImage;
@property (strong) IBOutlet NSImageView *repeatImage;
@property (strong) IBOutlet NSImageView *songList;


- (IBAction)proMusic:(id)sender;
- (IBAction)palyMuisc:(id)sender;
- (IBAction)nextMusic:(id)sender;
@property (weak) Music *music;

@end
