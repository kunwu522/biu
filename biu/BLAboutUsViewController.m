//
//  BLAboutUsViewController.m
//  biu
//
//  Created by Tony Wu on 7/27/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLAboutUsViewController.h"
#import "Masonry.h"

@interface BLAboutUsViewController ()

@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UIImageView *imageViewLogo;
@property (strong, nonatomic) UILabel *lbAppName;
@property (strong, nonatomic) UILabel *lbVersion;
@property (strong, nonatomic) UILabel *lbQuestion;
@property (strong, nonatomic) UITextView *questionEmail;
@property (strong, nonatomic) UILabel *lbJoinUs;
@property (strong, nonatomic) UITextView *joinUsEmail;
@property (strong, nonatomic) UILabel *lbBusiness;
@property (strong, nonatomic) UITextView *businessEmail;
@property (strong, nonatomic) UIButton *btnBack;

@end

@implementation BLAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.background];
    [self.view addSubview:self.lbTitle];
    [self.view addSubview:self.btnBack];
    [self.view addSubview:self.imageViewLogo];
    [self.view addSubview:self.lbAppName];
    [self.view addSubview:self.lbVersion];
    [self.view addSubview:self.lbQuestion];
    [self.view addSubview:self.questionEmail];
    [self.view addSubview:self.lbJoinUs];
    [self.view addSubview:self.joinUsEmail];
    [self.view addSubview:self.lbBusiness];
    [self.view addSubview:self.businessEmail];
    
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
    
    [self.imageViewLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbTitle).with.offset([BLGenernalDefinition resolutionForDevices:100.0f]);
        make.centerX.equalTo(self.imageViewLogo.superview.mas_centerX);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:50.0f]]);
    }];
    
    [self.lbAppName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageViewLogo.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:5.0f]);
        make.centerX.equalTo(self.lbAppName.superview.mas_centerX);
    }];
    
    [self.lbVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbAppName.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:5.0f]);
        make.centerX.equalTo(self.lbVersion.superview.mas_centerX);
    }];
    
    [self.lbQuestion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbVersion.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:80.0f]);
        make.centerX.equalTo(self.lbQuestion.superview.mas_centerX);
    }];
    
    CGSize qEmailSize = [BLFontDefinition sizeForString:self.questionEmail.text font:self.questionEmail.font];
    [self.questionEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbQuestion.mas_bottom);
        make.centerX.equalTo(self.questionEmail.superview.mas_centerX);
        make.width.equalTo([NSNumber numberWithDouble:qEmailSize.width + 15]);
        make.height.equalTo([NSNumber numberWithDouble:qEmailSize.height + 10]);
    }];
    
    [self.lbJoinUs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.questionEmail.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.centerX.equalTo(self.lbJoinUs.superview.mas_centerX);
    }];
    
    CGSize jEmailSize = [BLFontDefinition sizeForString:self.joinUsEmail.text font:self.joinUsEmail.font];
    [self.joinUsEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbJoinUs.mas_bottom);
        make.centerX.equalTo(self.joinUsEmail.superview.mas_centerX);
        make.width.equalTo([NSNumber numberWithDouble:jEmailSize.width + 15]);
        make.height.equalTo([NSNumber numberWithDouble:jEmailSize.height + 10]);
    }];
    
    [self.lbBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.joinUsEmail.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.centerX.equalTo(self.lbBusiness.superview.mas_centerX);
    }];
    
    CGSize bEmailSize = [BLFontDefinition sizeForString:self.businessEmail.text font:self.businessEmail.font];
    [self.businessEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbBusiness.mas_bottom);
        make.centerX.equalTo(self.businessEmail.superview.mas_centerX);
        make.width.equalTo([NSNumber numberWithDouble:bEmailSize.width + 15]);
        make.height.equalTo([NSNumber numberWithDouble:bEmailSize.height + 10]);
    }];
}

#pragma mark - Actions
- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        _lbTitle.text = NSLocalizedString(@"About Us", nil);
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        _lbTitle.textColor = [UIColor whiteColor];
        _lbTitle.font = [BLFontDefinition normalFont:18.0f];
    }
    return _lbTitle;
}

- (UIImageView *)imageViewLogo {
    if (!_imageViewLogo) {
        _imageViewLogo = [[UIImageView alloc] init];
        _imageViewLogo.image = [UIImage imageNamed:@"app_icon.png"];
        _imageViewLogo.layer.cornerRadius = 10.0f;
        _imageViewLogo.clipsToBounds = YES;
    }
    return _imageViewLogo;
}

