//
//  AppDelegate.h
//  Pusic Lite
//
//  Created by peter on 15/5/9.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicDao.h"
#import "PusicUserDefaults.h"
#import "PusicPopOverViewDelagate.m"
#import "PusicRHStatusItemView.h"
#import "PreferenceController.h"
@interface AppDelegate : NSObject <NSApplicationDelegate,AVAudioPlayerDelegate,NSUserNotificationCenterDelegate>

{
    NSMutableArray * songList;
    AVAudioPlayer *musicPlayer;
    NSInteger musicPlayingPosition;
    NSTimer *currentTimer;
    MusicDao * musicDao;
    BOOL isCirculate ;
    BOOL isRandom;
    NSInteger themeNum;
    PreferenceController *preferenceController;
    PusicPopOverViewDelagate * popOverDelagate;
    PusicUserDefaults *defaults;
    
    __weak IBOutlet NSMenu *rightMenu;
}
@property PusicRHStatusItemView *statusView;
@property NSStatusItem *statusItem;
- (IBAction)addFolder:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)disSort:(id)sender;
- (IBAction)addSong:(id)sender;
- (IBAction)deleteSong:(id)sender;
- (IBAction)ShowPerference:(id)sender;
- (IBAction)closeWindow:(id)sender;
- (IBAction)showAbout:(id)sender;

@end

