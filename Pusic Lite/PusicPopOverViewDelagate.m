//
//  PusicPopOverViewDelagate.m
//  Pusic
//
//  Created by peter on 15/4/22.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "PusicPopOverViewDelagate.h"
#import "PusicStatusBarViewController.h"
#import "PusicStatusBarListViewController.h"
@implementation PusicPopOverViewDelagate
@synthesize popOver;
-(id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void) showPopover:(id)sender musicInfo:(Music *)music
{
    NSLog(@"%ldd",_viewThmeNum);
    if(!viewController){
      if (_viewThmeNum ==2) {
        viewController = [[PusicStatusBarListViewController alloc] init];
        
        }else {
            viewController = [[PusicStatusBarViewController alloc] initWithNibName:@"PusicStatusBarViewController" bundle:[NSBundle mainBundle]];
        }
    }
        if (popOver ==nil) {
        popOver = [NSPopover new];
        popOver.delegate =self;
//        popOver.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
        popOver.contentViewController = viewController;
        popOver.behavior = NSPopoverBehaviorTransient;
    }
    NSLog(@"musicName:%@",music.musicName);
    if ([viewController isKindOfClass:[PusicStatusBarViewController class]]) {
        PusicStatusBarViewController *controller;
        controller = (PusicStatusBarViewController *) viewController;
        controller.music = music;
    }
    else if ([viewController isKindOfClass:[PusicStatusBarListViewController class]]){
        PusicStatusBarListViewController *controller1;
        controller1 = (PusicStatusBarListViewController *) viewController;
        controller1.music = music;
    }
    
    [popOver showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
}

- (void)popoverDidClose:(NSNotification *)notification {
    popOver = nil;
}

//- (NSWindow *)detachableWindowForPopover:(NSPopover *)popover {
//    return detachWindow;
//}

- (BOOL)popoverShouldDetach:(NSPopover *)popover {
    return YES;
}
@end
