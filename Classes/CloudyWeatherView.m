//
//  CloudyWeatherView.m
//  WeatherMagic
//
//  Created by jimneylee on 10-12-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CloudyWeatherView.h"
#import <QuartzCore/QuartzCore.h>
@interface CloudyWeatherView(private)
- (void)bgMoveAnimation;
@end
#define BG_MOVE_CYCLE 30
#define BG_IMAGE_NAME @"cloudy_bg.jpg"
@implementation CloudyWeatherView
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
		
		//图片纵向整屏显示
		CGRect rect = self.backgroundImageView.frame;
		rect.size.height = self.frame.size.height;
		self.backgroundImageView.frame = rect;
		
		//背景移动动画
		[self bgMoveAnimation];
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

	//设置背景
	[backgroundImageView.layer removeAllAnimations];
	UIImage *image = [UIImage imageNamed:BG_IMAGE_NAME];
	[self.backgroundImageView removeFromSuperview];
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
	self.backgroundImageView = bgImageView;
	[bgImageView release];
	[self insertSubview:self.backgroundImageView atIndex:0];
	
	//图片纵向整屏显示
	CGRect rect = self.backgroundImageView.frame;
	rect.size.height = self.frame.size.height;
	self.backgroundImageView.frame = rect;

	//背景移动动画
	[self bgMoveAnimation];
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
		backgroundImageView.transform = CGAffineTransformMakeTranslation(SCREEN_FRAME.size.height - backgroundImageView.frame.size.width, 0);

//		backgroundImageView.transform = CGAffineTransformMakeTranslation(0, SCREEN_FRAME.size.width - backgroundImageView.frame.size.height);
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
//	[self stopTimer];
//	particleTimer = [NSTimer scheduledTimerWithTimeInterval:PARTICAL_TIMER_INTERVAL target:self selector:@selector(updateBlurringViewsPos) userInfo:nil repeats:YES];
}

- (void)dealloc {
	[backgroundImageView release];
    [super dealloc];
}


@end
