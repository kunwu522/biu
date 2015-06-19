//
//  BLPickerView.h
//  biu
//
//  Created by Tony Wu on 5/28/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLPickerView;

@protocol BLPickerViewDataSource <NSObject>

@required
- (NSInteger)numberOfRowsInPickerView:(BLPickerView *)pickerView;

@optional
- (NSString *)pickerView:(BLPickerView *)pickerView titleForRow:(NSInteger)row;

@end

@protocol BLPickerViewDelegate <UIScrollViewDelegate>

@optional
- (void)pickerView:(BLPickerView *)pickerView didSelectRow:(NSInteger)row;

@end

@interface BLPickerView : UIView

@property (weak, nonatomic) id<BLPickerViewDataSource> dataSource;
@property (weak, nonatomic) id<BLPickerViewDelegate> delegate;
@property (retain, nonatomic) UIFont *font;
@property (retain, nonatomic) UIFont *highLightedFont;
@property (retain, nonatomic) UIColor *textColor;
@property (retain, nonatomic) UIColor *highLightedTextColor;
@property (assign, nonatomic, readonly) NSUInteger selectedRow;
@property (assign, nonatomic) CGFloat fisheyeFactor; // 0...1; slight value recommended such as 0.0001

- (void)reloadData;
- (void)scrollToRow:(NSUInteger)row animated:(BOOL)animated;
- (void)selectRow:(NSUInteger)row animated:(BOOL)animated;
- (void)selectRow:(NSUInteger)row animated:(BOOL)animated notifySelection:(BOOL)notifySelection;

@end
