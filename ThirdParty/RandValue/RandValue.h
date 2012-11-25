//
//  RandValue.h
//  PlaneDodge
//
//  Created by jimneylee on 10-7-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RandValue : NSObject 
{

}
+ (NSInteger)createRandomsizeValueInt:(NSInteger)fromInt toInt:(NSInteger)toInt;
+ (double)createRandomsizeValueFloat:(double)fromFloat toFloat:(double)toFloat;
@end
