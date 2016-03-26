//
//  CustomCalloutView.h
//  集成高德地图-DEMO
//
//  Created by MARLONXLJ on 16/3/26.
//  Copyright © 2016年 XLJLIU. All rights reserved.
//
//自定义类
#import <UIKit/UIKit.h>

@interface CustomCalloutView : UIView
/**
 *  商户名
 */
@property (nonatomic, copy) NSString *title;
/**
 *  地址
 */
@property (nonatomic, copy) NSString *subitle;
/**
 *  商户图
 */
@property (nonatomic, strong) UIImage *image;

@end
