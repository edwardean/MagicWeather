//
//  IPCityLocation.h
//  WeatherParser
//
//  Created by jimneylee on 11-4-19.
//  Copyright 2011 open source. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 根据ip地址进行定位，获取当前所在的城市
 * 目前从腾讯qq定位服务取得
 * 获取天气的城市名称不用加后缀"市"，直辖市可能只有前面有数据
 * 后面单独考虑
 ==================================================
 update 3.10: 地址获取采用sina的接口
 
 */
@interface IPCityLocation : NSObject {
	NSString *ipAddressStr;
	
	NSString *cityFullName;
	NSString *citySimpleName;		//获取天气的城市名称不用加后缀"市"
	
	NSString *serviceUrlStr;
	BOOL	 didGetLocation;
}

@property(nonatomic, copy) NSString *ipAddressStr;
@property(nonatomic, copy) NSString *cityFullName;
@property(nonatomic, copy) NSString *citySimpleName;

@property(nonatomic, copy) NSString *serviceUrlStr;

@end
