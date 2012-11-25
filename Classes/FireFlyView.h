//
//  BulletView.h
//  PlaneDodge
//
//  Created by jimney on 10-7-28.
//  Copyright 2010 YT. All rights reserved.
//

#import <UIKit/UIKit.h>

//！枚举类型，子弹的进入边
typedef enum
{
	TOP_SIDE = 0,
	RIGHT_SIDE = 1,
	BOTTOM_SIDE = 2,
	LEFT_SIDE
}StartFromSide;

//predators
@interface FireFlyView : UIImageView 
{
	//矢量速度
	CGPoint			m_vectorSpeed;
	//开始边
	StartFromSide	m_eStartSide;
	
	NSMutableArray* m_pImagesArray;
}
@property(nonatomic) CGPoint			m_vectorSpeed;
- (id)init;
- (void)reset;
+ (void)setScreenSizeWithOrientation:(UIInterfaceOrientation)toOrientation;
@end
