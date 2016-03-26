//
//  SearchViewController.h
//  集成高德地图-DEMO
//
//  Created by MARLONXLJ on 16/3/26.
//  Copyright © 2016年 XLJLIU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMapPOI;

typedef void(^BLOCK)(AMapPOI *str);

@interface SearchViewController : UIViewController

@property (nonatomic, copy) BLOCK block;

@end
