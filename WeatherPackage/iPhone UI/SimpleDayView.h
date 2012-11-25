//
//  SimpleDayView.h
//  WeatherParser
//
//  Created by Nick lee on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayWeather.h"

@interface SimpleDayView : UIButton
{
    UILabel* cityLabel;
    UILabel* temperatureLabel;
    UIImageView* weatherPictureView;
}
@property(nonatomic, retain) IBOutlet UILabel* cityLabel;
@property(nonatomic, retain) IBOutlet UILabel* temperatureLabel;
@property(nonatomic, retain) IBOutlet UIImageView* weatherPictureView;

- (void)setInfo:(DayWeather*)dayWeather;
@end
