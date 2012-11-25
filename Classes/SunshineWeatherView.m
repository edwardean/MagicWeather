//
//  SunshineWeatherView.m
//  WeatherMagic
//
//  Created by jimneylee on 10-12-16.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SunshineWeatherView.h"
#import "BlurringView.h"
#import <QuartzCore/QuartzCore.h>
@interface SunshineWeatherView(private)
- (void)bgMoveAnimation;
- (void)updateViewsPos;
@end

#define BLURRING_COUNT  10
#define PARTICAL_TIMER_INTERVAL 0.05f
#define BG_MOVE_CYCLE 30
#define SUNSHINE_BG_NAME @"sunshine_bg.jpg"

@implementation SunshineWeatherView
@synthesize backgroundImageView;
#pragma mark init reset & dealloc
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
		UIImage *image = [UIImage imageNamed:SUNSHINE_BG_NAME];
		backgroundImageView = [[UIImageView alloc] initWithImage:image];		
		[self addSubview:backgroundImageView];
		
		//背景移动动画
		[self bgMoveAnimation];
		
		//横竖转换时，设置最大下落位置
		[BlurringView setScreenSizeWithOrientation:screenOrientation];
		[BlurringView setTimerInterval:PARTICAL_TIMER_INTERVAL];		
		
		particleViews = [[NSMutableArray alloc] initWithCapacity:BLURRING_COUNT];
		for (int i = 0; i < BLURRING_COUNT; ++i) {
			BlurringView* blurringView = [[BlurringView alloc] init];
			[self addSubview:blurringView];
			[particleViews addObject:blurringView];
			[blurringView release];
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
	UIImage *image = [UIImage imageNamed:SUNSHINE_BG_NAME];
	[self.backgroundImageView removeFromSuperview];
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
	self.backgroundImageView = bgImageView;
	[bgImageView release];
	[self insertSubview:self.backgroundImageView atIndex:0];
	
	//背景移动动画
	[self bgMoveAnimation];
	
	//横竖转换时，设置最大下落位置
	[BlurringView setScreenSizeWithOrientation:screenOrientation];
	
	//重设光圈信息
	for (BlurringView* blurringView in particleViews) {
		[blurringView reset];
	}
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

#pragma mark View animation


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

#pragma mark thread timer action
/*
 * 定时器放入独立线程 
 */
- (void)createTimerThread{
	NSThread *timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(startTimerThead) object:nil];
	[timerThread start];
}
- (void)startTimerThead{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	//create timer
	[NSTimer scheduledTimerWithTimeInterval:PARTICAL_TIMER_INTERVAL target:self selector:@selector(updateViewsPos) userInfo:nil repeats:YES];
	[runLoop run];
	[pool release];
}
/*
 * todo:将定时器动作放入独立线程，提高执行优先级
 */
- (void)updateViewsPos{
	//如果所有视图没有都生成，随机生成几个
	for (BlurringView *view in particleViews) {
		[view updatePos];
	}
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

@end
