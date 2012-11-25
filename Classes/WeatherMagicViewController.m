//
//  WeatherMagicViewController.m
//  WeatherMagic
//
//  Created by jimneylee on 10-12-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WeatherMagicViewController.h"
#import "SnowView.h"
#import "BlurringView.h"
#import "MacroDefines.h"
#import "WeatherView.h"
#import "SunsetWeatherView.h"
#import "SnowWeatherView.h"
#import "SunshineWeatherView.h"
#import "RainView.h"
#import "RainyWeatherView.h"
#import "CloudyWeatherView.h"
#import <QuartzCore/QuartzCore.h>

@interface WeatherMagicViewController(hidden)

- (void)showTodayWeather:(WeatherType)type;
- (WeatherType)getTodayWeatherFromWebService;
- (WeatherType)parseWeatherInfo:(NSString*)weatherInfo;
- (void)showWeatherView;

//weather type
- (void)showSnowyWeather;
- (void)showSunshineWeather;
- (void)showSunSetWeather;
- (void)showRainyWeather;
- (void)showCloudyWeather;

@end


@implementation WeatherMagicViewController

@synthesize currentShowView;
@synthesize weatherView;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
#if DEBUG_SPECIAL_WEATHER
	//测试单独的天气
	todayWeather = WEATHER_SUNSHINE;
#else
	//获得今天天气类型	
	todayWeather = [self getTodayWeatherFromWebService];
#endif
	
	[self showTodayWeather:todayWeather];
	
	//显示天气信息视图
	[self showWeatherView];
}

#pragma mark -
#pragma mark weather view
/*
 *获得当天天气类型
 *
 */
- (WeatherType)getTodayWeatherFromWebService {
    
	WeatherType type = WEATHER_NONE;
    
	@try {
		NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:self options:nil];
		weatherView = [nib objectAtIndex:0];
		
		dayWeatherInfo = [weatherView updateWeatherInfo];
        
		type = [self parseWeatherInfo:dayWeatherInfo];
	}
    
	@catch (NSException * e) {
		NSLog(@"%@", e);
	}
    
	return type;
}
/*
 * 显示天气基本信息视图
 */
- (void)showWeatherView{
	//连接网络，解析天气类型后可显示天气视图
	//if (todayWeather !=  WEATHER_NONE )
	if (weatherView != nil)
	{
		if (weatherView.superview == nil) {
			[self.view addSubview:weatherView];
		}
		[self.view bringSubviewToFront:weatherView];
		
		//横竖控制
		if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
			weatherView.center = CGPointMake(SCREEN_FRAME.size.width / 2, 
											 weatherView.frame.size.height / 2 + 100);
		}
		else{
			weatherView.center = CGPointMake(SCREEN_FRAME.size.height / 2, 
											 weatherView.frame.size.height / 2 + 100);
		}
	}
}

/*
 *解析天气的具体类型
 */
- (WeatherType)parseWeatherInfo:(NSString*)weatherInfo{
	//获得天气关键字，优先顺序：晴、雪、雨、云、雾
	WeatherType type = WEATHER_NONE;
	NSRange range;
	range = [weatherInfo rangeOfString:@"晴"];
	if (range.length > 0) {
		type = WEATHER_SUNSHINE;
		return type;
	}
	
	range = [weatherInfo rangeOfString:@"雪"];
	if (range.length > 0) {
		type = WEATHER_SNOWY;
		return type;
	}
	
	range = [weatherInfo rangeOfString:@"雨"];
	if (range.length > 0) {
		type = WEATHER_RAINY;
		return type;
	}
	
	range = [weatherInfo rangeOfString:@"云"];
	if (range.length > 0) {
		type = WEATHER_CLOUDY;
		return type;
	}
	
	range = [weatherInfo rangeOfString:@"阴"];
	if (range.length > 0) {
		type = WEATHER_CLOUDY;
		return type;
	}
	return type;
}
/*
 *根据天气类型，显示今天的天气
 */
