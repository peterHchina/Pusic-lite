//
//  PusicStatusBarViewController.m
//  Pusic
//
//  Created by peter on 15/4/22.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "PusicStatusBarViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Music.h"
#import "MusicDao.h"
@interface PusicStatusBarViewController ()

@end

@implementation PusicStatusBarViewController
@synthesize music;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        progressIndicator = [[AYProgressIndicator alloc] initWithFrame:NSMakeRect(274, 35, 43, 2)
                                                    progressColor:[NSColor redColor]
                                                       emptyColor:[NSColor lightGrayColor]
                                                         minValue:0
                                                         maxValue:100
                                                     currentValue:0];

        
    }
    return self;
}

-(void)  awakeFromNib
{
    isCirculate = [PusicUserDefaults getCirculate ];
    [self setCriculateButtonState:isCirculate];
    isRandom = [PusicUserDefaults getRandom];
     [self setRandomButtonState:isRandom];
    isList = [PusicUserDefaults getList];
    [self setSonglistButtonState:isList];
    [self.view addSubview:progressIndicator];
    
}

-(void) viewDidAppear
{
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
}

-(void)viewWillAppear
{
    [refreshTimer invalidate];
    refreshTimer = nil;
    musicPlayingPosition = [PusicUserDefaults getLastPlaySongPosition];
    musicDao = [[MusicDao alloc] init];
    songList = [musicDao getAllMusicList];
}

- (IBAction)shufflePlay:(id)sender {
    if (isRandom) {
        
        
    }else{
        isRandom = !isRandom;
        if (isCirculate) {
            isCirculate = !isCirculate;
            [PusicUserDefaults setCirculate:isCirculate];
            [self setCriculateButtonState:isCirculate];
        }
        
        if (isList) {
            isList = !isList;
            [PusicUserDefaults setList:isList];
            [self setSonglistButtonState:isList];
        }

        
        [PusicUserDefaults setRandom:isRandom];
        
        [self setRandomButtonState:isRandom];
    }
   
    
}

- (IBAction)listPlay:(id)sender {
    if (isList) {
        
    }else {
        isList = !isList;
        if (isRandom) {
            isRandom = !isRandom;
            [PusicUserDefaults setRandom:isRandom];
            [self setRandomButtonState:isRandom];
        }
        
        if (isCirculate) {
            isCirculate = !isCirculate;
            [PusicUserDefaults setCirculate:isCirculate];
            [self setCriculateButtonState:isCirculate];
        }
        
        
        [PusicUserDefaults setList:isList];
        
        [self setSonglistButtonState:isList];
    }

}

- (IBAction)repeatPlay:(id)sender {
    if (isCirculate) {
        
    }else {
        isCirculate = !isCirculate;
        if (isRandom) {
            isRandom = !isRandom;
            [PusicUserDefaults setRandom:isRandom];
            [self setRandomButtonState:isRandom];
        }
        
        if (isList) {
            isList = !isList;
            [PusicUserDefaults setList:isList];
            [self setSonglistButtonState:isList];
        }
        
        [PusicUserDefaults setCirculate:isCirculate];
        
        [self setCriculateButtonState:isCirculate];
    }
    
   
}
-(void) setCriculateButtonState:(BOOL) state
{
    if (state == YES) {
        [_repeatImage setImage:[NSImage imageNamed:@"Repeat_press"]];
    }else
    {
        [_repeatImage setImage:[NSImage imageNamed:@"Repeat_normal"]];
    }
    
}

-(void) setSonglistButtonState:(BOOL) state
{
    if (state == YES) {
        [_songList setImage:[NSImage imageNamed:@"Songlist_press"]];
    }else
    {
        [_songList setImage:[NSImage imageNamed:@"Songlist_normal"]];
    }
    
}

-(void) setRandomButtonState:(BOOL) state
{
    if (state == YES) {
        [_shuffleImage setImage:[NSImage imageNamed:@"Shuffle_press"]];
    }else
    {
        [_shuffleImage setImage:[NSImage imageNamed:@"Shuffle_normal"]];
    }
    
}
- (IBAction)proMusic:(id)sender {
    if([songList count] == 0)
    {
        return;
    }
    if (isRandom) {
        musicPlayingPosition = arc4random()%[songList count];
    }
    [self play:musicPlayingPosition-1];
    music  = [songList objectAtIndex:(musicPlayingPosition)];
    [self updateInfo];
     [self updatePlayProgress];
}

- (IBAction)palyMuisc:(id)sender {
    [self play:musicPlayingPosition];
    [self updatePlayProgress];
}

- (IBAction)nextMusic:(id)sender {
    if([songList count] == 0)
    {
        return;
    }
    if (isRandom) {
        musicPlayingPosition = arc4random()%[songList count];
    }
    [self play:musicPlayingPosition+1];
    music  = [songList objectAtIndex:(musicPlayingPosition)];
    [self updateInfo];
     [self updatePlayProgress];
}



