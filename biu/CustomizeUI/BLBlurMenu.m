//
//  BLBlurMenu.m
//  BLBlurMenu
//
//  Created by Tony Wu on 6/16/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLBlurMenu.h"
#import "UIViewController+BLBlurMenu.h"
#import "Masonry.h"

@interface BLBlurMenu ()

@property (strong, nonatomic) UIViewController *currentViewController;
//@property (strong, nonatomic) UIButton *btnMenu;
//@property (strong, nonatomic) UIButton *btnBackToRoot;

@end

@implementation BLBlurMenu

#pragma mark -
#pragma mark Init
- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
//    _currentViewController = [[UIViewController alloc] init];
}

#pragma mark -
#pragma mark Public Method
- (id)initWithRootViewController:(UIViewController *)rootViewController
              menuViewController:(UIViewController *)menuViewController {
    self = [self init];
    if (self) {
        _rootViewController = rootViewController;
        _menuViewController = menuViewController;
        _currentViewController = _rootViewController;
    }
    return self;
}

- (void)presentMenuViewController {
    if (!self.menuViewController) {
        return;
    }
    
    [self.currentViewController willMoveToParentViewController:nil];
    [self addChildViewController:self.menuViewController];
    
    self.menuViewController.view.frame = self.view.bounds;
    self.menuViewController.view.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
    self.menuViewController.view.alpha = 0.2f;
    
    [self transitionFromViewController:self.currentViewController toViewController:self.menuViewController duration:0.3f options:UIViewAnimationOptionTransitionNone animations:^{
        self.menuViewController.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.menuViewController.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.currentViewController removeFromParentViewController];
        [self.menuViewController didMoveToParentViewController:self];
    }];
}

- (void)hideMenuViewController {
    [self.menuViewController willMoveToParentViewController:nil];
    [self addChildViewController:self.currentViewController];
    
    self.currentViewController.view.frame = self.view.bounds;
    self.menuViewController.view.alpha = 1.0f;
    [self transitionFromViewController:self.menuViewController toViewController:self.currentViewController duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.menuViewController.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.menuViewController removeFromParentViewController];
        [self.currentViewController didMoveToParentViewController:self];
    }];
//    [self addMenuButton];
//    if (self.currentViewController != self.rootViewController) {
//        [self addBackButton];
//    }
}

- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated {
    [self.menuViewController willMoveToParentViewController:nil];
    [self addChildViewController:contentViewController];
    
    contentViewController.view.frame = self.view.bounds;
    [self transitionFromViewController:self.menuViewController toViewController:contentViewController duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [self.currentViewController removeFromParentViewController];
        [contentViewController didMoveToParentViewController:self];
        self.currentViewController = contentViewController;
    }];
//    [self addMenuButton];
//    [self addBackButton];
}

- (void)backToRootViewController {
    [self.currentViewController willMoveToParentViewController:nil];
    [self addChildViewController:self.rootViewController];
    
    self.rootViewController.view.frame = CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self transitionFromViewController:self.currentViewController toViewController:self.rootViewController duration:0.3f options:UIViewAnimationOptionTransitionNone animations: ^{
        self.currentViewController.view.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        self.rootViewController.view.frame = self.view.bounds;
    }completion:^(BOOL finished) {
        [self.currentViewController removeFromParentViewController];
        [self.rootViewController didMoveToParentViewController:self];
        self.currentViewController = self.rootViewController;
    }];
//    [self addMenuButton];
}

#pragma mark - 
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addChildViewController:_currentViewController];
    _currentViewController.view.frame = self.view.bounds;
    [self.view addSubview:_currentViewController.view];
    [_currentViewController didMoveToParentViewController:self];
    
//    [self addMenuButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Actions
//- (void)showMenu:(id)sender {
//    [self presentMenuViewController];
//}
//
//- (void)backToRoot:(id)sender {
//    [self backToRootViewController];
//}

#pragma mark - 
#pragma mark Getter
//- (UIButton *)btnMenu {
//    if (!_btnMenu) {
//        _btnMenu = [[UIButton alloc] init];
//        [_btnMenu setBackgroundImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
//        [_btnMenu addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchDown];
//    }
//    return _btnMenu;
//}

//- (UIButton *)btnBackToRoot {
//    if (!_btnBackToRoot) {
//        _btnBackToRoot = [[UIButton alloc] init];
//        [_btnBackToRoot setBackgroundImage:[UIImage imageNamed:@"back_icon2.png"] forState:UIControlStateNormal];
//        [_btnBackToRoot addTarget:self action:@selector(backToRoot:) forControlEvents:UIControlEventTouchDown];
//    }
//    return _btnBackToRoot;
//}

#pragma mark -
#pragma makr Private Method
//- (void)addMenuButton {
//    if (self.btnMenu.superview) {
//        [self.view bringSubviewToFront:self.btnMenu];
//        return;
//    }
//    [self.view addSubview:self.btnMenu];
//    
//    [self.btnMenu mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.btnMenu.superview).with.offset(31.2);
//        make.right.equalTo(self.btnMenu.superview).with.offset(-20.8);
//        make.width.equalTo(@45.3);
//        make.height.equalTo(@45.3);
//    }];
//}

//- (void)addBackButton {
//    if (self.btnBackToRoot.superview) {
//        [self.view bringSubviewToFront:self.btnBackToRoot];
//        return;
//    }
//    [self.view addSubview:self.btnBackToRoot];
//    [self.btnBackToRoot mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.btnBackToRoot.superview).with.offset(31.2f);
//        make.left.equalTo(self.btnBackToRoot.superview).with.offset(20.8f);
//        make.width.equalTo(@45.3);
//        make.height.equalTo(@45.3);
//    }];
//}

@end
