//
//  DayView.m
//  WeatherMagic
//
//  Created by jimneylee on 10-12-17.
//  Copyright 2010 open source. All rights reserved.
//

#import "DayView.h"
#import "DayWeather.h"
@implementation DayView
@synthesize dateLable;
@synthesize weatherImageView;
@synthesize weatherInfoLable;		//晴天
@synthesize temperatureRangeLable;	//5~10
@synthesize windLable;	

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void)setUpInfo:(DayWeather*)dayWeather dayIndex:(NSUInteger)dayIndex {
	self.backgroundColor = [UIColor clearColor];
	
	dateLable.text = dayWeather.dateStr;
//	if (dayIndex == 0) {
//		dateLable.text = @"今天";
//	}
//	else if (dayIndex == 1) {
//		dateLable.text = @"明天";
//	}	
//	else if (dayIndex == 2) {
//		dateLable.text = @"后天";
//	}
	
	weatherInfoLable.text = dayWeather.basicInfo;
	temperatureRangeLable.text = dayWeather.temperatureRangeInfo;
	windLable.text	= dayWeather.windInfo;
	
	NSString *pictureName = dayWeather.picureStartName;
	pictureName = [pictureName substringToIndex:[pictureName length]-4];	//.jpg => 4
	pictureName = [NSString stringWithFormat:@"a_%@.png", pictureName];
	
	[weatherImageView setImage:[UIImage imageNamed:pictureName]];
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