-(void)updateInfo
{
    if (music!=nil) {
        _musicCover.image = [self getSongCoverImage:music];
        _musicName.stringValue = music.musicName;
        _musicAlbume.stringValue = music.musicAlbumName;
        _songerName.stringValue = music.musicSinger;
        _musicTime.stringValue = music.musicTime;
    }else
    {
        _musicCover.image  = [NSImage imageNamed:@"music_cover_default"];
    }
}

-(NSImage *) getSongCoverImage:(Music * )m
{
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    NSURL *musicURL = [NSURL fileURLWithPath:m.musicPathURL];
    NSImage *image ;
    AVURLAsset *musicAsset = [AVURLAsset URLAssetWithURL:musicURL options:nil];
    
    //    NSLog(@"%@",mp3Asset);
    
    for (NSString *format in [musicAsset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [musicAsset metadataForFormat:format]) {
            
            if(metadataItem.commonKey )
                [retDic setObject:metadataItem.value forKey:metadataItem.commonKey];
            
        }
    }
    NSData *data =[retDic objectForKey:@"artwork"] ;
    image =[[NSImage alloc] initWithData:data];
    return image;

}


-(void) updateMusicPlayingTime : (NSInteger) time
{
    Music *music1 = songList[musicPlayingPosition];
    NSInteger currentTime = [musicPlayer currentTime];
    [_musicTime setStringValue:[NSString stringWithFormat:@"%@",music1.musicTime]];
    [_currentTime setStringValue:[self getFormateTimeString:currentTime]];
    double percent = (currentTime/music1.musicRealTime)*100;
    [self count:percent];
}
-(void) playMusic
{
    [self play:musicPlayingPosition];
    [self updatePlayProgress];

}


-(void)count :(double) percent{
    NSLog(@"%lf",percent);
    if (percent<= 100) {
        [progressIndicator setProgressValue:  percent];
    }
    
}

-(void) updatePlayProgress
{
    [self removeCurrentTime];
    if (!currentTimer) {
        currentTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateMusicPlayingTime:) userInfo:nil repeats:YES];
        
    }
    
}

-(void)removeCurrentTime
{
    if (!currentTimer) {
        [currentTimer invalidate];
        //把定时器清空
        currentTimer=nil;
    }
    
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


-(void) play : (NSInteger) position
{
    if (position < songList.count && songList!=nil) {
        Music *music = [songList objectAtIndex:position];
        NSString *path = [music musicPathURL];
        NSURL *url = [NSURL fileURLWithPath:path];
        if (musicPlayer) {
            if (musicPlayingPosition == position) {
                if ([musicPlayer isPlaying]) {
                    [musicPlayer pause];
                }else
                {
                    [musicPlayer play];
                    
                }
            }else
            {
                musicPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil] ;
                musicPlayer.delegate=self;
                [musicPlayer play];
//                [musicPlayer setVolume:[_volumeSlider floatValue]];
                musicPlayingPosition = position;
                NSLog(@"time : %@",music.musicTime);
//                [_musicTime setStringValue:[NSString stringWithFormat:@"%@/%@",[self getFormateTimeString:[musicPlayer currentTime]],music.musicTime]];
                
                
            }
        }
        else
        {
            musicPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil] ;
            musicPlayer.delegate=self;
            [musicPlayer play];
//            [musicPlayer setVolume:[_volumeSlider floatValue]];
            musicPlayingPosition = position;
//            [_musicTime setStringValue:[NSString stringWithFormat:@"%@/%@",[self getFormateTimeString:[musicPlayer currentTime]],music.musicTime]];
        }
        
    }
    
    if ([musicPlayer isPlaying]) {
        [_play setImage:[NSImage imageNamed:@"state_play_puse_normal"]];
        [_play setAlternateImage:[NSImage imageNamed:@"state_play_puse_pressed"]];
    }else
    {
        [_play setImage:[NSImage imageNamed:@"state_play_normal"]];
        [_play setAlternateImage:[NSImage imageNamed:@"state_play_pressed"]];
    }
    
    [PusicUserDefaults setLastPlaySongPosition:(int)position];
    
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (!isCirculate) {
        if (isRandom) {
            musicPlayingPosition = arc4random()%[songList count];
        }else {
            musicPlayingPosition+=1;
        }
        
       
        
    }
     music  = [songList objectAtIndex:(musicPlayingPosition)];
     [self updateInfo];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:musicPlayingPosition];
//    [_musicTableView  selectRowIndexes:set byExtendingSelection:NO];
    NSString *path = [(Music *)songList[musicPlayingPosition] musicPathURL];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    musicPlayer = [[AVAudioPlayer alloc ]initWithContentsOfURL:url error:nil];
    musicPlayer.delegate=self;
//    [musicPlayer setVolume:[_volumeSlider floatValue]];
    [_window setTitle:[[songList objectAtIndex:musicPlayingPosition] musicName]];
    [musicPlayer play];
     [PusicUserDefaults setLastPlaySongPosition:musicPlayingPosition];
}


@end
