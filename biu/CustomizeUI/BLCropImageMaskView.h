//
//  BLCropImageMaskView.h
//  biu
//
//  Created by Tony Wu on 6/18/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLCropImageMaskView : UIView

- (void)setCropSize:(CGSize)size;
- (CGSize)cropSize;
- (CGRect)cropBounds;

@end
