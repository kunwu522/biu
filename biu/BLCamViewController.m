//
//  BLTakingPhotoViewController.m
//  biu
//
//  Created by Tony Wu on 6/13/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLCamViewController.h"
#import "BLAVCamPreviewView.h"
#import "BLCropImageMaskView.h"
#import "BLCropImageViewController.h"
#import "BLImageUtil.h"
#import "Masonry.h"


@interface BLCamViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, BLCropImageViewControllerDelegate>

@property (strong, nonatomic) BLAVCamPreviewView *previewView;
@property (strong, nonatomic) BLCropImageMaskView *maskView;
@property (strong, nonatomic) UIButton *btnCameraFlip;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) UIButton *btnChoosePhoto;
@property (strong, nonatomic) UIButton *btnTakingPhoto;
@property (strong, nonatomic) UIButton *btnCameraLightSwitch;
//for AVCaptureSession
@property (assign, nonatomic) dispatch_queue_t sessionQueue;
@property (strong, nonatomic) AVCaptureSession *session;
@property (assign, nonatomic) BOOL deviceAuthorized;
@property (strong, nonatomic) AVCaptureDeviceInput *frontFacingCamDeviceInput;
@property (strong, nonatomic) AVCaptureDeviceInput *backFacingCamDeviceInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (assign, nonatomic) BOOL isFrontCamInput;
@property (assign, nonatomic) BOOL isFlashOn;

@end


@implementation BLCamViewController

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
    if ([self.session canAddInput:self.frontFacingCamDeviceInput]) {
        [self.session addInput:self.frontFacingCamDeviceInput];
        [[(AVCaptureVideoPreviewLayer *)[_previewView layer] connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    self.isFrontCamInput = YES;
    
    AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    if ([self.session canAddOutput:stillImageOutput])
    {
        [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
        [self.session addOutput:stillImageOutput];
        self.stillImageOutput = stillImageOutput;
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
    
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnClose.superview).with.offset([BLGenernalDefinition resolutionForDevices:31.2f]);
        make.left.equalTo(self.btnClose.superview).with.offset([BLGenernalDefinition resolutionForDevices:20.8f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:35.3f]]);
    }];
    
    [self.btnCameraFlip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnCameraFlip.superview).with.offset([BLGenernalDefinition resolutionForDevices:31.2f]);
        make.right.equalTo(self.btnCameraFlip.superview).with.offset([BLGenernalDefinition resolutionForDevices:-20.8f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:40.3f]]);
    }];
    
    [self.btnTakingPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btnTakingPhoto.superview).with.offset([BLGenernalDefinition resolutionForDevices:-45.0f]);
        make.centerX.equalTo(self.btnTakingPhoto.superview.mas_centerX);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:70.0f]]);
    }];
    
    [self.btnChoosePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnChoosePhoto.superview).with.offset(55.0f);
        make.centerY.equalTo(self.btnTakingPhoto.mas_centerY);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:40.0f]]);
    }];
    
    [self.btnCameraLightSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnCameraLightSwitch.superview).with.offset(-55.0f);
        make.centerY.equalTo(self.btnTakingPhoto.mas_centerY);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:40.0f]]);
    }];
}

#pragma mark - Actions
- (void)flipCamera:(id)sender {
    [self switchCamAnmiation:self.isFrontCamInput];
}

- (void)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)choosePhoto:(id)sender {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    pickerController.allowsEditing = NO;
    pickerController.delegate = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)takePhoto:(id)sender {
    [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:AVCaptureVideoOrientationPortrait];
    if (!self.isFrontCamInput) {
        if (self.isFlashOn) {
            [BLCamViewController setFlashMode:AVCaptureFlashModeOn forDevice:self.backFacingCamDeviceInput.device];
        } else {
            [BLCamViewController setFlashMode:AVCaptureFlashModeOff forDevice:self.backFacingCamDeviceInput.device];
        }
    }

    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo]
    completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            image = [BLImageUtil rotatePhotoToUp:image];
            UIImage *imageToDisplay = [UIImage imageWithCGImage:[image CGImage]
                                                          scale:1.0f
                                                    orientation: UIImageOrientationUp];
            BLCropImageViewController *cropImageViewController = [[BLCropImageViewController alloc] init];
            cropImageViewController.image = imageToDisplay;
            cropImageViewController.delegate = self;
            [self presentViewController:cropImageViewController animated:YES completion:nil];
        }
    }];
}

