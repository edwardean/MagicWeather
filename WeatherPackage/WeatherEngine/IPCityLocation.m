//
//  IPCityLocation.m
//  WeatherParser
//
//  Created by jimneylee on 11-4-19.
//  Copyright 2011 open source. All rights reserved.
//

#import "IPCityLocation.h"
#import "JSON.h"

#define kQQWebServiceURLStr @"http://fw.qq.com/ipaddress"
#define kSinaAddressURL @"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js"

@interface IPCityLocation(private)
- (void)parseCityLocationFromTencentQQ;
- (void)parseCityLocationFromSina;
@end

@implementation IPCityLocation
@synthesize ipAddressStr;
@synthesize cityFullName;
@synthesize citySimpleName;
@synthesize serviceUrlStr;
#pragma mark init & alloc 
- (id)init{
	self = [super init];
	if (self) {
		didGetLocation = NO;
        // sina接口
        [self parseCityLocationFromSina];

	}
	return self;
}

- (void)dealloc{
	[ipAddressStr release];
	[cityFullName release];
	[citySimpleName release];
	[serviceUrlStr release];
	[super dealloc];
}

#pragma mark parse

/*
 * sina　获取ip地址和城市地址的接口　
 var remote_ip_info = {"ret":1,"start":"58.241.52.0","end":"58.241.95.255","country":"\u4e2d\u56fd","province":"\u6c5f\u82cf","city":"\u5e38\u5dde","district":"","isp":"\u8054\u901a","type":"","desc":""};
 */
- (void)parseCityLocationFromSina{
    NSString* address = [NSString stringWithContentsOfURL:[NSURL URLWithString:kSinaAddressURL] encoding:NSUTF8StringEncoding error:nil];
    
    // 剔除调前面不合理的部分,json部分从{开始，同时去掉最后一个;分号　
    NSRange range = [address rangeOfString:@"{"];
    NSRange subRange = NSMakeRange(range.location, address.length - range.location - 1);
    address = [address substringWithRange:subRange];
    
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    id object = [parser objectWithString:address];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dict = object;
        NSNumber* ret = [dict objectForKey:@"ret"];
        if ([ret intValue] > 0) {
//            self.ip = [dict objectForKey:@"start"];
//            self.country = [dict objectForKey:@"country"];
//            self.province = [dict objectForKey:@"province"];
//            self.city = [dict objectForKey:@"city"];
            self.ipAddressStr = [dict objectForKey:@"start"];
            self.citySimpleName = [dict objectForKey:@"city"];
            NSLog(@"ip:%@ city:%@", self.ipAddressStr, self.citySimpleName);
        }
        else {
            NSLog(@"ERROR: can not get right address");
        }
    }
}
@end
