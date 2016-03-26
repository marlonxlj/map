//
//  RootViewController.m
//  集成高德地图-DEMO
//
//  Created by MARLONXLJ on 16/3/25.
//  Copyright © 2016年 XLJLIU. All rights reserved.
//

#import "RootViewController.h"
#import "CustomAnnotationView.h"
#import "SearchViewController.h"

@interface RootViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
    AMapPOI *_showPoi;
}

@end

@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatMap];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchView)];
    
    self.navigationItem.rightBarButtonItem = right;
    
    //根据用户点击的地址进行定位
    
}

- (void)searchView
{
    SearchViewController *vc = [[SearchViewController alloc] init]
    ;
    
    vc.block = ^(AMapPOI *poi){
    
        _showPoi = poi;
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)creatMap
{
    //1.创建地图对象
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    
    //2.设置代理
    _mapView.delegate = self;
    
    //3.将地图视图添加到视图上显示
    [self.view addSubview:_mapView];
    
    //4.设置地图语言(默认中文)
    _mapView.language = MAMapLanguageZhCN;
    
    //5.开启定位功能
    _mapView.showsUserLocation = YES;
    
    //6.设置用户的位置为地图的中心点
//    MAUserTrackingModeNone：仅在地图上显示，不跟随用户位置
//    MAUserTrackingModeFollow：跟随用户位置移动，并将定位点设置成地图中心点
//    MAUserTrackingModeFollowWithHeading：跟随用户的位置和角度移动
//    [_mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];
    
    //7.后台定位功能
    _mapView.pausesLocationUpdatesAutomatically = NO;
    _mapView.allowsBackgroundLocationUpdates = YES;

#pragma mark - 系统大头针样式
    //8.大头针-系统
//    [self pingSetting];
    
    //9.自定义大头针
//    [self pinCustom];
    
//    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    
    
//    [_mapView setZoomLevel:16.1 animated:YES];
    
    [self positionMap];
    [self pinCustom];
    

}

#pragma mark - 定位功能
- (void)positionMap
{
    
    CLLocationCoordinate2D c2d = CLLocationCoordinate2DMake(30.662221, 104.041367);
//    CLLocationCoordinate2D c2d = CLLocationCoordinate2DMake(_showPoi.location.longitude, _showPoi.location.latitude);
    
    NSLog(@"%@",_showPoi.location);
    //设置地图的显示区域
    MACoordinateSpan span = MACoordinateSpanMake(0.01, 0.01);
    [_mapView setRegion:MACoordinateRegionMake(c2d, span) animated:YES];
   
    [_mapView setCenterCoordinate:c2d animated:YES];
   _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    _mapView.desiredAccuracy = kCLLocationAccuracyBest;
    _mapView.distanceFilter = 10;
//    MAUserLocationRepresentation *showLocation = [[MAUserLocationRepresentation alloc] init];
//    showLocation.showsAccuracyRing = YES;
//    
//    [_mapView updateUserLocationRepresentation:showLocation];
}

#pragma mark - 自定义大头针
- (void)pinCustom
{
    //1.定义一个MAPointAnnotation对象
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    
    //3.添加数据
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(30.662221, 104.041367);
    pointAnnotation.title = @"成达大厦";
    pointAnnotation.subtitle = @"明珠路99号";
    
//    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_showPoi.location.longitude, _showPoi.location.latitude);
    NSLog(@"%f: %f",_showPoi.location.longitude,_showPoi.location.latitude);
//    pointAnnotation.title = _showPoi.name;
//    pointAnnotation.subtitle = _showPoi.address;
    
    //2.将大头针添加到地图上
    [_mapView addAnnotation:pointAnnotation];
    
}
#pragma mark -- 自定义大头针方法回调
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
#pragma mark -  自定义标注信息
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";

//        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
//        if (!annotationView) {
//            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
//        }
//        
//        //设置图标的图片
//        annotationView.image = [UIImage imageNamed:@"bbbe.jpg"];
//        
//        //设置中心点偏移,使得标底部中间点成为经纬度对应点
//        annotationView.centerOffset = CGPointMake(0, -18);
//        return annotationView;
        
//        使用自定义的
    
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"bbbe.jpg"];
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    
    }
    
    return nil;
}

#pragma mark - 系统--大头针
- (void)pingSetting
{
    //1.定义一个MAPointAnnotation对象
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    
    //3.添加数据
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(30.662221, 104.041367);
    pointAnnotation.title = @"天方中心";
    pointAnnotation.subtitle = @"中南海8号";
    
    //2.将大头针添加到地图上
    [_mapView addAnnotation:pointAnnotation];
    
}

#pragma mark - 系统--大头针需要实现代理方法
//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
//        
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        
//        if (!annotationView) {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//            //设置汽泡可以弹出
//            annotationView.canShowCallout = YES;
//            
//            //设置动画标注显示
//            annotationView.animatesDrop = YES;
//            
//            //设置标可以拖动
//            annotationView.draggable = YES;
//            
//            //设置颜色
//            annotationView.pinColor = MAPinAnnotationColorPurple;
//            
//            return annotationView;
//        }
//    }
//    
//    return nil;
//}

#pragma mark - 3D样式自定义定位图层


#pragma mark - 2D样式自定义定位图层

#pragma mark - 地图的代理方法
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        
        MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        
        [_mapView addAnnotation:point];
    }
}
//定义中心点的圆点
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        
        [_mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    }
    
    
}



@end
