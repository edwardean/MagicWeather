//
//  RainView.h
//  RainEffect
//
//  Created by Yan Wang on 10-12-15.
//  Copyright 2010 YuanTu NetWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefines.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>
//自定义UIView类别
#import "UIView+Extend.h"
#define RAIN_TYPE 7 //雨滴种类
#define RAIN_COUNT 50 //雨滴数
#define RAINLINE_COUNT 100 //线状雨点数
#define RAIN_NAME @"rainy_bg.jpg"
#define MOVE_CYCLE 30

@interface RainView : UIView {
	UIImageView		*backgroundImageView;

	UIInterfaceOrientation screenOrientation;
	UIImageView *rainView[RAIN_COUNT];
	NSTimer * rainTimer;
	UIImageView * rainLineView[RAINLINE_COUNT];
	BOOL touchFlag[RAIN_COUNT];
	CGPoint moveToPoint;
	int rainTouchedID;
	//BOOL rainLineFlag;
	
}
@property(nonatomic,retain)UIImageView * backgroundImageView;

-(CGPoint)getRainOffset;
-(int)getRainID;
-(void)setRainWith:(int)imageViewID;
-(void)startTimer;
-(void)searchForReset;
/*
-(void)initRainLine;
-(CGPoint)getRainLineOffset;
-(void)setRianLineWith:(int)imageTag;
-(void)doAnimationOn:(int)imageTag;
*/ 
-(void)startRain;
-(void)touchesAnimation;
-(void)touchesAnimationDidStop;
-(CGPoint)touchMoveEndPointWith:(int)type;
- (void)bgMoveAnimation;
//-(void)stopTimer;
//- (void)resetWithOrientation:(UIInterfaceOrientation)orientation;
@end
