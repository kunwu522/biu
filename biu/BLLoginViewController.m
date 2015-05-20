//
//  BLLoginViewController.m
//  biu
//
//  Created by Tony Wu on 5/18/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLLoginViewController.h"

@interface BLLoginViewController ()

@property (retain, nonatomic) UIButton *btnReturn;

@property (retain, nonatomic) UIImageView *imageViewLogo;

@property (retain, nonatomic) UILabel *lbLogin;


@end

@implementation BLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btnReturn = [[UIButton alloc] init];
    [_btnReturn setBackgroundImage:[UIImage imageNamed:@"return_icon.png"] forState:UIControlStateNormal];
    [self.view addSubview:_btnReturn];
    
    _imageViewLogo = [[UIImageView alloc] init];
    _imageViewLogo.image = [UIImage imageNamed:@"logo.png"];
    
    _lbLogin = [[UILabel alloc] init];
    _lbLogin.text = @"LOG IN";
    _lbLogin.textColor = [UIColor colorWithRed:107.0 / 255.0 green:108.0 / 255.0 blue:112.0 / 255.0 alpha:1.0f];
    
    
}


@end
