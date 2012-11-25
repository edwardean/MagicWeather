//
//  RandValue.m
//  PlaneDodge
//
//  Created by jimneylee on 10-7-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RandValue.h"

//！随机数的最大值
#define ARC4RANDOM_MAX      0x100000000

@implementation RandValue

+ (NSInteger)createRandomsizeValueInt:(NSInteger)fromInt toInt:(NSInteger)toInt
{
	if (toInt < fromInt)
	{
		return toInt;
	}
	if (toInt == fromInt)  
	{
		return fromInt;
	}
	NSInteger randVal = arc4random() % (toInt - fromInt + 1) + fromInt;
	return randVal;
}

+ (double)createRandomsizeValueFloat:(double)fromFloat toFloat:(double)toFloat
{
	if (toFloat < fromFloat)
	{
		return toFloat;
	}
	if (toFloat == fromFloat)  
	{
		return fromFloat;
	}
	double randVal = ((double)arc4random() / ARC4RANDOM_MAX) * (toFloat - fromFloat) + fromFloat;
	return randVal;
}
@end
