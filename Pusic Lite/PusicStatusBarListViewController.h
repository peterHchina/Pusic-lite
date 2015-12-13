//
//  PusicStatusBarListViewController.h
//  Pusic Lite
//
//  Created by peter on 15/8/9.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicDao.h"
#import "PusicUserDefaults.h"
#import "AYProgressIndicator.h"
#import "Music.h"
@interface PusicStatusBarListViewController : NSViewController<AVAudioPlayerDelegate>
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
- (IBAction)shufflePlay:(id)sender;
- (IBAction)listPlay:(id)sender;
- (IBAction)repeatPlay:(id)sender;
@property (strong) IBOutlet NSButton *shuffleButton;
@property (strong) IBOutlet NSButton *repeatButton;
@property (strong) IBOutlet NSButton *songListButton;
@property (strong) IBOutlet NSTextField *musicTime;
@property (strong) IBOutlet NSButton *play;
@property (strong) IBOutlet NSButton *pro;
@property (strong) IBOutlet NSButton *next;
@property (strong) IBOutlet NSTableView *tableView;


- (IBAction)proMusic:(id)sender;
- (IBAction)palyMuisc:(id)sender;
- (IBAction)nextMusic:(id)sender;
@property (weak) Music *music;
@end
