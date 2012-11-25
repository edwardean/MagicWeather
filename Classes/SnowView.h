//
//  SnowView.h
//  WeatherMagic
//
//  Created by jimneylee on 10-12-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefines.h"

@interface SnowView : UIImageView {
	CGPoint currentVelocity;		//当前速度
	CGPoint	currentAcceleration;	//当前加速度
	CGPoint maxCenterPos;			//当前可移动到的最大位置	
}
- (void)reset;
- (void)updatePos;
+ (void)setTimerInterval:(CGFloat)interval;
+ (void)setScreenSizeWithOrientation:(UIInterfaceOrientation)toOrientation;

@end
