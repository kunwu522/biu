//
//  BLSuggestionViewController.m
//  biu
//
//  Created by Tony Wu on 7/24/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLSuggestionViewController.h"
#import "Masonry.h"

@interface BLSuggestionViewController () <UITextViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UITextView *tvSuggestion;
@property (strong, nonatomic) UIButton *btnDone;
@property (strong, nonatomic) UIButton *btnBack;
@property (strong, nonatomic) UITextField *tfEmail;
@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UILabel *lbPlaceHolder;
@property (assign, nonatomic) BOOL hasEdited;

@property (strong, nonatomic) User *currentUser;

@end

@implementation BLSuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hasEdited = NO;
    
    [self.view addSubview:self.background];
    [self.view addSubview:self.lbTitle];
    [self.view addSubview:self.tvSuggestion];
    [self.view addSubview:self.btnBack];
    [self.view addSubview:self.btnDone];
    [self.view addSubview:self.tfEmail];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.lbPlaceHolder];
    
    [self loadLayouts];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    [self.view addGestureRecognizer:tapGesture];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
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
    
    [self.tfEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tfEmail.superview).with.offset([BLGenernalDefinition resolutionForDevices:10.0f]);
        make.right.equalTo(self.tfEmail.superview).with.offset([BLGenernalDefinition resolutionForDevices:-10.0f]);
        make.bottom.equalTo(self.tfEmail.superview);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:50.0f]]);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineView.superview);
        make.bottom.equalTo(self.tfEmail.mas_top).with.offset(-1.0f);
        make.height.equalTo(@0.5f);
    }];
    
    [self.btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btnDone.superview);
        make.bottom.equalTo(self.lineView).with.offset([BLGenernalDefinition resolutionForDevices:-20.0f]);
    }];
    
    [self.tvSuggestion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbTitle.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:60.0f]);
        make.left.right.equalTo(self.tvSuggestion.superview);
        make.bottom.equalTo(self.btnDone.mas_top).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [self.lbPlaceHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tvSuggestion).with.offset([BLGenernalDefinition resolutionForDevices:5.0f]);
        make.left.equalTo(self.tvSuggestion).with.offset([BLGenernalDefinition resolutionForDevices:15.0f]);
        make.right.equalTo(self.tvSuggestion).with.offset([BLGenernalDefinition resolutionForDevices:-15.0f]);
    }];
}

- (void)layoutWithKeyboardShowing:(CGFloat)keyboardHeight {
    [self.tfEmail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tfEmail.superview).with.offset(-keyboardHeight - 20);
    }];
    
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.lineView.superview);
//        make.bottom.equalTo(self.tfEmail.mas_top).with.offset(-1.0f);
//        make.height.equalTo(@0.5f);
//    }];
//    
//    [self.btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.btnDone.superview);
//        make.bottom.equalTo(self.lineView).with.offset([BLGenernalDefinition resolutionForDevices:-20.0f]);
//    }];
//    
//    [self.tvSuggestion mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lbTitle.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:60.0f]);
//        make.left.right.equalTo(self.tvSuggestion.superview);
//        make.bottom.equalTo(self.btnDone.mas_top).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
//    }];
//    
//    [self.lbPlaceHolder mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.tvSuggestion).with.offset([BLGenernalDefinition resolutionForDevices:5.0f]);
//        make.left.equalTo(self.tvSuggestion).with.offset([BLGenernalDefinition resolutionForDevices:15.0f]);
//        make.right.equalTo(self.tvSuggestion).with.offset([BLGenernalDefinition resolutionForDevices:-15.0f]);
//    }];
}

- (void)layoutWithKeyboardHidding {
    [self.tfEmail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tfEmail.superview);
    }];
}

#pragma mark - Delegates
#pragma mark TextView delegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.tvSuggestion.text.length == 0) {
        self.hasEdited = NO;
        self.lbPlaceHolder.hidden = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (!self.hasEdited) {
        self.lbPlaceHolder.hidden = YES;
        self.hasEdited = YES;
    }
}

