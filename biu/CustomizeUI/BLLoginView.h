//
//  BLLoginView.h
//  biu
//
//  Created by Tony Wu on 6/9/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLLoginViewDelegate <NSObject>

@required
- (void)didLoginWithCurrentUser:(User *)user;

@end

@interface BLLoginView : UIView

@property (weak, nonatomic) id<BLLoginViewDelegate> delegate;

@end
