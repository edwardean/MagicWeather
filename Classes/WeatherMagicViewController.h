//
//  WeatherMagicViewController.h
//  WeatherMagic
//
//  Created by jimneylee on 10-12-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//输出log信息
#define DEBUG_MODE
#import "MacroDefines.h"
#import <UIKit/UIKit.h>

@class WeatherView;
@interface WeatherMagicViewController : UIViewController {

	WeatherType		todayWeather;
	
	UIImageView		*startImageView;

	NSThread		*timerThread;
	
	WeatherView	*weatherView;
	
	UIView			*currentShowView;
	
	NSString		*dayWeatherInfo;
}
@property (nonatomic,retain) UIView			*currentShowView;
@property (nonatomic,retain) WeatherView	*weatherView;
@end

