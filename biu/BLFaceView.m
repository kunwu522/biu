//
//  BLFaceView.m
//  biu
//
//  Created by Dezi on 15/8/13.
//  Copyright (c) 2015年 BiuLove. All rights reserved.
//

#import "BLFaceView.h"

@implementation BLFaceView
@synthesize faceImage;

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)face withPointRect:(CGRect)rect {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.faceImage = face;
        faceRect = rect;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);
    
    //Gradient center
    CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    //Gradient radius
    float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    //Gradient draw
    CGContextDrawRadialGradient (context, gradient, gradCenter,
                                 0, gradCenter, gradRadius,
                                 kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    if (_faceImageview == nil) {
        _faceImageview = [[UIImageView alloc]initWithImage:self.faceImage];
        //        [_faceImageview setFrame:CGRectMake(10, 69, 50, 50)];
        //_faceImageview.alpha = 0.0f;
        [_faceImageview setFrame:faceRect];
    }
    [self addSubview:_faceImageview];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         // _faceImageview.alpha = 1.0f;
                         [_faceImageview setFrame:CGRectMake(0, (self.bounds.size.height - self.bounds.size.width)/2, self.bounds.size.width, self.bounds.size.width)];
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = 1.0f;//控制淡入淡出
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.alpha = 0.0f;
                         if (_faceImageview) {
                             [_faceImageview setFrame:faceRect];
                         }
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}


@end














