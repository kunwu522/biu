//
//  BLLoginViewController.h
//  biu
//
//  Created by Tony Wu on 7/23/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BLLoginViewControllerDelegate <NSObject>

@required
- (void)viewController:(UIViewController *)controller didLoginWithCurrentUser:(User *)user;

@end

@interface BLLoginViewController : UIViewController

@property (strong, nonatomic)NSString *codeString;
@property (weak, nonatomic) id<BLLoginViewControllerDelegate> delegate;

//@property (strong, nonatomic)NSString *openid;//第三方登录唯一标识
//@property (strong, nonatomic)NSString *username;//用户名
//@property (strong, nonatomic)NSString *avatar_url;//头像地址
//@property (assign, nonatomic)NSString *userId;//应用用户ID

@end








