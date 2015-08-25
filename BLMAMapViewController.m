//
//  BLMAMapViewController.m
//  biu
//
//  Created by Dezi on 15/8/25.
//  Copyright (c) 2015年 BiuLove. All rights reserved.
//

#import "BLMAMapViewController.h"
#import "Masonry.h"

@interface BLMAMapViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@property (strong, nonatomic) UIButton *btnBack;

@end

@implementation BLMAMapViewController

#pragma mark View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MAMapServices sharedServices].apiKey = kMAMapKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _mapView.delegate = self;
    _mapView.showTraffic = YES;//显示实时路况图
    _mapView.showsUserLocation = YES;//定位
    [self.view addSubview:_mapView];
    
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    
    [self.view addSubview:self.btnBack];

    [self loadLayouts];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;//是否追踪用户
    
//    [_mapView setZoomLevel:16.1 animated:YES];
}

#pragma mark Delegate
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}


- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
//        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
//        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"poi_2.png"];
//        pre.lineWidth = 3;
//        pre.lineDashPattern = @[@6, @3];
        
        [_mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    } 
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
