//
//  SimpleDayView.m
//  WeatherParser
//
//  Created by Nick lee on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SimpleDayView.h"


@implementation SimpleDayView
@synthesize cityLabel, temperatureLabel, weatherPictureView;

- (void)setInfo:(DayWeather*)dayWeather
{
	self.backgroundColor = [UIColor clearColor];
	self.showsTouchWhenHighlighted = YES;
	cityLabel.text = dayWeather.city;
	temperatureLabel.text = dayWeather.temperatureRangeInfo;
	
	NSString *pictureName = dayWeather.picureStartName;
	pictureName = [pictureName substringToIndex:[pictureName length]-4];	//.jpg => 4
	pictureName = [NSString stringWithFormat:@"a_%@.png", pictureName];
	
	[weatherPictureView setImage:[UIImage imageNamed:pictureName]];
}
@end
