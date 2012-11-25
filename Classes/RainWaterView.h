//
//  RainWaterView.h
//  WeatherMagic
//
//  Created by jimneylee on 10-12-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//输出log信息
//#define DEBUG_MODE
#import "MacroDefines.h"
#import <UIKit/UIKit.h>

@interface RainWaterView : UIImageView {
	CGPoint currentVelocity;		//速度
	CGPoint	currentAcceleration;	//加速度
	CGPoint maxCenterPos;			//可移动到的最大位置
	
	CGSize	deltaSize;				//缩放比例大小
}
- (void)reset;
- (void)updatePos;
+ (void)setTimerInterval:(CGFloat)interval;
+ (void)setScreenSizeWithOrientation:(UIInterfaceOrientation)toOrientation;

@end
