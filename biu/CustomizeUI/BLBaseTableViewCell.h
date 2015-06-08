//
//  BLBaseTableViewCell.h
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLBaseTableViewCell;

@protocol BLTableViewCellDeletage <NSObject>

@optional
-(void)tableViewCell:(BLBaseTableViewCell *)cell didChangeValue:(id)value;

@end

@interface BLBaseTableViewCell : UITableViewCell

@property (weak, nonatomic) id<BLTableViewCellDeletage> delegate;

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIView *content;

- (void)layout;
- (BOOL)needShowPaddingImage;

@end
