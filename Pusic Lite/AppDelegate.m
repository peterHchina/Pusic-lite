//
//  AppDelegate.m
//  Pusic Lite
//
//  Created by peter on 15/5/9.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "AppDelegate.h"
#import "CreateDataBase.h"
#import "PusicAlert.h"
#import "PreferenceController.h"
@interface AppDelegate ()
{
    NSImage *menuNormalImage;
    NSImage * menuDarkImage;
}
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:24];
    [_statusItem setHighlightMode:YES];
    _statusView = [[PusicRHStatusItemView alloc] initWithStatusBarItem:_statusItem];
    _statusItem.view = _statusView;
    _statusView.target =self;
    _statusView.action = @selector(mouseClick:);
    _statusView.rightAction = @selector(menuClick:);
    popOverDelagate =[[PusicPopOverViewDelagate alloc] init];
    [self setStatusImageAndToolTip];
//    
//    NSInteger isShowAppIcon = [PusicUserDefaults getShowIcon];
//    if (isShowAppIcon == 1) {
//        ProcessSerialNumber psn = { 0, kCurrentProcess };
//        TransformProcessType(&psn, kProcessTransformToForegroundApplication);
//    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

# pragma show stateMune

+(void) initialize
{
    [PusicUserDefaults registerUserDefaults];
}


-(void) mouseClick:(id) sender
{
    musicPlayingPosition = [PusicUserDefaults getLastPlaySongPosition];
    popOverDelagate.viewThmeNum = [PusicUserDefaults getTheme];
    if([songList count]>0 && musicPlayingPosition>=[songList count]-1)
    {
        [popOverDelagate showPopover:sender musicInfo:[songList objectAtIndex:[songList count]-1]];
        musicPlayingPosition = [songList count]-1;
    }
    else
    {
        if ([songList count]==0) {
              [popOverDelagate showPopover:sender musicInfo:nil];
        }
        else
        {
        [popOverDelagate showPopover:sender musicInfo:[songList objectAtIndex:musicPlayingPosition]];
        }
    }
    [NSApp activateIgnoringOtherApps:YES];
}

-(void) menuClick:(id) sender
{
    [_statusView popUpMenu:rightMenu ];

 [NSApp activateIgnoringOtherApps:YES];
}


- (void)setStatusImageAndToolTip
{
    
    menuNormalImage = [NSImage imageNamed:@"status"];
    menuDarkImage = [NSImage imageNamed:@"status_dark"];
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(darkModeChanged) name:@"AppleInterfaceThemeChangedNotification" object:nil];
    NSLog(@"test8======================");
    //    NSImage *image = [NSImage imageNamed:@"status"];
    if ([self isDarkMode]) {
        [_statusView setImage: menuNormalImage];
        [_statusView setAlternateImage:menuNormalImage];
    }
    else
    {
        [_statusView setImage: menuDarkImage ];
        [_statusView setAlternateImage:menuNormalImage];

    }

  

}

-(void)  awakeFromNib
{
    isCirculate = [PusicUserDefaults getCirculate ];
    isRandom = [PusicUserDefaults getRandom];
    [[[CreateDataBase alloc] init] createDataBase];
    musicDao = [[MusicDao alloc] init];
    songList = [musicDao getAllMusicList];
    
}


- (IBAction)addFolder:(id)sender {
    __block NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setTitle:@"选择歌曲所在文件夹"];
    NSInteger resault = [panel runModal];
   
     if (resault== NSModalResponseOK) {
             [self performSelectorInBackground:@selector(backgroundOperation:) withObject:panel];
         }
         panel = nil;
    
}

- (IBAction)addSong:(id)sender {
    __block NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setTitle:@"选择歌曲"];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"mp3",@"wmv", nil]];
    NSInteger resault = [panel runModal];
    
    if (resault== NSModalResponseOK) {
        [self performSelectorInBackground:@selector(backgroundOperation:) withObject:panel];
    }
    panel = nil;
    
}


