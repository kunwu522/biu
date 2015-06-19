//
//  BLCropImageViewController.h
//  biu
//
//  Created by Tony Wu on 6/18/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLCropImageViewControllerDelegate <NSObject>

@required
- (void)didFinishCropImage:(UIImage *)cropImage orignal:(UIImage *)orignal;

@end

@interface BLCropImageViewController : UIViewController

@property (weak, nonatomic) id<BLCropImageViewControllerDelegate> delegate;

@property (strong, nonatomic) UIImage *image;

@end
