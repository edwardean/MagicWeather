//
//  BasePaticalView.h
//  WeatherMagic
//
//  Created by jimneylee on 10-12-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*	物理运动的基本算法：
 *		v^2		 = (1/2)a(t^2)				重力加速度表达式
 *		mah		 = (1/2)m(v^2)*(rate^n)		势能<＝>动能
 *	 ==>h = F(t) = (t^2)*(rate^n)/4			实时高度h关于时间t的表达式
 *   
 *	rate为能量剩余率
 *
 *	使用定时器时，分为下降（falldown）和上升（raiseup）两个过程
 *	下降(falldown): S = (1/2)(at^2) a为重力加速度g的倍数
 *				   如果S比当前可下落最大高度还大，则回弹,高度 ＝ 当前高度 * rate率
 *					
 *	上升(raiseup):  V = sqrt(2gh)
 *				   S = V*t + (1/2)(at^2)
 *				   如果Vmax - at < 0.0 上升到最高点
 *
 *	a为重力加速度g的倍数,V为当前下落到最低点的最大速度，rate为反弹后能量损失率
 *  cycles为上下来回运动周期
 *	================================================================
 *	另一种方法：
 *	deltaX = Vx * t
 *	deltaY = V0y * t + (1/2) * a * t^2
 *	deltaPos = (deltaX, deltaY)
 *
 *	与各个壁碰撞过程：
 *	上下壁：Vx不变 Vy * rate
 *	左右壁：Vy不变 Vx * rate
 */

//todo:引入手指交互的引力和斥力模型，加入物体当前的速度和加速度，能够更方便低模拟物理碰撞模型

@interface BasePaticalView : UIView {
	
	CGPoint currentVelocity;		//当前速度
	CGPoint	currentAcceleration;	//当前加速度
	CGPoint maxCenterPos;			//当前可移动到的最大位置
}
- (void)reset;
- (void)updatePos;

+ (void)setTimerInterval:(CGFloat)interval;
+ (void)setScreenSizeWithOrientation:(UIInterfaceOrientation)toOrientation;

@end
