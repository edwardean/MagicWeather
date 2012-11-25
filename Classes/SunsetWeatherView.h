//
//  StartView.h
//  PlaneDodge
//
//  Created by jimneylee on 10-7-29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//输出log信息
//#define DEBUG_MODE
#import "MacroDefines.h"

#import <UIKit/UIKit.h>

//自定义UIView类别
#import "UIView+Extend.h"
@interface SunsetWeatherView : UIView
{ 
	//动画视图
	UIImageView*		backgroundImageView;
	
	//定时器
	NSTimer*			particleTimer;
	
	//子弹视图数组
	NSMutableArray*		particleViews;
	
	UIInterfaceOrientation screenOrientation;

}
@property (nonatomic, retain) UIImageView		*backgroundImageView;
//- (id)initWithOrientation:(UIInterfaceOrientation)orientation;
//- (void)resetWithOrientation:(UIInterfaceOrientation)orientation;
//- (void)stopTimer;

//static method
- (CGFloat)RotateAngle:(CGPoint)pointOne pointtwo:(CGPoint)pointTwo angle:(CGFloat)angle1;
@end

