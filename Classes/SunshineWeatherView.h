//
//  SunshineWeatherView.h
//  WeatherMagic
//
//  Created by jimneylee on 10-12-16.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//输出log信息
//#define DEBUG_MODE
#import "MacroDefines.h"
#import <UIKit/UIKit.h>

//自定义UIView类别
#import "UIView+Extend.h"

@interface SunshineWeatherView : UIView {
	UIImageView		*backgroundImageView;
	NSMutableArray	*particleViews;
	
	NSTimer			*particleTimer;
	UIInterfaceOrientation screenOrientation;
}
@property (nonatomic, retain) UIImageView		*backgroundImageView;
//- (id)initWithOrientation:(UIInterfaceOrientation)orientation;
//- (void)resetWithOrientation:(UIInterfaceOrientation)orientation;
//- (void)stopTimer;
@end
