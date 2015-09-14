//
//  BLLabel.m
//  biu
//
//  Created by Dezi on 15/9/14.
//  Copyright (c) 2015年 BiuLove. All rights reserved.
//

#import "BLLabel.h"

@interface BLLabel ()

@property (nonatomic, strong)UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign)id tapTarget;
@property (nonatomic, assign)SEL tapAction;

@property (nonatomic, strong)UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, assign)id longPressBeganTarget;
@property (nonatomic, assign)SEL longPressBeganAction;
@property (nonatomic, assign)id longPressEndTarget;
@property (nonatomic, assign)SEL longPressEndAction;

@end

@implementation BLLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(BLLabelControlEvents)controlEvents{
    @synchronized(self){
        if (controlEvents == BLLabelControlEventTap) {
            if (self.tapGesture == nil) {
                self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
                [self addGestureRecognizer:self.tapGesture];
            }
            
            self.tapTarget = target;
            self.tapAction = action;
        }else if (controlEvents == BLLabelControlEventLongPressBegan){
            if (self.longPressGesture == nil) {
                self.longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
                [self addGestureRecognizer:self.longPressGesture];
            }
            
            self.longPressBeganTarget = target;
            self.longPressBeganAction = action;
        }else if (controlEvents == BLLabelControlEventLongPressEnd){
            if (self.longPressGesture == nil) {
                self.longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
                [self addGestureRecognizer:self.longPressGesture];
            }
            
            self.longPressEndTarget = target;
            self.longPressEndAction = action;
        }
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture{
    if (gesture.state ==  UIGestureRecognizerStateBegan) {
        
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state ==UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled) {
        if (self.tapTarget && self.tapAction) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            [self.tapTarget performSelector:self.tapAction withObject:self];
            
#pragma clang diagnostic pop
        }
    }
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.longPressBeganTarget && self.longPressBeganAction) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            [self.longPressBeganTarget performSelector:self.longPressBeganAction withObject:self];
            
#pragma clang diagnostic pop
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state ==UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled) {
        if (self.longPressEndTarget && self.longPressEndAction) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            [self.longPressEndTarget performSelector:self.longPressEndAction withObject:self];
            
#pragma clang diagnostic pop
        }
    }
}


@end
