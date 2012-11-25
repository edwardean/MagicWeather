//
//  Address.h
//  WeatherEngine
//
//  Created by Nick lee on 12-3-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * sina　获取ip地址和城市地址的接口　
 var remote_ip_info = {"ret":1,"start":"58.241.52.0","end":"58.241.95.255","country":"\u4e2d\u56fd","province":"\u6c5f\u82cf","city":"\u5e38\u5dde","district":"","isp":"\u8054\u901a","type":"","desc":""};
 */
@interface SinaCityAddress : NSObject
{
    NSString* _ip;
    
    NSString* _country;
    NSString* _province;
    NSString* _city;
}
@property(nonatomic, copy) NSString* ip;

@property(nonatomic, copy) NSString* country;
@property(nonatomic, copy) NSString* province;
@property(nonatomic, copy) NSString* city;

- (NSString *)loadAddressFromSina;
- (void)parseAddress:(NSString*)address;
@end
