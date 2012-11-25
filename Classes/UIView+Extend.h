//
//  UIView+Extend.h
//  WeatherMagic
//
//  Created by jimneylee on 10-12-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 *自定义UIView类别,扩展UIView的方法
 */
@interface UIView(selfExtendMethod)

//视图根据当前横竖屏状态，初始化或重设相关信息
- (id)initWithOrientation:(UIInterfaceOrientation)orientation;
- (void)resetWithOrientation:(UIInterfaceOrientation)orientation;

//定时器的开启与重启
- (void)stopTimer;
- (void)restartTimer;

@end