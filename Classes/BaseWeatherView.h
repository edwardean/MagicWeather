//
//  BaseWeatherView.h
//  WeatherMagic
//
//  Created by jimneylee on 10-12-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Extend.h"

@interface BaseWeatherView : UIView {
    
	UIImageView		*backgroundImageView;
	NSMutableArray	*particleViews;
	
	NSTimer			*particleTimer;
	UIInterfaceOrientation screenOrientation;

}

@end
