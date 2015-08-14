//
//  BLFaceView.h
//  biu
//
//  Created by Dezi on 15/8/13.
//  Copyright (c) 2015年 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLFaceView : UIView
{
    UIImageView *_faceImageview;
    CGRect      faceRect;
}

@property (nonatomic, retain) UIImage *faceImage;
- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)face withPointRect:(CGRect)rect;

@end
