//
//  BulletView.m
//  PlaneDodge
//
//  Created by jimney on 10-7-28.
//  Copyright 2010 YT. All rights reserved.
//

#import "FireFlyView.h"
#import <time.h>
#import "RandValue.h"
#import "MacroDefines.h"

//运动最大范围，右下角
static CGSize sScreenSize;
#pragma mark -
#pragma mark private method
@interface FireFlyView(private)
// 产生随机位置
- (void)createRandomsizePosition;
// 产生随机速度
- (void)createRandomsizeSpeed;

@end
#define BULLET_ANIMATION_NUMBER 3
#define MIN_START_SPEED			0.5
//！ 屏幕四周边长和
#define ALL_LENGTH			3584		//1024＊2 ＋ 768＊2
@implementation FireFlyView
@synthesize m_vectorSpeed;
#pragma mark -
#pragma mark init reset
- (id)init
{
    if ((self = [super init])) 
	{
        // Initialization code
		NSString *path = [[NSBundle mainBundle] pathForResource:@"yh0" ofType:@"png"];
		UIImage* image = [UIImage imageWithContentsOfFile:path];
		
		[self setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
		
		// 使用UIImageView播放一组动画
		m_pImagesArray = [[NSMutableArray alloc] init]; 
		for(int number = 0; number < BULLET_ANIMATION_NUMBER; ++number)
		{
			NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"yh%d", number] 
															 ofType:@"png"];
			UIImage* image = [UIImage imageWithContentsOfFile:path];
			[m_pImagesArray addObject:image];
		}
		self.animationImages		= m_pImagesArray;	//animationImages属性返回一个存放动画图片的数组
		self.animationDuration		= 0.5;				//浏览整个图片一次所用的时间
		self.animationRepeatCount	= 0;				// 0 = loops forever 动画重复次数
		[self startAnimating]; 
		
		// 子弹初始化时，随机获得自身的出入位置和矢量速度
		srand(time(0));
		
		// 获得随机的位置和朝着目标的速度
		[self createRandomsizePosition];
		[self createRandomsizeSpeed];


	}
    return self;
}

//重设位置和速度
- (void)reset//WithPlanes:(PlaneView*)plane_1 plane_2:(PlaneView*)plane_2
{
	// 子弹初始化时，随机获得自身的出入位置和矢量速度
	srand(time(0));
	
	// 获得随机的位置和朝着目标的速度
	[self createRandomsizePosition];
	[self createRandomsizeSpeed];
}


#pragma mark -
#pragma mark create position and speed

- (void)createRandomsizePosition
{
	// 根据四周长度之和 alllenght ＝ 1024＊2 ＋ 768＊2，
	// 可以通过只获得一个随机数，介于（0 － (alllenght-1)）
	// 获得从那个位置产生，节省时间
	
	CGFloat poslength = [RandValue createRandomsizeValueInt:0  toInt:ALL_LENGTH];//(CGFloat)(arc4random() % (ALL_LENGTH + 1));//0 - 3584
	CGFloat x,y;
	x = 0;
	y = 0;
	//竖屏
	if (sScreenSize.width > sScreenSize.height) {
		if (poslength <   SCREEN_WIDHT)							//top side
		{
			x = poslength;
			y = 0;
			m_eStartSide = TOP_SIDE;
		}
		else if(poslength < SCREEN_WIDHT + SCREEN_HEIGHT)		//right side
		{
			x = SCREEN_WIDHT;
			y = poslength - SCREEN_WIDHT;
			m_eStartSide = RIGHT_SIDE;
		}
		else if(poslength < SCREEN_WIDHT*2 + SCREEN_HEIGHT)	//bottom side
		{
			x = poslength - (SCREEN_WIDHT + SCREEN_HEIGHT);
			y = SCREEN_HEIGHT;
			m_eStartSide = BOTTOM_SIDE;
		}
		else													//left side
		{
			x = 0;
			y = poslength - (SCREEN_WIDHT * 2 + SCREEN_HEIGHT);
			m_eStartSide = LEFT_SIDE;
		}		
	}
	//横屏
	else {
		if (poslength <   SCREEN_HEIGHT)							//top side
		{
			x = poslength;
			y = 0;
			m_eStartSide = TOP_SIDE;
		}
		else if(poslength < SCREEN_WIDHT + SCREEN_HEIGHT)		//right side
		{
			x = SCREEN_WIDHT;
			y = poslength - SCREEN_WIDHT;
			m_eStartSide = RIGHT_SIDE;
		}
		else if(poslength < SCREEN_WIDHT + SCREEN_HEIGHT * 2)	//bottom side
		{
			
			x = poslength - (SCREEN_WIDHT + SCREEN_HEIGHT);
			y = SCREEN_HEIGHT;
			m_eStartSide = BOTTOM_SIDE;
		}
		else													//left side
		{
			x = 0;
			y = poslength - (SCREEN_WIDHT + SCREEN_HEIGHT*2);
			m_eStartSide = LEFT_SIDE;
		}
		
	}

	self.center = CGPointMake(x, y);
	
//	NSLog(@"bullet center = (%f, %f)", self.center.x, self.center.y);
	
}
//
- (void)createRandomsizeSpeed
{
	//速度的产生，共使用两个随机数
	//由于在每条边上，垂直边的方向为正，从而保证子弹有进入屏幕内部的趋势
	//与边同方向的可正可负
	CGFloat verticalSpeed, parallelSpeed;
	verticalSpeed = [RandValue createRandomsizeValueFloat:0.0 toFloat:8.0];//arc4random() % BULLET_SPEED + 1;// 1 ~ BULLET_SPEED
	parallelSpeed = [RandValue createRandomsizeValueFloat:-6.0 toFloat:6.0];//arc4random() % (BULLET_SPEED * 2 + 1) - BULLET_SPEED;// -BULLET_SPEED ~ BULLET_SPEED

	CGFloat x,y;
	if (m_eStartSide == TOP_SIDE) 
	{
		x = parallelSpeed;
		y = verticalSpeed;//从上边进入
	}
	else if(m_eStartSide == RIGHT_SIDE)
	{
		x = -verticalSpeed;//从右边进入
		y = parallelSpeed;

	}
	else if(m_eStartSide == BOTTOM_SIDE)
	{
		x = parallelSpeed;
		y = -verticalSpeed;//从下边进入

	}
	else if(m_eStartSide == LEFT_SIDE)
	{
		x = verticalSpeed;//从左边进入
		y = parallelSpeed;
	}
	m_vectorSpeed = CGPointMake(x, y);
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
#pragma mark -
#pragma mark dealloc
- (void)dealloc
{
	[m_pImagesArray removeAllObjects];
	[m_pImagesArray release];
    [super dealloc];
}


@end
