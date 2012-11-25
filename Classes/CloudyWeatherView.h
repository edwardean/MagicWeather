//
//  CloudyWeatherView.h
//  WeatherMagic
//
//  Created by jimneylee on 10-12-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//输出log信息
//#define DEBUG_MODE
#import "MacroDefines.h"
#import <UIKit/UIKit.h>

//自定义UIView类别
#import "UIView+Extend.h"

@interface CloudyWeatherView : UIView {
	UIImageView		*backgroundImageView;
	
	NSTimer			*particleTimer;

	UIInterfaceOrientation screenOrientation;

}
@property (nonatomic, retain) UIImageView		*backgroundImageView;

@end
