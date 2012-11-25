//
//  WeatherView.h
//  WeatherParser
//
//  Created by jimneylee on 11-5-4.
//  Copyright 2011 open source. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeatherView : UIView {
	IBOutlet UIView			*upBgView;
	IBOutlet UIImageView	*hourUpView;
	IBOutlet UIImageView	*hourDownView;
	IBOutlet UIImageView	*minuteUpView;
	IBOutlet UIImageView	*minuteDownView;
	
	IBOutlet UILabel		*locationLable;
	IBOutlet UILabel		*todayDateLable;
	
	IBOutlet UILabel		*simpleWeatherLabel;		
	IBOutlet UILabel		*temperatureNowLabel;
	
	IBOutlet UIImageView	*todayWeatherView;
	
	IBOutlet UIView			*fullInfoBgView;
	IBOutlet UITextView		*fullInfoTextView;
	
	NSMutableArray			*daysViews;
	
	NSTimer					*timer;
}
@property(nonatomic, retain) UIView			*upBgView;
@property(nonatomic, retain) UIImageView	*hourUpView;
@property(nonatomic, retain) UIImageView	*hourDownView;
@property(nonatomic, retain) UIImageView	*minuteUpView;
@property(nonatomic, retain) UIImageView	*minuteDownView;

@property(nonatomic, retain) UILabel		*locationLable;
@property(nonatomic, retain) UILabel		*todayDateLable;

@property(nonatomic, retain) UILabel		*simpleWeatherLabel;		
@property(nonatomic, retain) UILabel		*temperatureNowLabel;

@property(nonatomic, retain) UIImageView	*todayWeatherView;
@property(nonatomic, retain) UIView			*fullInfoBgView;
@property(nonatomic, retain) UIView			*fullInfoTextView;
- (NSString*)updateWeatherInfo;
- (void)stopTimer;
- (IBAction) showFullInfo;
- (IBAction) back;
@end
