//
//  BLTakingPhotoViewController.m
//  biu
//
//  Created by Tony Wu on 6/13/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLTakingPhotoViewController.h"
#import "BLAVCamPreviewView.h"
#import "Masonry.h"

@interface BLCropImageMaskView : UIView {
@private
    CGRect _cropRect;
}
- (void)setCropSize:(CGSize)size;
- (CGSize)cropSize;
- (CGRect)cropBounds;
@end

@interface BLTakingPhotoViewController ()

@property (strong, nonatomic) BLAVCamPreviewView *previewView;
@property (strong, nonatomic) BLCropImageMaskView *maskView;
@property (strong, nonatomic) UIButton *btnCameraFlip;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) UIButton *btnChoosePhoto;
@property (strong, nonatomic) UIButton *btnTakingPhoto;
@property (strong, nonatomic) UIButton *btnCameraLightSwitch;
//for AVCaptureSession
@property (strong, nonatomic) AVCaptureSession *session;
@property (nonatomic) BOOL deviceAuthorized;

@end

@implementation BLTakingPhotoViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.previewView];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.btnCameraFlip];
    [self.view addSubview:self.btnCameraLightSwitch];
    [self.view addSubview:self.btnClose];
    [self.view addSubview:self.btnChoosePhoto];
    [self.view addSubview:self.btnTakingPhoto];
    
    [self layoutSubViews];
    
    [self checkDeviceAuthorizationStatus];
    NSError *error = nil;
    AVCaptureDevice *videoDevice = [BLTakingPhotoViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionFront];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    if ([_session canAddInput:deviceInput]) {
        [_session addInput:deviceInput];
        [[(AVCaptureVideoPreviewLayer *)[_previewView layer] connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    if ([_session canAddOutput:stillImageOutput])
    {
        [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
        [_session addOutput:stillImageOutput];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.session stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutSubViews {
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.previewView.superview);
    }];
    
//    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.previewView.superview);
//    }];
    
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnClose.superview).with.offset(31.2f);
        make.left.equalTo(self.btnClose.superview).with.offset(20.8f);
        make.width.equalTo(@35.3f);
        make.height.equalTo(@35.3f);
    }];
    
    [self.btnCameraFlip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnCameraFlip.superview).with.offset(31.2f);
        make.right.equalTo(self.btnCameraFlip.superview).with.offset(-20.8f);
        make.width.equalTo(@40.3f);
        make.height.equalTo(@40.3f);
    }];
    
    [self.btnTakingPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btnTakingPhoto.superview).with.offset(-45.0f);
        make.centerX.equalTo(self.btnTakingPhoto.superview.mas_centerX);
        make.width.equalTo(@70.0f);
        make.height.equalTo(@70.0f);
    }];
    
    [self.btnChoosePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnChoosePhoto.superview).with.offset(55.0f);
        make.centerY.equalTo(self.btnTakingPhoto.mas_centerY);
        make.width.equalTo(@40.0f);
        make.height.equalTo(@40.0f);
    }];
    
    [self.btnCameraLightSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnCameraLightSwitch.superview).with.offset(-55.0f);
        make.centerY.equalTo(self.btnTakingPhoto.mas_centerY);
        make.width.equalTo(@40.0f);
        make.height.equalTo(@40.0f);
    }];
}

#pragma mark - handle button action
- (void)flipCamera:(id)sender {
    
}

- (void)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)choosePhoto:(id)sender {
    
}

- (void)takePhoto:(id)sender {
    
}

- (void)switchCameraLight:(id)sender {
    
}

#pragma mark - private method
+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

- (void)checkDeviceAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted) {
            self.deviceAuthorized = YES;
        } else {
            NSLog(@"Camera doesn't have permission to use.");
            self.deviceAuthorized = NO;
        }
    }];
}

#pragma mark - Getting and Setting
- (BLAVCamPreviewView *)previewView {
    if (!_previewView) {
        _previewView = [[BLAVCamPreviewView alloc] init];
        _session = [[AVCaptureSession alloc] init];
        [_previewView setSession:_session];
    }
    return _previewView;
}

- (BLCropImageMaskView *)maskView {
    if (!_maskView) {
        _maskView = [[BLCropImageMaskView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.userInteractionEnabled = NO;
        [_maskView setCropSize:CGSizeMake(337.0f, 337.0f)];
    }
    return _maskView;
}

- (UIButton *)btnCameraFlip {
    if (!_btnCameraFlip) {
        _btnCameraFlip = [[UIButton alloc] init];
        [_btnCameraFlip setImage:[UIImage imageNamed:@"camera_flip_icon.png"] forState:UIControlStateNormal];
        [_btnCameraFlip addTarget:self action:@selector(flipCamera:) forControlEvents:UIControlEventTouchDown];
    }
    return _btnCameraFlip;
}

- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [[UIButton alloc] init];
        [_btnClose setImage:[UIImage imageNamed:@"close_icon2.png"] forState:UIControlStateNormal];
        [_btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchDown];
    }
    return _btnClose;
}

- (UIButton *)btnChoosePhoto {
    if (!_btnChoosePhoto) {
        _btnChoosePhoto = [[UIButton alloc] init];
        [_btnChoosePhoto setImage:[UIImage imageNamed:@"choosing_photo_icon.png"] forState:UIControlStateNormal];
        [_btnChoosePhoto addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchDown];
    }
    return _btnChoosePhoto;
}

- (UIButton *)btnTakingPhoto {
    if (!_btnTakingPhoto) {
        _btnTakingPhoto = [[UIButton alloc] init];
        [_btnTakingPhoto setImage:[UIImage imageNamed:@"taking_photo_icon.png"] forState:UIControlStateNormal];
        [_btnTakingPhoto addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchDown];
    }
    return _btnTakingPhoto;
}

- (UIButton *)btnCameraLightSwitch {
    if (!_btnCameraLightSwitch) {
        _btnCameraLightSwitch = [[UIButton alloc] init];
        [_btnCameraLightSwitch setImage:[UIImage imageNamed:@"camera_light_switch_icon.png"] forState:UIControlStateNormal];
        [_btnCameraLightSwitch addTarget:self action:@selector(switchCameraLight:) forControlEvents:UIControlEventTouchDown];
    }
    return _btnCameraLightSwitch;
}

@end

@implementation BLCropImageMaskView

- (void)setCropSize:(CGSize)size {
    CGFloat x = (CGRectGetWidth(self.bounds) - size.width) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - size.height) / 2 - 60;
    _cropRect = CGRectMake(x, y, size.width, size.height);
    
    [self setNeedsDisplay];
}

- (CGSize)cropSize {
    return _cropRect.size;
}

- (CGRect)cropBounds {
    return _cropRect;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, .4);
    CGContextFillRect(ctx, self.bounds);
    
    CGRect clippingEllipseRect = _cropRect;
    CGContextAddEllipseInRect(ctx, clippingEllipseRect);
    
    CGContextClip(ctx);
    
    CGContextClearRect(ctx, clippingEllipseRect);
}

@end
