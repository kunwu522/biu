//
//  BLSexualityTableViewCell.m
//  biu
//
//  Created by Tony Wu on 6/3/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLSexualityTableViewCell.h"
#import "BLRingView.h"

@interface BLSexualityCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIImage *unselectedImage;
@property (strong, nonatomic) UIImageView *imageView;

@end

@interface BLSexualityTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSDictionary *sexualityDictionary;
@property (assign, nonatomic) BOOL allowMutipleSelection;

@end

@implementation BLSexualityTableViewCell

static const float BL_SEXUALITY_MIN_INTER_SPACING = 5.0f;
static const float BL_SEXUALITY_CELL_WIDTH = 100.0f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title.text = NSLocalizedString(@"Choose your partner's sexuality", nil);
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout alloc];
        layout.minimumInteritemSpacing = BL_SEXUALITY_MIN_INTER_SPACING;
        layout.minimumLineSpacing = BL_SEXUALITY_MIN_INTER_SPACING;
        layout.itemSize = CGSizeMake(BL_SEXUALITY_CELL_WIDTH, BL_SEXUALITY_CELL_WIDTH);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.content.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[BLSexualityCollectionViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([BLSexualityCollectionViewCell class])];
        [self.content addSubview:_collectionView];
        
        self.allowMutipleSelection = NO;
    }
    return self;
}

#pragma mark - handle CollectionView delegate and datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.gender == BLGenderNone) {
        return 6;
    } else {
        return 3;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLSexualityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BLSexualityCollectionViewCell class])
                                                                                    forIndexPath:indexPath];
    cell.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"sexuality_selected_icon%li", [self sexualityFromIndexItem:indexPath.item]]];
    cell.unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"sexuality_unselected_icon%li", [self sexualityFromIndexItem:indexPath.item]]];
    if ([self indexItemFromSexuality:_sexuality] == indexPath.item) {
        cell.imageView.image = cell.selectedImage;
    } else {
        cell.imageView.image = cell.unselectedImage;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BLSexualityType sexuality = [self sexualityFromIndexItem:indexPath.item];
    if (!self.sexualities) {
        self.sexuality = sexuality;
        if ([self.delegate respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
            [self.delegate tableViewCell:self didChangeValue:[NSNumber numberWithInteger:self.sexuality]];
        }
    } else if (self.sexualities.count <= 3) {
        [self.sexualities addObject:[NSNumber numberWithInteger:sexuality]];
        if ([self.delegate respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
            [self.delegate tableViewCell:self didChangeValue:self.sexualities];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sexualities) {
        [self.sexualities removeObject:[NSNumber numberWithInteger:[self sexualityFromIndexItem:indexPath.item]]];
        if ([self.delegate respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
            [self.delegate tableViewCell:self didChangeValue:self.sexualities];
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat insetVertical = (self.content.bounds.size.height - BL_SEXUALITY_CELL_WIDTH) * 0.5f;
    CGFloat insetHorizontal = (self.content.bounds.size.width - ([collectionView numberOfItemsInSection:section] * ((UICollectionViewFlowLayout *)collectionViewLayout).itemSize.width
                                     + ([collectionView numberOfItemsInSection:section] - 1) * ((UICollectionViewFlowLayout *)collectionViewLayout).minimumInteritemSpacing)) * 0.5;
    if (self.gender == BLGenderNone) {
        return UIEdgeInsetsMake(insetVertical, 0, insetVertical, 0);
    } else {
        return UIEdgeInsetsMake(insetVertical, insetHorizontal, insetVertical, insetHorizontal);
    }
}

#pragma mark
#pragma Getter and Setter
- (void)setSexuality:(BLSexualityType)sexuality {
    _sexuality = sexuality;
    if (_sexuality == BLSexualityTypeNone) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self indexItemFromSexuality:sexuality] inSection:0];
    [_collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)setSexualities:(NSMutableArray *)sexualities {
    if (!sexualities) {
        return;
    }
    self.collectionView.allowsMultipleSelection = YES;
    self.allowMutipleSelection = YES;

    _sexualities = sexualities;
    for (NSNumber *sexuality in _sexualities) {
        if (sexuality == BLSexualityTypeNone) {
            continue;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self indexItemFromSexuality:(BLSexualityType)sexuality.integerValue] inSection:0];
        [_collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void)setGender:(BLGender)gender {
    _gender = gender;
    [self.collectionView reloadData];
}

#pragma mark - private method
- (BLSexualityType)sexualityFromIndexItem:(NSInteger)item {
    BLSexualityType sexuality;
    switch (self.gender) {
        case BLGenderMale:
            switch (item) {
                case 0:
                    sexuality = BLSexualityTypeMan;
                    break;
                case 1:
                    sexuality = BLSexualityType1;
                    break;
                case 2:
                    sexuality = BLSexualityType0;
                default:
                    break;
            }
            break;
        case BLGenderFemale:
            switch (item) {
                case 0:
                    sexuality = BLSexualityTypeWoman;
                    break;
                case 1:
                    sexuality = BLSexualityTypeT;
                    break;
                case 2:
                    sexuality = BLSexualityTypeP;
                default:
                    break;
            }
            break;
        default:
            sexuality = item + 1;
            break;
    }
    return sexuality;
}
- (NSInteger)indexItemFromSexuality:(BLSexualityType)sexuality {
    NSInteger item = 0;
    if (sexuality == BLSexualityTypeNone) {
        return -1;
    }
    switch (self.gender) {
        case BLGenderMale:
            switch (sexuality) {
                case BLSexualityTypeMan:
                    item = 0;
                    break;
                case BLSexualityType1:
                    item = 1;
                    break;
                case BLSexualityType0:
                    item =2;
                    break;
                default:
                    break;
            }
            break;
        case BLGenderFemale:
            switch (sexuality) {
                case BLSexualityTypeWoman:
                    item = 0;
                    break;
                case BLSexualityTypeT:
                    item = 1;
                    break;
                case BLSexualityTypeP:
                    item = 2;
                    break;
                default:
                    break;
            }
            break;
        default:
            item = sexuality > 1 ? sexuality - 1 : 0;
            break;
    }
    return item;
}

@end

@interface BLSexualityCollectionViewCell ()

//@property (strong, nonatomic) BLRingView *ringView;
@property (strong, nonatomic) UIView *selectedRingView;

@end

@implementation BLSexualityCollectionViewCell

static float PADDING = 15.0f;

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
    _selectedRingView = [[UIView alloc] initWithFrame:self.bounds];
    _selectedRingView.backgroundColor = [UIColor clearColor];
    _selectedRingView.layer.cornerRadius = self.bounds.size.width / 2;
    _selectedRingView.layer.borderColor = [[UIColor colorWithRed:28.0f / 255.0f green:184.0f / 255.0f blue:134.0f / 255.0f alpha:1.0f] CGColor];
    _selectedRingView.layer.borderWidth = 4.0f;
    _selectedRingView.alpha = 0.0f;
    [self addSubview:_selectedRingView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING * 0.5f, PADDING * 0.5f, self.bounds.size.width - PADDING, self.bounds.size.width - PADDING)];
    _imageView.layer.cornerRadius = (self.bounds.size.width - PADDING) * 0.5f;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.imageView.image = self.selectedImage;
        _selectedRingView.alpha = 1.0f;
        
    } else {
        self.imageView.image = self.unselectedImage;
        _selectedRingView.alpha = 0.0f;
    }
}

@end
