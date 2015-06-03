//
//  BLBaseTableViewCell.m
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLBaseTableViewCell.h"
#import "Masonry.h"

@interface BLBaseTableViewCell ()

@property (strong, nonatomic) UIImageView *imageViewPadding;

@end

@implementation BLBaseTableViewCell

@synthesize content;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [BLColorDefinition backgroundGrayColor];
        
        self.title = [[UILabel alloc] init];
        self.title.font = [BLFontDefinition normalFont:20.0f];
        self.title.textColor = [BLColorDefinition fontGrayColor];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.backgroundColor = [UIColor clearColor];
        [self addSubview:self.title];
        
        _imageViewPadding = [[UIImageView alloc] init];
        _imageViewPadding.image = [UIImage imageNamed:@"padding.png"];
        [self addSubview:_imageViewPadding];
        
        self.content = [[UIView alloc] init];
        self.content.backgroundColor = [UIColor clearColor];
        self.content.clipsToBounds = YES;
        [self addSubview:self.content];
        
        [self layout];
    }
    
    return self;
}

- (void)layout {
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).with.offset(28.1f);
    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom);
        make.left.equalTo(self.content.superview);
        make.right.equalTo(self.content.superview);
        make.bottom.equalTo(_imageViewPadding.mas_top);
    }];
    
    [_imageViewPadding mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageViewPadding.superview.mas_centerX);
        make.bottom.equalTo(_imageViewPadding.superview);
        make.width.equalTo(@269.3f);
        make.height.equalTo(@16.0f);
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
