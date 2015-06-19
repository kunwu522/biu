//
//  BLCropImageViewController.m
//  biu
//
//  Created by Tony Wu on 6/18/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLCropImageViewController.h"
#import "BLCropImageMaskView.h"
#import "Masonry.h"

@interface BLCropImageViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) BLCropImageMaskView *maskView;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) UIButton *btnCrop;

//For imageView animation
@property (nonatomic) CGPoint originalCenter;
@property (nonatomic) CGRect originalFrame;

@end

@implementation BLCropImageViewController

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.btnCancel];
    [self.view addSubview:self.btnCrop];
    
    [self layoutSubViews];
    
    //adjust imageView height for croping
    CGFloat correctHight = (self.view.frame.size.width / self.image.size.width) * self.image.size.height;
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithDouble:correctHight]);
    }];
}

- (void)layoutSubViews {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView.superview);
        make.left.equalTo(self.imageView.superview);
        make.right.equalTo(self.imageView.superview);
    }];
    
    [self.btnCrop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnCrop.superview).with.offset(31.2f);
        make.right.equalTo(self.btnCrop.superview).with.offset(-20.8f);
        make.width.equalTo(@35.3f);
        make.height.equalTo(@35.3f);
    }];
    
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnClose.superview).with.offset(31.2f);
        make.left.equalTo(self.btnClose.superview).with.offset(20.8f);
        make.width.equalTo(@35.3f);
        make.height.equalTo(@35.3f);
    }];
}

#pragma mark -
#pragma mark Actions
- (void)moveImage:(UIPanGestureRecognizer *)gestureRecognizer {
    UIView *oldImage = gestureRecognizer.view;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.originalCenter = gestureRecognizer.view.center;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [gestureRecognizer translationInView: oldImage.superview];
        CGPoint c = oldImage.center;
        c.y += delta.y;
        c.x += delta.x;
        oldImage.center = c;
        [gestureRecognizer setTranslation: CGPointZero inView: oldImage.superview];
        if ([self isFillFrame:self.maskView.cropBounds currentImageFrame:gestureRecognizer.view.frame]) {
            self.originalCenter = oldImage.center;
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (![self isFillFrame:self.maskView.cropBounds currentImageFrame:gestureRecognizer.view.frame]) {
            [UIView animateWithDuration:0.5 animations:^{
                gestureRecognizer.view.center = self.originalCenter;
            }];
        }
    }
}

- (void)scaleImage:(UIPinchGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.originalFrame = gestureRecognizer.view.frame;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged || gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat currentScale = gestureRecognizer.view.frame.size.width / gestureRecognizer.view.bounds.size.width;
        CGFloat newScale = currentScale * gestureRecognizer.scale;
        gestureRecognizer.view.transform = CGAffineTransformMakeScale(newScale, newScale);
        gestureRecognizer.scale = 1;
        if ([self isFillFrame:self.maskView.cropBounds currentImageFrame:gestureRecognizer.view.frame]) {
            self.originalFrame = gestureRecognizer.view.frame;
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (![self isFillFrame:self.maskView.cropBounds currentImageFrame:gestureRecognizer.view.frame]) {
            [UIView animateWithDuration:0.5 animations:^{
                self.imageView.frame = self.originalFrame;
            }];
        }
    }
}

- (void)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropImage:(id)sender {
    CGRect frameRect = self.imageView.frame;
    double ratio = self.image.size.width / frameRect.size.width;
    CGRect maskRect = CGRectMake((self.maskView.cropBounds.origin.x - frameRect.origin.x) * ratio, (self.maskView.cropBounds.origin.y - frameRect.origin.y) * ratio, self.maskView.cropBounds.size.width * ratio, self.maskView.cropBounds.size.height * ratio);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.image CGImage], maskRect);
    UIImage *cropImage = [UIImage imageWithCGImage:imageRef];

    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishCropImage:orignal:)]) {
        [self.delegate didFinishCropImage:cropImage orignal:self.image];
    }
}

#pragma mark -
#pragma mark Getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
        [_imageView addGestureRecognizer:panGestureRecognizer];
        [_imageView addGestureRecognizer:pinchGestureRecognizer];
    }
    return _imageView;
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

- (UIButton *)btnCancel {
    if (!_btnClose) {
        _btnClose = [[UIButton alloc] init];
        [_btnClose setBackgroundImage:[UIImage imageNamed:@"close_icon2.png"] forState:UIControlStateNormal];
        [_btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnClose;
}

- (UIButton *)btnCrop {
    if (!_btnCrop) {
        _btnCrop = [[UIButton alloc] init];
        [_btnCrop setBackgroundImage:[UIImage imageNamed:@"crop_icon.png"] forState:UIControlStateNormal];
        [_btnCrop addTarget:self action:@selector(cropImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCrop;
}

#pragma mask Setter
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

#pragma mark -
#pragma mark Private Method
- (BOOL)isFillFrame:(CGRect)frame currentImageFrame:(CGRect)currentFrame
{
    CGFloat boundA = currentFrame.origin.x;
    CGFloat boundB = currentFrame.origin.y;
    CGFloat boundC = currentFrame.origin.x + currentFrame.size.width;
    CGFloat boundD = currentFrame.origin.y + currentFrame.size.height;
    
    if (boundA > frame.origin.x
        || boundB > frame.origin.y
        || boundC < (frame.origin.x + frame.size.width)
        || boundD < (frame.origin.y + frame.size.height)) {
        return NO;
    }
    return YES;
}

@end
