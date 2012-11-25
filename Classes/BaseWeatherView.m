//
//  BaseWeatherView.m
//  WeatherMagic
//
//  Created by jimneylee on 10-12-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseWeatherView.h"


@implementation BaseWeatherView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

/*
 *视图根据当前横竖屏状态，初始化相关信息
 */
- (id)initWithOrientation:(UIInterfaceOrientation)orientation{
    if ((self = [super init])) {
        // Initialization code
	}
	return self;
}

/*
 *视图根据当前横竖屏状态，重设相关信息
 */
- (void)resetWithOrientation:(UIInterfaceOrientation)orientation{	
}

/*
 *定时器更新粒子元素的位置信息
 */
- (void)updateViewsPos{

}

/*
 *背景移动动画
 */
- (void)bgMoveAnimation{
}


- (void)stopTimer{
	if (particleTimer != nil) {
		[particleTimer invalidate];
		particleTimer = nil;
	}
}

- (void)restartTimer{
	[self stopTimer];
//	particleTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(updateViewsPos) userInfo:nil repeats:YES];
}

- (void)dealloc {
	if (particleTimer != nil) {
		[particleTimer invalidate];
	}
	[backgroundImageView release];
	[particleViews release];
    [super dealloc];
}


@end
