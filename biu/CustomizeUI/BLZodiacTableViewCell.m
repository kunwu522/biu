//
//  BLZodiacTableViewCell.m
//  biu
//
//  Created by WuTony on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLZodiacTableViewCell.h"
#import "Masonry.h"

@interface BLZodiacCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIImage *unselectedImage;
@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) UILabel *lbZoidac;

@end

@interface BLZodiacTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (retain, nonatomic) UICollectionView *collectionView;

@end

@implementation BLZodiacTableViewCell

@synthesize zodiac = _zodiac;
@synthesize allowMultiSelected = _allowMultiSelected;
@synthesize preferZodiacs = _preferZodiacs;

static const float INSET_LEFT_RIGHT = 42.7f;
static const float MIN_INTERITEM_SPACING = 5.0f;
static const float MIN_LINE_SPACING = 21.5f;
static const float CELL_HEIGHT = 109.3;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title.text = NSLocalizedString(@"Choose your Zodiac", nil);
        [self.content addSubview:self.collectionView];
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
    BLZodiac zodiac = [self zodiacFromIndexItem:indexPath.item];
    cell.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"zodiac_selected_icon%li", (long)zodiac]];
    cell.unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"zodiac_unselected_icon%li", (long)zodiac]];
    cell.lbZoidac.text = [Profile getZodiacNameFromZodiac:[self zodiacFromIndexItem:indexPath.item] isShotVersion:YES];
    if (self.allowMultiSelected) {
        if ([self.preferZodiacs containsObject:[NSNumber numberWithInteger:[self zodiacFromIndexItem:indexPath.item]]]) {
            cell.imageView.image = cell.selectedImage;
        } else {
            cell.imageView.image = cell.unselectedImage;
        }
    } else {
        if ([self indexItemFromZodiac:self.zodiac] == indexPath.item) {
            cell.imageView.image = cell.selectedImage;
        } else {
            cell.imageView.image = cell.unselectedImage;
        }
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.preferZodiacs count] >= 3) {
        return NO;
    } else {
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allowMultiSelected) {
        if ([self.preferZodiacs count] < 3) {
            [self.preferZodiacs addObject:[NSNumber numberWithInteger:[self zodiacFromIndexItem:indexPath.item]]];
            if ([self.delegate respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
                [self.delegate tableViewCell:self didChangeValue:self.preferZodiacs];
            }
        }
    } else {
        self.zodiac = [self zodiacFromIndexItem:indexPath.item];
        if ([self.delegate respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
            [self.delegate tableViewCell:self didChangeValue:[NSNumber numberWithInteger:self.zodiac]];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allowMultiSelected) {
        if ([self.preferZodiacs count] > 0) {
            [self.preferZodiacs removeObject:[NSNumber numberWithInteger:[self zodiacFromIndexItem:indexPath.item]]];
        }
    } else {
        _zodiac = BLZodiacNone;
    }
}

#pragma mark - private methods
- (NSUInteger)indexItemFromZodiac:(BLZodiac)zodiac {
    return zodiac - 1;
}

- (BLZodiac)zodiacFromIndexItem:(NSUInteger)item {
    return item + 1;
}

#pragma mark - Getter and Setter
- (void)setZodiac:(BLZodiac)zodiac {
    _zodiac = zodiac;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(zodiac - 1) inSection:0];
    [_collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)setAllowMultiSelected:(BOOL)allowMultiSelected {
    _allowMultiSelected = allowMultiSelected;
    _collectionView.allowsMultipleSelection = allowMultiSelected;
}

- (void)setPreferZodiacs:(NSMutableArray *)preferZodiacs {
    if (!preferZodiacs) {
        return;
    }
    _preferZodiacs = preferZodiacs;
    for (NSNumber *zodiac in _preferZodiacs) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self indexItemFromZodiac:(BLZodiac)zodiac.integerValue] inSection:0];
        [_collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (NSMutableArray *)preferZodiacs {
    if (!_preferZodiacs) {
        _preferZodiacs = [NSMutableArray array];
    }
    return _preferZodiacs;
}

- (UICollectionView *)collectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(40, INSET_LEFT_RIGHT, 20, INSET_LEFT_RIGHT);
    layout.minimumInteritemSpacing = MIN_INTERITEM_SPACING;
    layout.minimumLineSpacing = MIN_LINE_SPACING;
    CGFloat width = (self.frame.size.width - (INSET_LEFT_RIGHT * 2) - (MIN_INTERITEM_SPACING * 2)) / 3;
    layout.itemSize = CGSizeMake(width, CELL_HEIGHT);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.content.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[BLZodiacCollectionViewCell class]
        forCellWithReuseIdentifier:NSStringFromClass([BLZodiacCollectionViewCell class])];
    return _collectionView;
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
    
    UIFont *font = [BLFontDefinition normalFont:20.0f];
    self.lbZoidac = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - font.lineHeight, self.frame.size.width, font.lineHeight)];
    self.lbZoidac.backgroundColor = [UIColor clearColor];
    self.lbZoidac.font = [BLFontDefinition normalFont:20.0f];
    self.lbZoidac.textColor = [BLColorDefinition fontGrayColor];
    self.lbZoidac.textAlignment = NSTextAlignmentCenter;
    self.lbZoidac.numberOfLines = 1;
    [self addSubview:self.lbZoidac];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.imageView.image = self.selectedImage;
        self.lbZoidac.textColor = [BLColorDefinition fontGreenColor];
    } else {
        self.imageView.image = self.unselectedImage;
        self.lbZoidac.textColor = [BLColorDefinition fontGrayColor];
    }
}

@end
