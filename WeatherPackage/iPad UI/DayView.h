//
//  DayView.h
//  WeatherMagic
//
//  Created by jimneylee on 10-12-17.
//  Copyright 2010 open source. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherLabel;
@class DayWeather;
@interface DayView : UIView
{
	IBOutlet UILabel		*dateLable;
	IBOutlet UIImageView	*weatherImageView;
	IBOutlet UILabel		*weatherInfoLable;		//晴天
	IBOutlet UILabel		*temperatureRangeLable;	//5~10
	IBOutlet UILabel		*windLable;				
}
@property(nonatomic, retain) UILabel		*dateLable;
@property(nonatomic, retain) UIImageView	*weatherImageView;
@property(nonatomic, retain) UILabel		*weatherInfoLable;		//晴天
@property(nonatomic, retain) UILabel		*temperatureRangeLable;	//5~10
@property(nonatomic, retain) UILabel		*windLable;	
- (void)setUpInfo:(DayWeather*)dayWeather dayIndex:(NSUInteger)dayIndex;
@end