- (void)switchCameraLight:(id)sender {
    if (self.isFlashOn) {
        [self.btnCameraLightSwitch setImage:[UIImage imageNamed:@"camera_light_switch_icon.png"] forState:UIControlStateNormal];
        self.isFlashOn = NO;
    } else {
        [self.btnCameraLightSwitch setImage:[UIImage imageNamed:@"camera_light_switch_icon2.png"] forState:UIControlStateNormal];
        self.isFlashOn = YES;
    }
}

#pragma mark -
#pragma mark Delegates
- (void)didFinishCropImage:(UIImage *)cropImage orignal:(UIImage *)orignal {
    if (!cropImage || !orignal) {
        NSLog(@"Croped image failed, cropImage or orignal is nil.");
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishTakeOrChooseImage:orignalImage:)]) {
        [self.delegate didFinishTakeOrChooseImage:cropImage orignalImage:orignal];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *pickImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *result = [BLImageUtil rotatePhotoToUp:pickImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result) {
        BLCropImageViewController *cropImageViewController = [[BLCropImageViewController alloc] init];
        cropImageViewController.image = result;
        cropImageViewController.delegate = self;
        [self presentViewController:cropImageViewController animated:YES completion:nil];
    }
}

- (void)animationDidStart:(CAAnimation *)anim {
    [self.session beginConfiguration];
    if (self.isFrontCamInput) {
        [self.session removeInput:self.frontFacingCamDeviceInput];
        [self.session addInput:self.backFacingCamDeviceInput];
        self.isFrontCamInput = NO;
    } else {
        [self.session removeInput:self.backFacingCamDeviceInput];
        [self.session addInput:self.frontFacingCamDeviceInput];
        self.isFrontCamInput = YES;
        
    }
    [self.session commitConfiguration];
}

#pragma mark - private method
+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device {
    if ([device hasFlash] && [device isFlashModeSupported:flashMode]) {
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        } else {
            NSLog(@"%@", error);
        }
    }
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

- (void)switchCamAnmiation:(BOOL)isFrontCam {
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = .8f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"oglFlip";
    if (isFrontCam) {
        animation.subtype = kCATransitionFromRight;
    } else {
        animation.subtype = kCATransitionFromLeft;
    }
    [self.previewView.layer addAnimation:animation forKey:nil];
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
        [_btnCameraFlip addTarget:self action:@selector(flipCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCameraFlip;
}

- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [[UIButton alloc] init];
        [_btnClose setImage:[UIImage imageNamed:@"close_icon2.png"] forState:UIControlStateNormal];
        [_btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnClose;
}

- (UIButton *)btnChoosePhoto {
    if (!_btnChoosePhoto) {
        _btnChoosePhoto = [[UIButton alloc] init];
        [_btnChoosePhoto setImage:[UIImage imageNamed:@"choosing_photo_icon.png"] forState:UIControlStateNormal];
        [_btnChoosePhoto addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnChoosePhoto;
}

- (UIButton *)btnTakingPhoto {
    if (!_btnTakingPhoto) {
        _btnTakingPhoto = [[UIButton alloc] init];
        [_btnTakingPhoto setImage:[UIImage imageNamed:@"taking_photo_icon.png"] forState:UIControlStateNormal];
        [_btnTakingPhoto addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnTakingPhoto;
}

- (UIButton *)btnCameraLightSwitch {
    if (!_btnCameraLightSwitch) {
        _btnCameraLightSwitch = [[UIButton alloc] init];
        [_btnCameraLightSwitch setImage:[UIImage imageNamed:@"camera_light_switch_icon.png"] forState:UIControlStateNormal];
        [_btnCameraLightSwitch addTarget:self action:@selector(switchCameraLight:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCameraLightSwitch;
}

- (AVCaptureDeviceInput *)frontFacingCamDeviceInput {
    if (!_frontFacingCamDeviceInput) {
        NSError *error = nil;
        AVCaptureDevice *videoDevice = [BLCamViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionFront];
        _frontFacingCamDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return nil;
        }
    }
    return _frontFacingCamDeviceInput;
}

- (AVCaptureDeviceInput *)backFacingCamDeviceInput {
    if (!_backFacingCamDeviceInput) {
        NSError *error = nil;
        AVCaptureDevice *device = [BLCamViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        _backFacingCamDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return nil;
        }
    }
    return _backFacingCamDeviceInput;
}

@end
