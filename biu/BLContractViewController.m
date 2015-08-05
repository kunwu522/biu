//
//  BLContractViewController.m
//  biu
//
//  Created by Tony Wu on 7/27/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLContractViewController.h"
#import "Masonry.h"

@interface BLContractViewController ()

@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UIButton *btnBack;
@property (strong, nonatomic) UITextView *tvContract;

@end

@implementation BLContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.background];
    [self.view addSubview:self.lbTitle];
    [self.view addSubview:self.btnBack];
    [self.view addSubview:self.tvContract];
    
    [self loadLayouts];
}

- (void)loadLayouts {
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.background.superview);
    }];
    
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lbTitle.superview);
        make.top.equalTo(self.lbTitle.superview).with.offset([BLGenernalDefinition resolutionForDevices:80.0f]);
    }];
    
    [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnBack.superview).with.offset([BLGenernalDefinition resolutionForDevices:32.0f]);
        make.left.equalTo(self.btnBack.superview).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:20.0f]]);
    }];
    
    [self.tvContract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbTitle.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:40.0f]);
        make.bottom.equalTo(self.tvContract.superview).with.offset([BLGenernalDefinition resolutionForDevices:-60.0f]);
        make.left.equalTo(self.tvContract.superview).with.offset([BLGenernalDefinition resolutionForDevices:10.0f]);
        make.right.equalTo(self.tvContract.superview).with.offset([BLGenernalDefinition resolutionForDevices:-10.0f]);
    }];
}

#pragma mark - Actions
- (void)back:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDismissBLContractViewController:)]) {
        [self.delegate didDismissBLContractViewController:self];
    }
}

#pragma mark -
#pragma mark Getter
- (UIImageView *)background {
    if (!_background) {
        _background = [[UIImageView alloc] init];
        _background.image = [UIImage imageNamed:@"login_signup_background.png"];
    }
    return _background;
}

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc] init];
        _lbTitle.text = NSLocalizedString(@"Contract", nil);
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        _lbTitle.textColor = [UIColor whiteColor];
        _lbTitle.font = [BLFontDefinition normalFont:18.0f];
    }
    return _lbTitle;
}

- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [[UIButton alloc] init];
        [_btnBack setImage:[UIImage imageNamed:@"left_arrow.png"] forState:UIControlStateNormal];
        [_btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBack;
}

- (UITextView *)tvContract {
    if (!_tvContract) {
        _tvContract = [[UITextView alloc] init];
        _tvContract.backgroundColor = [UIColor clearColor];
        _tvContract.text = NSLocalizedString(@"Contract", nil);
        _tvContract.textColor = [UIColor whiteColor];
        _tvContract.font = [BLFontDefinition lightFont:13.0f];
        
        NSString *myText = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"contract" ofType:@"txt"]
                                                     encoding:NSUTF8StringEncoding error:nil];
        _tvContract.text  = myText;
    }
    return _tvContract;
}

@end
