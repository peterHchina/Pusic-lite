//
//  PreferenceController.m
//  Pusic Lite
//
//  Created by peter on 15/5/10.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "PreferenceController.h"
#import "PusicUserDefaults.h"
#import <QuartzCore/QuartzCore.h>
@interface PreferenceController ()
{
    CAShapeLayer * layer;
    CABasicAnimation * anima;
}
@end



@implementation PreferenceController

-(NSString *)windowNibName
{
    return  @"PreferenceController";
}

-(void) awakeFromNib
{
   
    
    NSInteger isShowAppIcon = [PusicUserDefaults getShowIcon];
    if (isShowAppIcon == 1) {
        [self.isShowAppIcon setState:NSOnState];
    }
    else {
        [self.isShowAppIcon setState:NSOffState];
    }
}


- (void)windowDidLoad {
    [super windowDidLoad];
    _themeButton1.wantsLayer = YES;
    _themeButton1.layer.masksToBounds = YES;
    _themeButton1.layer.cornerRadius = 5.0f;
    _themeButton1.layer.borderColor = [NSColor whiteColor].CGColor;
    _themeButton1.layer.borderWidth = .5f;
    
    _themebutton2.wantsLayer = YES;
    _themebutton2.layer.masksToBounds = YES;
    _themebutton2.layer.cornerRadius = 5.0f;
    _themebutton2.layer.borderColor = [NSColor whiteColor].CGColor;
    _themebutton2.layer.borderWidth = .5f;
    
    
    NSUInteger theme = [PusicUserDefaults getTheme];
    if (theme == 1) {
        _themeButton1.image = [NSImage imageNamed:@"theme1"];
        [self drawAnimationForSelection:_themeButton1];
        
    }else if (theme == 2)
    {
        _themebutton2.image = [NSImage imageNamed:@"theme2"];
        [self drawAnimationForSelection:_themebutton2];
    }

//    NSCollectionView 
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}



- (IBAction)setThemeSimple:(id)sender {
    [PusicUserDefaults setTheme:1];
    _themeButton1.image = [NSImage imageNamed:@"theme1"];
    _themebutton2.image = [NSImage imageNamed:@"theme2_ok"];
    [self clearAnimationLayer:_themebutton2];
    [self drawAnimationForSelection:_themeButton1];

}
- (IBAction)setThemeList:(id)sender {
    [PusicUserDefaults setTheme:2];
    _themeButton1.image = [NSImage imageNamed:@"theme1_ok"];

    _themebutton2.image = [NSImage imageNamed:@"theme2"];
    [self clearAnimationLayer:_themeButton1];

    [self drawAnimationForSelection:_themebutton2];
}

- (IBAction)showAppIcon:(id)sender {
    NSUInteger state = [sender state];
    // 根据复选框是否选中，设置用户值，并且改变程序运行状态。
    if (state == NSOnState) {
        ProcessSerialNumber psn = { 0, kCurrentProcess };
        TransformProcessType(&psn, kProcessTransformToUIElementApplication);
        [PusicUserDefaults setShowIcon:1];
    }
    else {
       [PusicUserDefaults setShowIcon:0];
        ProcessSerialNumber psn = { 0, kCurrentProcess };
        TransformProcessType(&psn, kProcessTransformToForegroundApplication);
    }
}


-(NSImage *) getRadiusImageFormOneImage:(NSImage *) image Radius:(float) radius
{
    CGContextRef *ref = [[NSGraphicsContext currentContext] graphicsPort];
    return nil;
//    UIGraphicsBeginImageContextWithOptions
    
}


-(void) drawAnimationForSelection:(NSView *) view
{
        
        //    CGContextRef
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGFloat x = view.frame.size.width/2;
        CGFloat y = view.frame.size.height/2;
        CGPoint center = CGPointMake(x, y);
        CGFloat max = x-10;
        CGFloat may = y-5;
        
        
        CGPathAddArc(path, NULL, x, y, x/2, 0, 2*M_PI, NO);
        CGPathMoveToPoint(path, NULL, max-10, may+5);
        CGPathAddLineToPoint(path, NULL, max, may+20);
//        CGPathAddArcToPoint(path, NULL, max+5, may+25, max+10, may+20, 15);
    CGPathAddQuadCurveToPoint(path, NULL, max+3, may+25, max+6, may+20);
        CGPathAddLineToPoint(path, NULL, max+30, may-10);
        
        
    if (!layer) {
        layer = [CAShapeLayer new];
        layer.path = path;
        layer.lineWidth=4.5;
        layer.lineCap = @"round";
        layer.lineJoin =  @"round";
        layer.fillColor = [NSColor clearColor].CGColor;
        layer.strokeColor =  [NSColor colorWithCalibratedRed:31/255.0 green:186/255.0 blue:45/255.0 alpha:1.0].CGColor;
    }
    
    
        
    if (!anima) {
        anima = [CABasicAnimation animation];
        anima.fromValue = @0;
        anima.toValue=@1;
        anima.duration = 2;
        //        anima.repeatCount = MAXFLOAT;
        anima.fillMode = kCAFillModeForwards;
        anima.removedOnCompletion = NO;
        anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        anima.keyPath = NSStringFromSelector(@selector(strokeEnd)) ;
    }
    
       
    
        [layer addAnimation:anima forKey:NSStringFromSelector(@selector(strokeEnd)) ];
        [view.layer addSublayer:layer];
    

}

-(void) clearAnimationLayer:(NSView *) view
{
    if ([view.layer sublayers].count>1) {
        [layer removeFromSuperlayer];
        [layer removeAllAnimations];
    }
}
@end
