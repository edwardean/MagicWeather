//
//  Address.m
//  WeatherEngine
//
//  Created by Nick lee on 12-3-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SinaCityAddress.h"
#import "JSON.h"

#define kSinaAddressURL @"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js"
@implementation SinaCityAddress
@synthesize ip = _ip, country = _country, province = _province, city = _city;
- (id)init
{
    self = [super init];
    if (self) {
        NSString* address = [self loadAddressFromSina];
        [self parseAddress:address];
    }
    return self;
}

- (void)dealloc
{
    self.ip = nil;
    self.country = nil;
    self.province = nil;
    self.city = nil;
    
    [super dealloc];
}

- (NSString *)loadAddressFromSina {
    
    NSString* address = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:kSinaAddressURL] encoding:NSUTF8StringEncoding error:nil];
    
    return [address autorelease];
}

/*
 * sina　获取ip地址和城市地址的接口　
 var remote_ip_info = {"ret":1,"start":"58.241.52.0","end":"58.241.95.255","country":"\u4e2d\u56fd","province":"\u6c5f\u82cf","city":"\u5e38\u5dde","district":"","isp":"\u8054\u901a","type":"","desc":""};
 */
- (void)parseAddress:(NSString*)address
{
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
            self.ip = [dict objectForKey:@"start"];
            self.country = [dict objectForKey:@"country"];
            self.province = [dict objectForKey:@"province"];
            self.city = [dict objectForKey:@"city"];
            
            NSLog(@"ip:%@ country:%@ province:%@ city:%@", self.ip, self.country, self.province, self.city);
        }
        else {
            NSLog(@"ERROR: can not get right address");
        }
    }
}
@end