- (UILabel *)lbAppName {
    if (!_lbAppName) {
        _lbAppName = [[UILabel alloc] init];
        _lbAppName.text = NSLocalizedString(@"BIU", nil);
        _lbAppName.textAlignment = NSTextAlignmentCenter;
        _lbAppName.textColor = [UIColor whiteColor];
        _lbAppName.font = [BLFontDefinition normalFont:15.0f];
    }
    return _lbAppName;
}

- (UILabel *)lbVersion {
    if (!_lbVersion) {
        _lbVersion = [[UILabel alloc] init];
        _lbVersion.textColor = [UIColor whiteColor];
        _lbVersion.textAlignment = NSTextAlignmentCenter;
        _lbVersion.font = [BLFontDefinition normalFont:13.0f];
        
        NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        _lbVersion.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Version ", nil), version];
    }
    return _lbVersion;
}

- (UILabel *)lbQuestion {
    if (!_lbQuestion) {
        _lbQuestion = [[UILabel alloc] init];
        _lbQuestion.text = NSLocalizedString(@"Question", nil);
        _lbQuestion.textColor = [UIColor whiteColor];
        _lbQuestion.textAlignment = NSTextAlignmentCenter;
        _lbQuestion.font = [BLFontDefinition normalFont:15.0f];
    }
    return _lbQuestion;
}

- (UITextView *)questionEmail {
    if (!_questionEmail) {
        _questionEmail = [[UITextView alloc] init];
        _questionEmail.backgroundColor = [UIColor clearColor];
        _questionEmail.text = @"question@biulove.com";
        _questionEmail.textAlignment = NSTextAlignmentCenter;
        _questionEmail.editable = NO;
        _questionEmail.dataDetectorTypes = UIDataDetectorTypeLink;
        
        // dictionary of attributes, font and color and underline
        NSDictionary *attrs = @{NSFontAttributeName : [BLFontDefinition lightFont:13.0f],
                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSUnderlineStyleAttributeName : [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        _questionEmail.linkTextAttributes = attrs;
    }
    return _questionEmail;
}

- (UILabel *)lbJoinUs {
    if (!_lbJoinUs) {
        _lbJoinUs = [[UILabel alloc] init];
        _lbJoinUs.text = NSLocalizedString(@"Join Us", nil);
        _lbJoinUs.textColor = [UIColor whiteColor];
        _lbJoinUs.textAlignment = NSTextAlignmentCenter;
        _lbJoinUs.font = [BLFontDefinition normalFont:15.0f];
    }
    return _lbJoinUs;
}

- (UITextView *)joinUsEmail {
    if (!_joinUsEmail) {
        _joinUsEmail = [[UITextView alloc] init];
        _joinUsEmail.backgroundColor = [UIColor clearColor];
        _joinUsEmail.text = @"jobs@biulove.com";
        _joinUsEmail.textAlignment = NSTextAlignmentCenter;
        _joinUsEmail.editable = NO;
        _joinUsEmail.dataDetectorTypes = UIDataDetectorTypeLink;
        
        // dictionary of attributes, font and color and underline
        NSDictionary *attrs = @{NSFontAttributeName : [BLFontDefinition lightFont:13.0f],
                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSUnderlineStyleAttributeName : [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        _joinUsEmail.linkTextAttributes = attrs;
    }
    return _joinUsEmail;
}

- (UILabel *)lbBusiness {
    if (!_lbBusiness) {
        _lbBusiness = [[UILabel alloc] init];
        _lbBusiness.text = NSLocalizedString(@"Business about us", nil);
        _lbBusiness.textColor = [UIColor whiteColor];
        _lbBusiness.textAlignment = NSTextAlignmentCenter;
        _lbBusiness.font = [BLFontDefinition normalFont:15.0f];
    }
    return _lbBusiness;
}

- (UITextView *)businessEmail {
    if (!_businessEmail) {
        _businessEmail = [[UITextView alloc] init];
        _businessEmail.backgroundColor = [UIColor clearColor];
        _businessEmail.text = @"business@biulove.com";
        _businessEmail.textAlignment = NSTextAlignmentCenter;
        _businessEmail.editable = NO;
        _businessEmail.dataDetectorTypes = UIDataDetectorTypeLink;
        
        // dictionary of attributes, font and color and underline
        NSDictionary *attrs = @{NSFontAttributeName : [BLFontDefinition lightFont:13.0f],
                     NSForegroundColorAttributeName : [UIColor whiteColor],
                      NSUnderlineStyleAttributeName : [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        _businessEmail.linkTextAttributes = attrs;
    }
    return _businessEmail;
}

- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [[UIButton alloc] init];
        [_btnBack setImage:[UIImage imageNamed:@"left_arrow.png"] forState:UIControlStateNormal];
        [_btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBack;
}

@end
