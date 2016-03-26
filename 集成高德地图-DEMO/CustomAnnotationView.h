//
//  CustomAnnotationView.h
//  集成高德地图-DEMO
//
//  Created by MARLONXLJ on 16/3/26.
//  Copyright © 2016年 XLJLIU. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

@interface CustomAnnotationView : MAPinAnnotationView
@property (nonatomic, readonly) CustomCalloutView *calloutView;
@end