-(void) backgroundOperation:(id) unused
{
    NSArray * arry = [songList copy];
    NSFileManager *fileManger = [NSFileManager new];
    NSURL *path2;
    NSString *basePath ;
    if ([unused  isKindOfClass:[NSPanel class]]) {
        path2 = [unused URL];
        basePath = [path2 path];
    }else if ([unused isKindOfClass:[NSString class]])
    {
        basePath=unused;
    }
    NSLog(@"%@",basePath);
    NSDirectoryEnumerator *filearry = [fileManger  enumeratorAtPath:basePath];
    for (NSString *file in filearry) {
        NSString *fullPath =[basePath stringByAppendingPathComponent:file];
        NSURL *musicURL;
        if ([[fullPath pathExtension] isEqualToString:@"mp3"] || [[fullPath pathExtension] isEqualToString:@"wmv"]) {
            NSString * musicType =[fullPath pathExtension];
            musicURL = [NSURL fileURLWithPath:fullPath];
            AVURLAsset *musicAsset = [AVURLAsset URLAssetWithURL:musicURL options:nil];
            Music *music = [[Music alloc] init];
            [music setMusicTime:[self getSongTime: musicAsset :music]];
            [music setMusicPathURL:fullPath];
            NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
            
            //            AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:musicURL options:nil];
            
            //    NSLog(@"%@",mp3Asset);
            
            for (NSString *format in [musicAsset availableMetadataFormats]) {
                for (AVMetadataItem *metadataItem in [musicAsset metadataForFormat:format]) {
                    
                    if(metadataItem.commonKey)
                        [retDic setObject:metadataItem.value forKey:metadataItem.commonKey];
                    
                }
            }
            NSString * musicName = [NSString stringWithFormat:@"%@",[retDic objectForKey:@"title"]];
            
            [music setMusicName:musicName];
            [music setMusicType:musicType];
            [music setMusicSinger:[retDic objectForKey:@"artist"]];
            [music setMusicAlbumName:[retDic objectForKey:@"albumName"]];
            //            [music setMusicCoverImage:[[retDic objectForKey:@"artwork"] objectForKey:@"data"]];
            int flag=0;
            if (arry.count>0 ) {
                for (Music *m in songList) {
                    if ([[m musicName] isEqualToString:[music musicName]]) {
                        flag=1;
                    }
                }
            }
            if (flag==0) {
                [songList addObject:music];
                
            }
            
        }
        
    }
    [self performSelectorOnMainThread:@selector(updateWithResults) withObject:nil waitUntilDone:YES];
    
    
}
-(void) updateWithResults
{
    //    NSLog(@"NSUserDefaults66 %@",[[NSUserDefaults standardUserDefaults] objectForKey:BNRRecentFileFolder]);
   
    if (songList.count>0) {
    [musicDao clearTable];
        [musicDao insertMusic:songList];
    }
    
}

-(void) clearAllData:(BOOL) state
{
    if(musicPlayer.isPlaying)
    {
        [musicPlayer stop];
        musicPlayingPosition = 0;
        
    }
    [musicDao clearTable ];
    if(state == YES)
    {
        [self deleteFile:songList];
    }
    [songList removeAllObjects];
    
   
}

-(void) clearSingleSongData:(BOOL) state
{
    if(musicPlayer.isPlaying)
    {
        [musicPlayer stop];
        musicPlayingPosition = 0;
        
    }
    [musicDao deleteMusic:[NSArray arrayWithObject:songList[musicPlayingPosition]]];
    
    
    if(state == YES)
    {
        [self deleteFile:[NSArray arrayWithObject:songList[musicPlayingPosition] ]];
        [songList removeObjectAtIndex:musicPlayingPosition];
    }
   
}

-(NSString *) getSongTime:(AVURLAsset *) urlAsset :(Music *) music
{
    
    if(urlAsset)
    {
        double musicTime = urlAsset.duration.value/urlAsset.duration.timescale;
        [music setMusicRealTime:musicTime];
        return  [self getFormateTimeString:(int)musicTime];
    }
    return @"0s";
}

-(NSString *) getFormateTimeString : (NSInteger ) time
{
    NSLog(@"time %ld",time);
    int minute=0;
    int second=0;
    if (time>=60) {
        int index = (int)time/60;
        minute = index;
        second=(int)time -60*index;
    }else
    {
        second = (int)time;
    }
    NSString *minuteString=@"00";
    NSString *secondString=@"00";
    
    if (minute<10) {
        minuteString= [NSString stringWithFormat:@"%d",minute];
    }
    else
    {
        minuteString= [NSString stringWithFormat:@"%d",minute];
        
    }
    if (second<10) {
        secondString=[NSString stringWithFormat:@"0%d",second];
        
    }else
    {
        secondString=[NSString stringWithFormat:@"%d",second];
    }
    
    
    
    return  [NSString stringWithFormat:@"%@:%@",minuteString,secondString];
    
}
-(IBAction)deleteSong:(id)sender
{
    
    Music *music = [songList objectAtIndex:musicPlayingPosition];
    NSString *name = [music musicName];
    PusicAlert *alert = [PusicAlert alertWithTitle:@"删除警告!" MessageText:[NSString stringWithFormat:@"是否要删除歌曲：%@",name]   okButton:@"确定" cancelButton:@"取消" otherButton:nil imagePath:nil] ;
    
    NSInteger action = [alert RunModel];
    if(action == PusicAlertOkReturn)
    {
        [self clearSingleSongData:[alert isDelete]];
    }
    else if(action == PusicAlertCancelReturn )
    {
        NSLog(@"SYXAlertCancelButton clicked!");
    }
    
    
}

