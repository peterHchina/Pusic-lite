//
//  PusicUserDefaults.m
//  Pusic
//
//  Created by peter on 15/4/14.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "PusicUserDefaults.h"
NSString * const BNRLastTimePlayingSong=@"BNRLastTimePlayingSong";
NSString * const BNRIsCirculate=@"BNRCirculate";
NSString *  const BNRIsRandom=@"BNRRandom";
NSString *  const BNRIsList=@"BNRList";
NSString *  const BNRTheme=@"BNRTheme";
NSString *  const BNRIsShowIcon = @"BNRIsShowIcon";
@implementation PusicUserDefaults
+(void) registerUserDefaults
{
    NSMutableDictionary *defaultValues  = [NSMutableDictionary dictionary];
    [defaultValues setValue:[NSNumber numberWithBool:NO] forKey:BNRIsCirculate];
    [defaultValues setValue:[NSNumber numberWithBool:NO] forKey:BNRIsRandom];
    [defaultValues setValue:[NSNumber numberWithBool:YES] forKey:BNRIsList];
    [defaultValues setValue:[NSNumber numberWithInteger:2] forKey:BNRTheme];
    [defaultValues setValue:[NSNumber numberWithInt:0] forKey:BNRLastTimePlayingSong];
    [defaultValues setValue:[NSNumber numberWithInteger:0] forKey:BNRIsShowIcon];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

+( void) setCirculate :(BOOL) circulate
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:circulate] forKey:BNRIsCirculate];
    
}

+(BOOL) getCirculate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:BNRIsCirculate];
}

+( void) setRandom :(BOOL) random
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:random] forKey:BNRIsRandom];
    
}

+(BOOL) getRandom
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:BNRIsRandom];
}

+( void) setTheme:(NSInteger)theme
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithInteger:theme] forKey:BNRTheme];
    
}

+(NSInteger) getTheme
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:BNRTheme];
}

+( void) setList:(BOOL)list
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:list] forKey:BNRIsList];
    
}

+(BOOL) getList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:BNRIsList];
}


+( void) setLastPlaySongPosition :(int) position
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithInt:position] forKey:BNRLastTimePlayingSong];
    
}

+(int) getLastPlaySongPosition
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (int)[defaults integerForKey:BNRLastTimePlayingSong];
}

+(NSInteger) getShowIcon{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:BNRIsShowIcon];
}
+(void) setShowIcon:(NSInteger) isShow{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithInteger:isShow] forKey:BNRIsShowIcon];
}

@end
