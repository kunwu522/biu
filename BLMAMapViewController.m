//
//  BLMAMapViewController.m
//  biu
//
//  Created by Dezi on 15/8/25.
//  Copyright (c) 2015年 BiuLove. All rights reserved.
//

#import "BLMAMapViewController.h"
#import "Masonry.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface BLMAMapViewController ()<MAMapViewDelegate, AMapSearchDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
}
@property (strong, nonatomic) UIButton *btnBack;
@property (strong, nonatomic) NSString *latitude;//纬度
@property (strong, nonatomic) NSString *longitude;//经度

@end

@implementation BLMAMapViewController

#pragma mark View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    配置定位
    [MAMapServices sharedServices].apiKey = kMAMapKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _mapView.delegate = self;
    _mapView.showTraffic = YES;//显示实时路况图
    _mapView.showsUserLocation = YES;//定位
    [self.view addSubview:_mapView];
    
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    //自定义定位精度圈样式
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    //是否追踪用户
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    //后台定位
    _mapView.pausesLocationUpdatesAutomatically = NO;
    [self.view addSubview:self.btnBack];
    [self loadLayouts];//设置btnBack
    
//    配置路径规划
    _search = [[AMapSearchAPI alloc] initWithSearchKey:kMAMapKey Delegate:self];
    
    //构造AMapNavigationSearchRequest对象，配置查询参数
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviWalking;
    naviRequest.requireExtension = YES;
//    naviRequest.origin = [AMapGeoPoint locationWithLatitude:39.994949 longitude:116.447265];
//    naviRequest.destination = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    
    //发起路径搜索
    [_search AMapNavigationSearch: naviRequest];
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation) {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        self.latitude = [NSString stringWithFormat:@"%f",userLocation.coordinate.latitude];
        self.longitude = [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
        
    }
}


#pragma mark MAMap Delegate
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    if (overlay == mapView.userLocationAccuracyCircle)
    {
        MACircleView *accuracyCircleView = [[MACircleView alloc] initWithCircle:overlay];
        
        accuracyCircleView.lineWidth    = 2.f;
        accuracyCircleView.strokeColor  = [UIColor redColor];
//        accuracyCircleView.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        accuracyCircleView.strokeColor = [UIColor clearColor];
        
        return accuracyCircleView;
    }
    return nil;
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"startPoint@2x.png"];
        return annotationView;
    }
    return nil;
}




#pragma mark Layouts
- (void)loadLayouts {
    [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnBack.superview).with.offset([BLGenernalDefinition resolutionForDevices:31.2f]);
        make.left.equalTo(self.btnBack.superview).with.offset([BLGenernalDefinition resolutionForDevices:20.8f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:45.3]]);
    }];
}

#pragma mark - Actions
- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Getter
- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [[UIButton alloc] init];
        [_btnBack setImage:[UIImage imageNamed:@"back_icon2.png"] forState:UIControlStateNormal];
        [_btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBack;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
