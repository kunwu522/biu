//
//  ShootAVCamPreviewView.m
//  PickingAndTakingImage
//
//  Created by Tony Wu on 1/9/15.
//  Copyright (c) 2015 Tony Wu. All rights reserved.
//

#import "BLAVCamPreviewView.h"

@implementation BLAVCamPreviewView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session
{
    [(AVCaptureVideoPreviewLayer *)[self layer] setSession:session];
}

@end
