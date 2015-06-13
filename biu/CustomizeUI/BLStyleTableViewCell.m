//
//  BLStyleTableViewCell.m
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLStyleTableViewCell.h"

@interface BLStyleCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIImage *unselectedImage;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *style;

@end

@interface BLStyleTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (retain, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSDictionary *stringOfStyleMan;
@property (strong, nonatomic) NSDictionary *stringOfSytleWoman;

@end

@implementation BLStyleTableViewCell

@synthesize gender = _gender;
@synthesize sexuality = _sexuality;

static const float INSET_LEFT_RIGHT = 42.7f;
static const float MIN_INTERITEM_SPACING = 5.0f;
static const float MIN_LINE_SPACING = 21.5f;
static const float CELL_HEIGHT = 109.3;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title.text = NSLocalizedString(@"Choose your style", nil);
        
        self.gender = BLGenderMale;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(30, INSET_LEFT_RIGHT, 30, INSET_LEFT_RIGHT);
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
        [_collectionView registerClass:[BLStyleCollectionViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([BLStyleCollectionViewCell class])];
        [self.content addSubview:_collectionView];
        
        _stringOfStyleMan = @{[NSNumber numberWithInteger:BLStyleTypeManRich] : NSLocalizedString(@"Rich", nil),
                            [NSNumber numberWithInteger:BLStyleTypeManGFS] : NSLocalizedString(@"GFS", nil),
                            [NSNumber numberWithInteger:BLStyleTypeManDS] : NSLocalizedString(@"DS Man", nil),
                            [NSNumber numberWithInteger:BLStyleTypeManTalent] : NSLocalizedString(@"Talent", nil),
                            [NSNumber numberWithInteger:BLStyleTypeManSport] : NSLocalizedString(@"Sport", nil),
                            [NSNumber numberWithInteger:BLStyleTypeManFashion] : NSLocalizedString(@"Fashion", nil),
                            [NSNumber numberWithInteger:BLStyleTypeManYoung] : NSLocalizedString(@"Young", nil),
                            [NSNumber numberWithInteger:BLStyleTypeManCommon] : NSLocalizedString(@"Common", nil),
                            [NSNumber numberWithInteger:BLStyleTypeManAll] : NSLocalizedString(@"All", nil),};
        
        _stringOfSytleWoman = @{[NSNumber numberWithInteger:BLStyleTypeWomanGodness] : NSLocalizedString(@"Godness", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanBFM] : NSLocalizedString(@"BFM", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanDS] : NSLocalizedString(@"DS Woman", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanTalent] : NSLocalizedString(@"Talent", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanSport] : NSLocalizedString(@"Sport", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanSexy] : NSLocalizedString(@"Sexy", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanLovely] : NSLocalizedString(@"Lovely", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanSuccessFul] : NSLocalizedString(@"OfficeLady", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanAll] : NSLocalizedString(@"All", nil),};
        
    }
    return self;
}

#pragma mark - handle collection view delegate and data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLStyleCollectionViewCell *cell = (BLStyleCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BLStyleCollectionViewCell class]) forIndexPath:indexPath];
    if (self.gender == BLGenderMale) {
        cell.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"style_man_selected_icon%ld.png", indexPath.item]];
        cell.unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"style_man_unselected_icon%ld.png", indexPath.item]];
        cell.imageView.image = cell.unselectedImage;
    } else {
        cell.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"style_woman_selected_icon%ld.png", indexPath.item]];
        cell.unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"style_woman_unselected_icon%ld.png", indexPath.item]];
        cell.imageView.image = cell.unselectedImage;
    }
    cell.style.text = [Partner getStyleNameFromZodiac:[self styleTypeFromIndexItem:indexPath.item]];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.preferStyles count] >= 3) {
        return NO;
    } else {
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BLStyleType styleType = [self styleTypeFromIndexItem:indexPath.item];
    if (!self.allowMultiSelected) {
        _style = styleType;
        if ([self.delegate respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
            [self.delegate tableViewCell:self didChangeValue:[NSNumber numberWithInteger:self.style]];
        }
    } else {
        if ([self.preferStyles count] < 3) {
            [self.preferStyles addObject:[NSNumber numberWithInteger:[self styleTypeFromIndexItem:indexPath.item]]];
            if ([self.delegate respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
                [self.delegate tableViewCell:self didChangeValue:self.preferStyles];
            }
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allowMultiSelected) {
        [self.preferStyles removeObject:[NSNumber numberWithInteger:[self styleTypeFromIndexItem:indexPath.item]]];
        if ([self.delegate respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
            [self.delegate tableViewCell:self didChangeValue:self.preferStyles];
        }
    }
}

#pragma mark - private method
- (BLStyleType)styleTypeFromIndexItem:(NSUInteger)item {
    if (self.gender == BLGenderMale) {
        return item + 1;
    } else {
        return item + 1 + 9;
    }
}

- (NSUInteger)indexItemFromStyle:(BLStyleType)style {
    if (self.gender == BLGenderMale) {
        return (NSUInteger)style - 1;
    } else {
        return (NSUInteger)style - 1 - 9;
    }
}

#pragma mark - Getting and Setting
- (void)setGender:(BLGender)gender {
    if (gender == BLGenderNone) {
        return;
    }
    
    if (self.gender == gender) {
        return;
    }
    
    _gender = gender;
    [_collectionView reloadData];
}

- (void)setSexuality:(BLSexualityType)sexuality {
    if (_sexuality == sexuality) {
        return;
    }
    
    _sexuality = sexuality;
    switch (_sexuality) {
        case BLSexualityTypeMan:
        case BLSexualityType0:
        case BLSexualityType1:
            self.gender = BLGenderMale;
            break;
        case BLSexualityTypeWoman:
        case BLSexualityTypeP:
        case BLSexualityTypeT:
            self.gender = BLGenderFemale;
            break;
        default:
            break;
    }
    [_collectionView reloadData];
}

- (void)setStyle:(BLStyleType)style {
    NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndex:(style % 9)];
    [_collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
}

- (void)setAllowMultiSelected:(BOOL)allowMultiSelected {
    _allowMultiSelected = allowMultiSelected;
    _collectionView.allowsMultipleSelection = allowMultiSelected;
}

- (NSMutableArray *)preferStyles {
    if (!_preferStyles) {
        _preferStyles = [NSMutableArray array];
    }
    return _preferStyles;
}

#pragma mark - override method
- (BOOL)needShowPaddingImage {
    return NO;
}

@end

@implementation BLStyleCollectionViewCell

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
    self.style = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - font.lineHeight, self.frame.size.width, font.lineHeight)];
    self.style.backgroundColor = [UIColor clearColor];
    self.style.font = [BLFontDefinition normalFont:20.0f];
    self.style.textColor = [BLColorDefinition fontGrayColor];
    self.style.textAlignment = NSTextAlignmentCenter;
    self.style.numberOfLines = 1;
    [self addSubview:self.style];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.imageView.image = self.selectedImage;
        self.style.textColor = [BLColorDefinition fontGreenColor];
    } else {
        self.imageView.image = self.unselectedImage;
        self.style.textColor = [BLColorDefinition fontGrayColor];
    }
}



@end
