//
//  BasePaticalView.m
//  WeatherMagic
//
//  Created by jimneylee on 10-12-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BasePaticalView.h"
/*
 *类内部方法
 */
@interface BasePaticalView(hidden)
- (CGPoint)createRandomPos;
- (CGPoint)createRandomVelocity;
- (UIImage*)createRandomImage;
- (BOOL)screenCollision:(CGPoint)nextPos;
@end

@implementation BasePaticalView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.userInteractionEnabled = YES;
		[self reset];
    }
    return self;
}
/*
 *运动停止后，重设所有信息
 */
- (void)reset{
}

/*
 *随机产生光圈背景图片号，返回对应的图片对象
 */
- (UIImage*)createRandomImage{
	return nil;
}

/*
 *随机产生视图的初始位置
 *注意：要对值进行范围矫正
 */
- (CGPoint)createRandomPos{
	return CGPointZero;
}

/*	物理运动的基本算法：
 *	另一种方法：
 *	使用速度和加速度模型模拟物体的物理运动，不仅只有垂直方向的自由落体和反弹运鼎
 *	而是随时模拟物体沿任意方向运动的抛物线运动，同时随时由外界受力影响产生的引力和斥力作用效果
 *	基本思想：在离散的时间间隔内，模拟物体实际运动效果
 *	每个周期横向位移：deltaX = Vx * t
 *	每个周期纵向位移：deltaY = V0y * t + (1/2) * a * t^2
 *	      整体矢量： deltaPos = (deltaX, deltaY)
 *
 *	与各个壁碰撞过程：
 *	上下壁：Vx不变 && Vy反向 Vy * rate
 *	左右壁：Vy不变 && Vx反向 Vx * rate
 */
//todo:引入手指交互的引力和斥力模型，加入物体当前的速度和加速度，能够更方便低模拟物理碰撞模型

- (void)updatePos{
}	

/*
 *与四个边的碰撞检测函数
 */
- (BOOL)screenCollision:(CGPoint)nextPos{
	return YES;
}	

#pragma mark -
#pragma mark class static method
/*
 * 设置定时时间间隔
 */
+ (void)setTimerInterval:(CGFloat)interval{
}

/*
 *根据横竖屏设置
 */
+ (void)setScreenSizeWithOrientation:(UIInterfaceOrientation)toOrientation{
	if (UIInterfaceOrientationIsPortrait(toOrientation)){

	}
	else{

	}
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
