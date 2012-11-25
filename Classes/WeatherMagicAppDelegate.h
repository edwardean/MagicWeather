//
//  WeatherMagicAppDelegate.h
//  WeatherMagic
//
//  Created by jimneylee on 10-12-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherMagicViewController;

@interface WeatherMagicAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    WeatherMagicViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) WeatherMagicViewController *viewController;

@end