- (void)showTodayWeather:(WeatherType)type{
	switch (type) {
		case WEATHER_SNOWY:
			[self showSnowyWeather];
			break;
            
		case WEATHER_SUNSHINE:
		case WEATHER_NONE:
			[self showSunshineWeather];
			break;
            
		case WEATHER_SUNSET:
			[self showSunSetWeather];
			break;
            
		case WEATHER_RAINY:
			[self showRainyWeather];
			break;	
            
		case WEATHER_CLOUDY:
			[self showCloudyWeather];
			break;
            
			//todo:other weather
		default:
			break;
	}
}

#pragma mark -
#pragma mark each weather type

/*
 * 雪天 漫天飞雪
 */
- (void)showSnowyWeather{
	//首先移除当前视图
	if (self.currentShowView.superview != nil) {
		[self.currentShowView removeFromSuperview];
		[self.currentShowView stopTimer];
	}
    
	SnowWeatherView *snowWeatherView = [[SnowWeatherView alloc] initWithOrientation:self.interfaceOrientation];
	[self.view addSubview:snowWeatherView];
	self.currentShowView = snowWeatherView;
	[snowWeatherView release];
}

/*
 * 雨天 细雨飘飘
 */
- (void)showRainyWeather{
	//首先移除当前视图
	if (self.currentShowView.superview != nil) {
		[self.currentShowView removeFromSuperview];
		[self.currentShowView stopTimer];
	}
	
	//	RainView *rainView = [[RainView alloc] initWithOrientation:self.interfaceOrientation];
	//	[self.view addSubview:rainView];
	//	self.currentShowView = rainView;
	//	[rainView release];
	
	RainyWeatherView *rainyWeatherView = [[RainyWeatherView alloc] initWithOrientation:self.interfaceOrientation];
	[self.view addSubview:rainyWeatherView];
	self.currentShowView = rainyWeatherView;
	[rainyWeatherView release];
}

/*
 * 晴天 繁花盛开
 */
- (void)showSunshineWeather{
	//首先移除当前视图
	if (self.currentShowView.superview != nil) {
		[self.currentShowView removeFromSuperview];
		[self.currentShowView stopTimer];
	}
    
	SunshineWeatherView *sunshineWeatherView = [[SunshineWeatherView alloc] initWithOrientation:self.interfaceOrientation];
	[self.view addSubview:sunshineWeatherView];
	self.currentShowView = sunshineWeatherView;
	[sunshineWeatherView release];
}

/*
 * 晴天 日落美景
 */
- (void)showSunSetWeather{	
	//首先移除当前视图
	if (self.currentShowView.superview != nil) {
		[self.currentShowView removeFromSuperview];
		[self.currentShowView stopTimer];
	}
    
	SunsetWeatherView *sunsetView = [[SunsetWeatherView alloc] initWithOrientation:self.interfaceOrientation];
	[self.view addSubview:sunsetView];
	self.currentShowView = sunsetView;
	[sunsetView release];
}

/*
 * 多云 云飘万里
 */
- (void)showCloudyWeather{
	//首先移除当前视图
	if (self.currentShowView.superview != nil) {
		[self.currentShowView removeFromSuperview];
		[self.currentShowView stopTimer];
	}
	
	CloudyWeatherView *cloudyView = [[CloudyWeatherView alloc] initWithOrientation:self.interfaceOrientation];
	[self.view addSubview:cloudyView];
	self.currentShowView = cloudyView;
	[cloudyView release];
}

#pragma mark -
#pragma mark touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

	if(todayWeather == WEATHER_SUNSHINE){
		todayWeather = WEATHER_CLOUDY;
	}
	else if(todayWeather == WEATHER_CLOUDY){
		todayWeather = WEATHER_SNOWY;
	}
	else if(todayWeather == WEATHER_SNOWY){
		todayWeather = WEATHER_SUNSET;
	}
	else if(todayWeather == WEATHER_SUNSET){
		todayWeather = WEATHER_RAINY;
	}
	else if(todayWeather == WEATHER_RAINY){
		todayWeather = WEATHER_SUNSHINE;
	}
    
	[self showTodayWeather:todayWeather];
	[self showWeatherView];
}

#pragma mark -
#pragma mark system notification event
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	if (self.currentShowView != nil) {		
		[self.currentShowView resetWithOrientation:self.interfaceOrientation];
	}
	[self showWeatherView];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[startImageView release];
	
	[self.currentShowView release];

	[weatherView stopTimer];
	[weatherView release];
    [super dealloc];
}

@end
