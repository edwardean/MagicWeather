//
//  WeatherView.m
//  WeatherParser
//
//  Created by jimneylee on 11-5-4.
//  Copyright 2011 open source. All rights reserved.
//

#import "WeatherView.h"
#import "DayView.h"
#import "WeatherParser.h"
#import <QuartzCore/QuartzCore.h>

#define	WEATHER_DAY_COUNT 3 //显示三天
#define TIMER_INTERVAL 30	//只显示分，定时器不用更新频繁
#define TODAY_VIEW_ORIGIN CGPointMake(7, 326)
#define VIEW_DISTANCE 157
#define TOMORROW_VIEW_ORIGIN CGPointMake(164, 326)
#define DAY_AFTER_TOMO_ORIGIN CGPointMake(322, 326)

@interface WeatherView(private)
- (void)updateTime;
@end

@implementation WeatherView
@synthesize upBgView;
@synthesize hourUpView;
@synthesize hourDownView;
@synthesize minuteUpView;
@synthesize minuteDownView;

@synthesize locationLable;
@synthesize todayDateLable;

@synthesize simpleWeatherLabel;		
@synthesize temperatureNowLabel;
@synthesize todayWeatherView;

@synthesize fullInfoBgView;
@synthesize fullInfoTextView;
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
    }
    return self;
}

- (NSString*)updateWeatherInfo{
	//从网络导出天气信息
	WeatherParser *weatherParser = [[WeatherParser alloc] init];
	
	if (!weatherParser.parseSuccssful) {
		//对是否获取到前期情况提示
		UIImage *image = [UIImage imageNamed:@"BG_WEATHER_UP.png"];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		[imageView setFrame:self.upBgView.frame];
		UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
		[tipLable setText:@":( 不能获得天气信息"];
		[tipLable setBackgroundColor:[UIColor clearColor]];
		[tipLable setTextColor:[UIColor whiteColor]];
		[tipLable setTextAlignment:UITextAlignmentCenter];
		[tipLable setFont:[UIFont fontWithName:@"American Typewriter" size:36]];
		[imageView addSubview:tipLable];
		[tipLable setCenter:imageView.center];
		if (self.upBgView.superview != nil) {
			[self.upBgView removeFromSuperview];
		}
		self.upBgView = imageView;
		[self addSubview:self.upBgView];
		
		//release memory
		[tipLable release];
		[imageView release];
		
		return nil;
	}

	//清除背景颜色
	self.backgroundColor = [UIColor clearColor];
	timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self 
										   selector:@selector(updateTime) userInfo:nil repeats:YES];
	[timer fire];
	
	//设置天气信息
	locationLable.text = weatherParser.ipCityLocation.cityFullName;
	
	DayWeather *todayWeather = [weatherParser.dayWeatherArray objectAtIndex:0];
	NSString *date = [NSString stringWithFormat:@"%@ %@", todayWeather.dateStr, todayWeather.weekStr];
	todayDateLable.text = date;
	
	simpleWeatherLabel.text = todayWeather.basicInfo;
	temperatureNowLabel.text = todayWeather.temperatureRangeInfo;
	
	NSString *pictureName = todayWeather.picureStartName;
	pictureName = [pictureName substringToIndex:[pictureName length]-4];	//.jpg => 4
	pictureName = [NSString stringWithFormat:@"a_%@.png", pictureName];
	
	[todayWeatherView setImage:[UIImage imageNamed:pictureName]];
	
	if ([daysViews count] == 0) {
		daysViews = [[NSMutableArray alloc] initWithCapacity:WEATHER_DAY_COUNT];
		DayView *dayView;
		for (int i = 0; i < WEATHER_DAY_COUNT; ++i) {
			dayView = [DayView alloc];
			NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"DayView" owner:self options:nil];
			dayView = [nib objectAtIndex:0];
			
			CGRect rect = dayView.frame;
			rect.origin = CGPointMake(TODAY_VIEW_ORIGIN.x + VIEW_DISTANCE * i, TODAY_VIEW_ORIGIN.y);
			dayView.frame = rect;
			
			[dayView setUpInfo:[weatherParser.dayWeatherArray objectAtIndex:i] dayIndex:i];
			[self addSubview:dayView];
			[daysViews addObject:dayView];
			[dayView release];
		}
	}
	//详细信息视图
	fullInfoBgView.center = upBgView.center;
	NSMutableString *fullInfo = [[NSMutableString alloc] init];
	[fullInfo appendFormat:@"%@",todayWeather.realtimeInfo];
	fullInfoTextView.text = fullInfo;
	[fullInfo release];
	
	NSString *weatherInfo = simpleWeatherLabel.text;
	
	[weatherParser release];
	return weatherInfo;
}
/*
 * 内部做个定时器，定时更新时间 日期 天气实况
 */
- (void)updateTime{
	//更新时间 还有am pm
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:kCFDateFormatterShortStyle];
	//[dateFormatter setDateFormat:@"HH:mm:SS"];
	NSString *currentTime = [dateFormatter stringFromDate:today];
	[dateFormatter release];
//	DebugLog(@"User's current time in their preference format:%@",currentTime);
	
	NSArray *timeArray = [currentTime componentsSeparatedByString:@":"];
	// 获得小时各位图片索引
	NSUInteger hour = [[timeArray objectAtIndex:0] intValue];
	NSString *imageName;
	imageName = [NSString stringWithFormat:@"NUMBER_%d.png", hour%10];
	[hourDownView setImage:[UIImage imageNamed:imageName]];
	
	imageName = [NSString stringWithFormat:@"NUMBER_%d.png", hour/10];
	[hourUpView setImage:[UIImage imageNamed:imageName]];
	
	// 获得分钟各位图片索引
	NSUInteger minute = [[timeArray objectAtIndex:1] intValue];
	imageName = [NSString stringWithFormat:@"NUMBER_%d.png", minute%10];
	[minuteDownView setImage:[UIImage imageNamed:imageName]];
	
	imageName = [NSString stringWithFormat:@"NUMBER_%d.png", minute/10];
	[minuteUpView setImage:[UIImage imageNamed:imageName]];
	
	// todo:
	// 更新日期 24小时
	// 更新天气实况 3小时
}

- (void)stopTimer{
	if (timer != nil) {
		[timer invalidate];
		timer = nil;
	}
}

- (IBAction) showFullInfo{	
	// Start Animation Block
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:2.0];
	
	// Animations
	[upBgView removeFromSuperview];
	[self addSubview:fullInfoBgView];
	
	// Commit Animation Block
	[UIView commitAnimations];
}

- (IBAction) back{
	// Start Animation Block
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:2.0];
	
	// Animations
	[fullInfoBgView removeFromSuperview];
	[self addSubview:upBgView];
	
	// Commit Animation Block
	[UIView commitAnimations];
	
	
}

- (void)dealloc {
	[upBgView release];
	[hourUpView release];
	[hourDownView release];
	[minuteUpView release];
	[minuteDownView release];
	
	[locationLable release];
	[todayDateLable release];
	
	[simpleWeatherLabel release];		
	[temperatureNowLabel release];
	
	[todayWeatherView release];
	
	[daysViews release];
	if (timer != nil) {
		[timer invalidate];
		timer = nil;
	}
    [super dealloc];
}


@end

