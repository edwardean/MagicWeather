/*
 *  MacroDefines.h
 *  WeatherMagic
 *
 *  Created by jimneylee on 10-12-14.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#ifdef DEBUG_MODE
#define DebugLog(log, ...) NSLog(log, ## __VA_ARGS__)

//详细的log信息，包括log所在的类对象地址、对象名、.m文件内行号
//#define DebugLogDetail( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

//不输出log信息
#define DebugLog( s, ... ) 

#endif

// 天气类型独立测试标志
#define DEBUG_SPECIAL_WEATHER 0

#define SCREEN_SIZE CGSizeMake(768, 1024)
#define SCREEN_WIDHT		768
#define SCREEN_HEIGHT		1024
#define SCREEN_FRAME		[UIScreen mainScreen].bounds

//#define SHOOT_IMAGES_COUNT 7
//#define SHOOT_DURATION 2.0f

typedef enum{
	BOUNCING_NOE,
	BOUNCING_DOWN,
	BOUNCING_UP
}BouncingDirection;

//TODO:
//定义一个enum表示当前天气类型
typedef enum{
	WEATHER_NONE,
	
	WEATHER_SUNSHINE,
	WEATHER_RAINY,
	WEATHER_CLOUDY,
	WEATHER_FOGGY,
	WEATHER_SNOWY,
	WEATHER_SUNSET
}WeatherType;

//定义一个enum表示移动方向
typedef enum{
	MOVE_NONE,
	
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_TOP,
	MOVE_BOTTOM
}BGMoveDirection;