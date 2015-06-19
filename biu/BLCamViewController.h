//
//  BLTakingPhotoViewController.h
//  biu
//
//  Created by Tony Wu on 6/13/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLCamViewControllerDelegate <NSObject>

@required
- (void)didFinishTakeOrChooseImage:(UIImage *)image orignalImage:(UIImage *)orignalImage;

@end

@interface BLCamViewController : UIViewController

@property (weak, nonatomic) id<BLCamViewControllerDelegate> delegate;

@end
