//
//  BLZodiacTableViewCell.m
//  biu
//
//  Created by WuTony on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLZodiacTableViewCell.h"

@interface BLZodiacCollectionViewCell : UICollectionViewCell

@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) UILabel *lbZoidac;

@end

@interface BLZodiacTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (retain, nonatomic) UICollectionView *collectionView;

@end

@implementation BLZodiacTableViewCell

typedef NS_ENUM(NSUInteger, BLZodiac) {
    BLZodiacAries = 0,
    BLZodiacTaurus = 1,
    BLZodiacGemini = 2,
    BLZodiacCancer = 3,
    BLZodiacLeo = 4,
    BLZodiacVirgo = 5,
    BLZodiacLibra = 6,
    BLZodiacScorpio = 7,
    BLZodiacSagittarius = 8,
    BLZodiacCapricorn = 9,
    BLZodiacAquarius = 10,
    BLZodiacPisces = 11
};

static const float INSET_LEFT_RIGHT = 42.7f;
static const float MIN_INTERITEM_SPACING = 25.3f;
static const float MIN_LINE_SPACING = 21.5f;
static const float CELL_HEIGHT = 109.3;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, INSET_LEFT_RIGHT, 0, INSET_LEFT_RIGHT);
        layout.minimumInteritemSpacing = MIN_INTERITEM_SPACING;
        layout.minimumLineSpacing = MIN_LINE_SPACING;
        CGFloat width = (self.frame.size.width - (INSET_LEFT_RIGHT * 2) - (MIN_INTERITEM_SPACING * 2)) / 3;
        layout.itemSize = CGSizeMake(width, CELL_HEIGHT);
        
        _collectionView = [[UICollectionView alloc] init];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_collectionView registerClass:[BLZodiacCollectionViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([BLZodiacCollectionViewCell class])];
        
        [self addSubview:_collectionView];
    }
    return self;
}

#pragma mark - handle ViewController delegate and datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (BLZodiacCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLZodiacCollectionViewCell *cell = (BLZodiacCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BLZodiacCollectionViewCell class]) forIndexPath:indexPath];
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation BLZodiacCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    [self addSubview:self.imageView];
    
    self.lbZoidac = [[UILabel alloc] init];
    self.lbZoidac.font = [BLFontDefinition normalFont:20.0f];
    self.lbZoidac.textColor = [BLColorDefinition fontGrayColor];
    self.lbZoidac.textAlignment = NSTextAlignmentCenter;
    self.lbZoidac.numberOfLines = 1;
    self.lbZoidac.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.lbZoidac];
}

@end
