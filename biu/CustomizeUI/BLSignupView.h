//
//  BLSignupView.h
//  biu
//
//  Created by Tony Wu on 6/9/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLSignupViewDelegate <NSObject>

@required
- (void)didSignupWithNewUser:(User *)user;

@end

@interface BLSignupView : UIView

@property (weak, nonatomic) id<BLSignupViewDelegate> delegate;

@end
