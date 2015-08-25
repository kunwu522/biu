//
//  ViewController.h
//  biu
//
//  Created by Tony Wu on 5/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category/UIImage+ImageEffects.h"

#define _HUDTIMING 20.0
@interface BLWelcomeViewController : UIViewController

//@property (retain, nonatomic) UINavigationController *masterNavController;

@property (strong, nonatomic)NSDictionary *profile;
@property (strong, nonatomic)NSDictionary *partner;


@end

