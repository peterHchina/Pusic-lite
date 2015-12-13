//
//  PreferenceController.h
//  Pusic Lite
//
//  Created by peter on 15/5/10.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferenceController : NSWindowController
@property (strong) IBOutlet NSButton *themeButton1;
@property (strong) IBOutlet NSButton *themebutton2;
- (IBAction)setThemeSimple:(id)sender;

@property (strong) IBOutlet NSButton *isShowAppIcon;
- (IBAction)setThemeList:(id)sender;
- (IBAction)showAppIcon:(id)sender;

@end
