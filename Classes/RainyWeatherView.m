//
//  RainyWeatherView.m
//  WeatherMagic
//
//  Created by jimneylee on 10-12-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RainyWeatherView.h"

#import "RainWaterView.h"
#import "MacroDefines.h"
#import <QuartzCore/QuartzCore.h>
@interface RainyWeatherView(private)
- (void)bgMoveAnimation;
- (void)updateViewsPos;
@end

#define PARTICAL_COUNT		50
#define PARTICAL_TIMER_INTERVAL 0.05f
#define BG_MOVE_CYCLE 30
#define BG_NAME @"rainy_bg.jpg"
@implementation RainyWeatherView
@synthesize backgroundImageView;
- (id)initWithOrientation:(UIInterfaceOrientation)orientation{
    if ((self = [super init])) {
        // Initialization code
		screenOrientation = orientation;
		if (UIInterfaceOrientationIsPortrait(screenOrientation)){
			[self setFrame:SCREEN_FRAME];
		}
		else{
			[self setFrame:CGRectMake(0, 0, SCREEN_FRAME.size.height, SCREEN_FRAME.size.width)];
		}
		
		//设置背景
		UIImage *image = [UIImage imageNamed:BG_NAME];
		backgroundImageView = [[UIImageView alloc] initWithImage:image];		
		[self addSubview:backgroundImageView];
		//背景移动动画
		[self bgMoveAnimation];
		
		particleViews = [[NSMutableArray alloc] initWithCapacity:PARTICAL_COUNT];
		//横竖转换时，设置最大下落位置
		[RainWaterView setScreenSizeWithOrientation:screenOrientation];
		[RainWaterView setTimerInterval:PARTICAL_TIMER_INTERVAL];	
		
		for (int i = 0; i < PARTICAL_COUNT; ++i) {
			RainWaterView* view = [[RainWaterView alloc] init];
			[self addSubview:view];
			[particleViews addObject:view];
			[view release];
		}
		
		particleTimer = [NSTimer scheduledTimerWithTimeInterval:PARTICAL_TIMER_INTERVAL target:self selector:@selector(updateViewsPos) userInfo:nil repeats:YES];
		
	}
    return self;
}

- (void)resetWithOrientation:(UIInterfaceOrientation)orientation{	
	screenOrientation = orientation;
	if (UIInterfaceOrientationIsPortrait(screenOrientation)){
		[self setFrame:SCREEN_FRAME];
	}
	else{
		[self setFrame:CGRectMake(0, 0, SCREEN_FRAME.size.height, SCREEN_FRAME.size.width)];
	}
	//关闭定时器
	if (particleTimer != nil) {
		[particleTimer invalidate];
	}
	//设置背景
	[backgroundImageView.layer removeAllAnimations];
	UIImage *image = [UIImage imageNamed:BG_NAME];
	[self.backgroundImageView removeFromSuperview];
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
	self.backgroundImageView = bgImageView;
	[bgImageView release];
	[self insertSubview:self.backgroundImageView atIndex:0];
	
	//背景移动动画
	[self bgMoveAnimation];
	
	//横竖转换时，设置最大下落位置
	[RainWaterView setScreenSizeWithOrientation:screenOrientation];
	
	//重设雪花信息	
	for (RainWaterView* view in particleViews) {
		[view reset];
	}
	
	particleTimer = [NSTimer scheduledTimerWithTimeInterval:PARTICAL_TIMER_INTERVAL target:self selector:@selector(updateViewsPos) userInfo:nil repeats:YES];
	
}
- (void)updateViewsPos{
	DebugLog(@"%s", _cmd);
	//如果所有视图没有都生成，随机生成几个
	for (RainWaterView *view in particleViews) {
		[view updatePos];
	}
}
- (void)bgMoveAnimation{
	[UIView beginAnimations:@"bgMoveAnimation" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:BG_MOVE_CYCLE];
	[UIView setAnimationRepeatAutoreverses:YES];
	[UIView setAnimationRepeatCount:FLT_MAX];
	//竖屏横移 横屏纵移
	if (UIInterfaceOrientationIsPortrait(screenOrientation)){
		backgroundImageView.transform = CGAffineTransformMakeTranslation(SCREEN_FRAME.size.width - backgroundImageView.frame.size.width, 0);
	}
	else{
		backgroundImageView.transform = CGAffineTransformMakeTranslation(0, SCREEN_FRAME.size.width - backgroundImageView.frame.size.height);
	}
	[UIView commitAnimations];
}

- (void)stopTimer{
	if (particleTimer != nil) {
		[particleTimer invalidate];
		particleTimer = nil;
	}
}
- (void)restartTimer{
	[self stopTimer];
	particleTimer = [NSTimer scheduledTimerWithTimeInterval:PARTICAL_TIMER_INTERVAL target:self selector:@selector(updateViewsPos) userInfo:nil repeats:YES];
}
- (void)dealloc {
	DebugLog(@"snow release");
	if (particleTimer != nil) {
		[particleTimer invalidate];
	}
	[backgroundImageView release];
	[particleViews release];
    [super dealloc];
}


@end