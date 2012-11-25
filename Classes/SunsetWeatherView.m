//
//  StartView.m
//  PlaneDodge
//
//  Created by jimneylee on 10-7-29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "SunsetWeatherView.h"
#import <QuartzCore/QuartzCore.h>
#import "RandValue.h"

#import "FireFlyView.h"


#pragma mark -
#pragma mark privateMethod
@interface SunsetWeatherView(privateMethod)
- (void)updateViewsPos;

- (void)bgMoveAnimation;

// 产生精灵 
- (void)createBullets;


@end

#define BG_MOVE_TIME			30.0
#define PARTICAL_TIMER_INTERVAL	0.05
#define FIRE_FLY_COUNT			30
#define BG_IMAGE_NAME @"sunset_bg.png"

@implementation SunsetWeatherView
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
		UIImage *image = [UIImage imageNamed:BG_IMAGE_NAME];
		backgroundImageView = [[UIImageView alloc] initWithImage:image];		
		[self addSubview:backgroundImageView];
		
		//背景移动动画
		[self bgMoveAnimation];
		
		particleViews = [[NSMutableArray alloc] initWithCapacity:FIRE_FLY_COUNT];
		
		//生成新的bullet，存入数组
		//横竖转换时，设置最大下落位置
		[FireFlyView setScreenSizeWithOrientation:screenOrientation];

		for (int count = 0; count < FIRE_FLY_COUNT; ++count)
		{
			FireFlyView* fireFlyView = [[FireFlyView alloc] init];
			[particleViews addObject:fireFlyView];
			[self addSubview:fireFlyView];
			[fireFlyView release];
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
	UIImage *image = [UIImage imageNamed:BG_IMAGE_NAME];
	[self.backgroundImageView removeFromSuperview];
	
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
	self.backgroundImageView = bgImageView;
	[bgImageView release];
	[self insertSubview:self.backgroundImageView atIndex:0];
	
	//背景移动动画
	[self bgMoveAnimation];
	
	//重设光圈信息
	//横竖转换时，设置最大下落位置
	[FireFlyView setScreenSizeWithOrientation:screenOrientation];

	for (FireFlyView* fireFlyView in particleViews) {
		[fireFlyView reset];
	}

	particleTimer = [NSTimer scheduledTimerWithTimeInterval:PARTICAL_TIMER_INTERVAL target:self selector:@selector(updateViewsPos) userInfo:nil repeats:YES];
	
}
#pragma mark -
#pragma mark timer action
/*
 *定时器的动作函数，主要工作：
 *移动所有的精灵
 *判断是否出界
 */
- (void)updateViewsPos
{
	// 对子弹数组判断，是否越界！
	for (int count = 0; count < [particleViews count]; ++count)
	{
		FireFlyView* fireFlyView = [particleViews objectAtIndex:count];
		CGFloat centerX, centerY;
		centerX = fireFlyView.center.x + fireFlyView.m_vectorSpeed.x;
		centerY = fireFlyView.center.y +fireFlyView.m_vectorSpeed.y;
		fireFlyView.center = CGPointMake(centerX, centerY);
		
		//判断子弹是否已出界，若出界，从数组中替换，移除旧的子弹视图
		if (centerX < 0 || centerX > self.frame.size.width || centerY < 0 || centerY > self.frame.size.height)
		{
			DebugLog(@"reset bullet....");
			[fireFlyView reset];
		}
	}
}


- (void)bgMoveAnimation{
	[UIView beginAnimations:@"bgMoveAnimation" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:BG_MOVE_TIME];
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
#pragma mark -
#pragma mark algorithm
- (CGFloat)RotateAngle:(CGPoint)pointOne pointtwo:(CGPoint)pointTwo angle:(CGFloat)angle1
{
	CGFloat angle2;
	if (pointOne.x == pointTwo.x)
	{
		if (pointOne.y<pointTwo.y)
		{
			angle2=M_PI_2;
		}
		else
		{
			angle2=-M_PI_2;
		}
	}
	else 
	{
		CGFloat k2 = (pointTwo.y - pointOne.y)/(pointTwo.x - pointOne.x);
		if (pointOne.x<pointTwo.x) 
		{
			angle2 = atan(k2);
		}
		else
		{
			angle2 = atan(k2)-M_PI;
		}		
	}
	return (angle2 - angle1);
}

#pragma mark -
#pragma mark dealloc

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