#pragma mark AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && alertView.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Actions
- (void)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)done:(id)sender {
    if (self.tvSuggestion.text.length == 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请给我们提出宝贵意见" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    [[BLHTTPClient sharedBLHTTPClient] createSuggestion:self.tvSuggestion.text email:self.tfEmail.text userId:self.currentUser.userId success:^(NSURLSessionDataTask *task, id responseObject) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"感谢您提出的宝贵意见" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        av.tag = 0;
        av.delegate = self;
        [av show];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Create suggestion failed, error: %@.", error);
    }];
}

- (void)tapBackground:(UIGestureRecognizer *)recognizer {
    [self.tvSuggestion resignFirstResponder];
    [self.tfEmail resignFirstResponder];
}

#pragma mark - Notification
// Called when the UIKeyboardWillShowNotification is sent.
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if ([self.tfEmail isFirstResponder]) {
        NSDictionary* keyboardInfo = [aNotification userInfo];
        NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        [self layoutWithKeyboardShowing:keyboardFrameBeginRect.size.height];
        
        [UIView animateWithDuration:0.2f animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self layoutWithKeyboardHidding];
    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutIfNeeded];
    }];
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
        _lbTitle.text = NSLocalizedString(@"Suggestion", nil);
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        _lbTitle.textColor = [UIColor whiteColor];
        _lbTitle.font = [BLFontDefinition normalFont:18.0f];
    }
    return _lbTitle;
}

- (UITextView *)tvSuggestion {
    if (!_tvSuggestion) {
        _tvSuggestion = [[UITextView alloc] init];
        _tvSuggestion.backgroundColor = [UIColor clearColor];
        _tvSuggestion.textColor = [UIColor whiteColor];
        _tvSuggestion.font = [BLFontDefinition normalFont:15.0f];
        _tvSuggestion.textContainerInset = UIEdgeInsetsMake([BLGenernalDefinition resolutionForDevices:5.0f],
                                                            [BLGenernalDefinition resolutionForDevices:10.0f],
                                                            [BLGenernalDefinition resolutionForDevices:5.0f],
                                                            [BLGenernalDefinition resolutionForDevices:10.0f]);
        _tvSuggestion.delegate = self;
    }
    return _tvSuggestion;
}

- (UIButton *)btnDone {
    if (!_btnDone) {
        _btnDone = [[UIButton alloc] init];
        [_btnDone setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
        [_btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnDone.titleLabel.font = [BLFontDefinition normalFont:15.0f];
        [_btnDone addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDone;
}

- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [[UIButton alloc] init];
        [_btnBack setImage:[UIImage imageNamed:@"left_arrow.png"] forState:UIControlStateNormal];
        [_btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBack;
}

- (UITextField *)tfEmail {
    if (!_tfEmail) {
        _tfEmail = [[UITextField alloc] init];
        _tfEmail.backgroundColor = [UIColor clearColor];
        _tfEmail.textColor = [UIColor whiteColor];
        _tfEmail.font = [BLFontDefinition normalFont:15.0f];
        _tfEmail.placeholder = NSLocalizedString(@"Would you mind leave your emails", nil);
        
        // dictionary of attributes, font, paragraphstyle, and color
        NSDictionary *attrs = @{NSFontAttributeName : [BLFontDefinition lightFont:15.0f],
                     NSForegroundColorAttributeName : [UIColor lightGrayColor]};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_tfEmail.placeholder attributes:attrs];
        _tfEmail.attributedPlaceholder = attributedString;
    }
    return _tfEmail;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}

- (UILabel *)lbPlaceHolder {
    if (!_lbPlaceHolder) {
        _lbPlaceHolder = [[UILabel alloc] init];
        _lbPlaceHolder.text = NSLocalizedString(@"You'er the best adviser", nil);
        _lbPlaceHolder.textColor = [UIColor lightGrayColor];
        _lbPlaceHolder.font = [BLFontDefinition lightFont:15.0f];
        _lbPlaceHolder.numberOfLines = 0;
    }
    return _lbPlaceHolder;
}

- (User *)currentUser {
    if (!_currentUser) {
        _currentUser = [[User alloc] initWithFromUserDefault];
    }
    return _currentUser;
}

@end
