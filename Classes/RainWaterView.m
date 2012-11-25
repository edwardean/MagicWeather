//
//  RainWaterView.m
//  WeatherMagic
//
//  Created by jimneylee on 10-12-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RainWaterView.h"

#import "RandValue.h"
#import "MacroDefines.h"

//重力加速度
static const CGFloat kGravityAcceleration = 20.0f;

//能量剩余率
static const CGFloat kEnergyRemainRate = 0.8f;

//运动速度的最小值
static const CGFloat kMinSpeed = 2.0f;

//一个周期运动最小距离
static const CGFloat kMinDistance = 2.0f;

//背景图片数
static const int kImageCount = 7;

//初始速度范围
static const CGFloat KMinStartSpeed = 10.0f;
static const CGFloat KMaxStartSpeed = 100.0f;

//动画消失时间
static const CGFloat kDisapperDuration = 2.0f;

//显示最大时间
static const CGFloat kAppearDuration = 2.0f;

//最短缩放时间
static const CGFloat kMinScaleTime = 3.0;

//运动最大范围，右下角
static CGSize sScreenSize;

//定时器间隔，静态类变量
static CGFloat sTimerInterval = 0.0;
@interface RainWaterView(hidden)
- (CGPoint)createRandomPos;
- (UIImage*)createRandomImage;
- (void)bouncingAnimation;
- (void)disappearAnimation;
- (void)appearAnimation;
@end

@implementation RainWaterView

- (id)init{
    if ((self = [super init])) {
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
	srand(time(0));
	self.image = [self createRandomImage];
	[self setFrame:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
	
	//默认竖版，可到达最大位置
	maxCenterPos = CGPointMake(sScreenSize.width - self.frame.size.width/2, sScreenSize.height - self.frame.size.height/2);
	
	//获得初始位置
	CGPoint startPos = [self createRandomPos];
	self.center = startPos;
	
	//初始速度 
	//currentVelocity = [self createRandomVelocity];
	currentVelocity = CGPointZero;
	
	//加速度正值
	currentAcceleration = CGPointMake(0, kGravityAcceleration);
}
/*
 *随机产生光圈背景图片号，返回对应的图片对象
 */
- (UIImage*)createRandomImage{
	
	NSUInteger imageIndex = [RandValue createRandomsizeValueInt:1 toInt:kImageCount];

	NSString *imageName = [NSString stringWithFormat:@"rain%d", imageIndex];
	NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
	UIImage  *image = [UIImage imageWithContentsOfFile:path];
	if (image == nil) {
		[NSException raise:@"read image error" format:@"can not get snow image!"];
	}
	//确定小时时间跟编号一致
	NSInteger scaleCycles = (kMinScaleTime + imageIndex) / sTimerInterval;
	deltaSize = CGSizeMake(image.size.width / scaleCycles, image.size.height / scaleCycles);
	DebugLog(@"delta.size = %f, %f", deltaSize.width, deltaSize.height);
	return image;
}

/*
 *随机产生视图的初始位置
 *注意：要对值进行范围矫正
 */
- (CGPoint)createRandomPos{
	CGPoint pos;
	pos.x = [RandValue createRandomsizeValueFloat:self.frame.size.width/2 toFloat:maxCenterPos.x];
	pos.y = [RandValue createRandomsizeValueFloat:self.frame.size.width/2 toFloat:maxCenterPos.y];
	
	return pos;
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
	//雨点下落同时变小
	CGRect rect = self.frame;
	rect.size = CGSizeMake(rect.size.width - deltaSize.width, rect.size.height - deltaSize.height);
	self.frame = rect;
	
	//消失：出了底边界，则重设信息
	//todo:添加处理其它边界同样处理
	if (self.frame.origin.y  > sScreenSize.height
		|| self.frame.origin.y  < 0.0
		|| self.frame.origin.x  > sScreenSize.width
		|| self.frame.origin.x  < 0.0) {
		[self reset];
		return;
	}
	
	//每个周期位移改变值
	// deltaX = Vx * t
	// deltaY = V0y * t + (1/2) * a * t^2
	// deltaPos = (deltaX, deltaY)
	CGSize deltaPos;
	deltaPos.width = currentVelocity.x * sTimerInterval;
	deltaPos.height = currentVelocity.y * sTimerInterval + 0.5 * currentAcceleration.y * sTimerInterval * sTimerInterval;//1/2 = 0.5
	
	CGPoint nextPos;
	nextPos = CGPointMake(self.center.x + deltaPos.width, self.center.y + deltaPos.height);
	
	//更新实时速度
	currentVelocity.y = currentVelocity.y + currentAcceleration.y * sTimerInterval;
	self.center = nextPos;
}

#pragma mark -
#pragma mark Class static method
+ (void)setTimerInterval:(CGFloat)interval{
	sTimerInterval = interval;
}

/*
 *根据横竖屏设置
 */
+ (void)setScreenSizeWithOrientation:(UIInterfaceOrientation)toOrientation{
	if (UIInterfaceOrientationIsPortrait(toOrientation)){
		sScreenSize = SCREEN_SIZE;
	}
	else{
		sScreenSize = CGSizeMake(SCREEN_SIZE.height, 
								 SCREEN_SIZE.width);
	}
	
}

- (void)dealloc {
    [super dealloc];
}


@end