- (IBAction)ShowPerference:(id)sender {
    preferenceController  = [[PreferenceController alloc] init];
    [preferenceController showWindow:self];
}

- (IBAction)closeWindow:(id)sender {
    [NSApp terminate:nil];
}

- (IBAction)showAbout:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:self];
}

-(void) backgroundAddSong:(id) sender
{
    NSArray * arry = [songList copy];
    NSURL *path2;
    NSString *basePath ;
    if ([sender isKindOfClass:[NSPanel class]]) {
        path2 = [sender URL];
        basePath = [path2 path];
    }
    
    NSURL *musicURL;
    if ([[basePath pathExtension] isEqualToString:@"mp3"] || [[basePath pathExtension] isEqualToString:@"wmv"]) {
        NSString * musicType =[basePath pathExtension];
        musicURL = [NSURL fileURLWithPath:basePath];
        AVURLAsset *musicAsset = [AVURLAsset URLAssetWithURL:musicURL options:nil];
        Music *music = [[Music alloc] init];
        [music setMusicTime:[self getSongTime: musicAsset :music]];
        [music setMusicPathURL:basePath];
        NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
        
        AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:musicURL options:nil];
        
        //    NSLog(@"%@",mp3Asset);
        
        for (NSString *format in [mp3Asset availableMetadataFormats]) {
            for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
                
                if(metadataItem.commonKey)
                    [retDic setObject:metadataItem.value forKey:metadataItem.commonKey];
                
            }
        }
        NSString * musicName = [NSString stringWithFormat:@"%@-%@",[retDic objectForKey:@"title"],[retDic objectForKey:@"artist"]];
        NSLog(@"%@",musicName);
        [music setMusicName:musicName];
        [music setMusicType:musicType];
        [music setMusicSinger:[retDic objectForKey:@"artist"]];
        [music setMusicAlbumName:[retDic objectForKey:@"albumName"]];
        //            [music setMusicCoverImage:[[retDic objectForKey:@"artwork"] objectForKey:@"data"]];
        int flag=0;
        if (arry.count>0 ) {
            for (Music *m in songList) {
                if ([[m musicName] isEqualToString:[music musicName]]) {
                    flag=1;
                }
            }
        }
        if (flag==0) {
            [songList addObject:music];
            
        }
        
        
        
    }
    [self performSelectorOnMainThread:@selector(updateWithResults) withObject:nil waitUntilDone:YES];
}


-(void) deleteFile:(NSArray *) list
{
    NSFileManager *manger = [NSFileManager defaultManager];
    if (list!=nil && list.count>0) {
        for(Music * music in list)
        {
            [manger removeItemAtPath:music.musicPathURL error:NULL];
        }
    }
    
}
- (IBAction)clear:(id)sender
{
    PusicAlert *alert = [PusicAlert alertWithTitle:@"列表清除警告!" MessageText:@"是否要清除当前歌曲列表？"  okButton:@"确定" cancelButton:@"取消" otherButton:nil imagePath:nil] ;
    
    NSInteger action = [alert RunModel];
    if(action == PusicAlertOkReturn)
    {
        
        [self clearAllData:[alert isDelete] ];
        
    }
    else if(action == PusicAlertCancelReturn )
    {
        NSLog(@"SYXAlertCancelButton clicked!");
    }

}

-(void) darkModeChanged
{
    
    if ([self isDarkMode]) {
        [_statusView setImage: menuNormalImage];
    }
    else
    {
        [_statusView setImage: menuDarkImage];
        
    }
}


-(BOOL) isDarkMode
{
    NSDictionary *systemUserDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"NSGlobalDomain"];
    NSString *style = [systemUserDefaults objectForKey:@"AppleInterfaceStyle"];
    
    //    NSString *style1 = NSStringFromClass(style1);
    if ([style.lowercaseString isEqualToString:@"dark"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
