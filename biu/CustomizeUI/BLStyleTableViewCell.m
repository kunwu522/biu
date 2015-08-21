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
@synthesize preferStyles = _preferStyles;

static const float MIN_LINE_SPACING = 21.0f;
static const float CELL_HEIGHT = 120.0;
static const float CELL_WIDTH = 90.0;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title.text = NSLocalizedString(@"Choose your style", nil);
        
        self.gender = BLGenderMale;
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat interitemSpacing = ([[UIScreen mainScreen] bounds].size.width - ([BLGenernalDefinition resolutionForDevices:CELL_WIDTH] * 3)) / 4;
        layout.sectionInset = UIEdgeInsetsMake([BLGenernalDefinition resolutionForDevices:30.0f], interitemSpacing,
                                               [BLGenernalDefinition resolutionForDevices:30.0f], interitemSpacing);
        layout.minimumInteritemSpacing = interitemSpacing;
        layout.minimumLineSpacing = MIN_LINE_SPACING;
        layout.itemSize = CGSizeMake([BLGenernalDefinition resolutionForDevices:CELL_WIDTH], [BLGenernalDefinition resolutionForDevices:CELL_HEIGHT]);
        
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
                            [NSNumber numberWithInteger:BLStyleTypeManOther] : NSLocalizedString(@"All", nil),};
        
        _stringOfSytleWoman = @{[NSNumber numberWithInteger:BLStyleTypeWomanGodness] : NSLocalizedString(@"Godness", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanBFM] : NSLocalizedString(@"BFM", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanDS] : NSLocalizedString(@"DS Woman", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanTalent] : NSLocalizedString(@"Talent", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanSport] : NSLocalizedString(@"Sport", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanSexy] : NSLocalizedString(@"Sexy", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanLovely] : NSLocalizedString(@"Lovely", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanSuccessFul] : NSLocalizedString(@"OfficeLady", nil),
                                [NSNumber numberWithInteger:BLStyleTypeWomanOther] : NSLocalizedString(@"All", nil),};
        
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
        cell.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"style_man_selected_icon%ld.png", (long)indexPath.item]];
        cell.unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"style_man_unselected_icon%ld.png", (long)indexPath.item]];
        cell.imageView.image = cell.unselectedImage;
    } else {
        cell.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"style_woman_selected_icon%ld.png", (long)indexPath.item]];
        cell.unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"style_woman_unselected_icon%ld.png", (long)indexPath.item]];
        cell.imageView.image = cell.unselectedImage;
    }
    cell.style.text = [Partner getStyleNameFromZodiac:[self styleTypeFromIndexItem:indexPath.item]];
    [self selectedItemForCollectionView:collectionView cell:cell indexPath:indexPath];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self numberOfSelectedPreferStyle] >= 3) {
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
        if ([self numberOfSelectedPreferStyle] < 3) {
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

- (NSInteger)indexItemFromStyle:(BLStyleType)style {
    if (style == BLStyleTypeNone) {
        return -1;
    }
    if (self.gender == BLGenderMale) {
        return (NSUInteger)style > 1 ?  (NSUInteger)style - 1 : 0;
    } else {
        return (NSUInteger)style > 10 ? (NSUInteger)style - 1 - 9 : 0;
    }
}

- (void)setImageForCell:(BLStyleCollectionViewCell *)cell  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allowMultiSelected) {
        if ([self.preferStyles containsObject:[NSNumber numberWithInteger:[self styleTypeFromIndexItem:indexPath.item]]]) {
            cell.imageView.image = cell.selectedImage;
        }
    } else {
        if ([self indexItemFromStyle:self.style] == indexPath.item) {
            cell.imageView.image = cell.selectedImage;
        } else {
            cell.imageView.image = cell.unselectedImage;
        }
    }
}

- (void)selectedItemForCollectionView:(UICollectionView *)collectionView cell:(BLStyleCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (self.allowMultiSelected) {
        if ([self.preferStyles containsObject:[NSNumber numberWithInteger:[self styleTypeFromIndexItem:indexPath.item]]]) {
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [cell setSelected:YES];
        }
    } else {
        if ([self indexItemFromStyle:self.style] == indexPath.item) {
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [cell setSelected:YES];
        }
    }
}

- (NSInteger)numberOfSelectedPreferStyle {
    int count = 0;
    for (NSNumber *style in self.preferStyles) {
        BLGender gender = [Partner genderBySexuality:self.sexuality];
        if ([Partner genderByStyle:style.integerValue] == gender) {
            count++;
        }
    }
    return count;
}

#pragma mark -
#pragma mark Setter
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
    _style = style;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self indexItemFromStyle:style] inSection:0];
    [_collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [_collectionView reloadData];
}

- (void)setAllowMultiSelected:(BOOL)allowMultiSelected {
    _allowMultiSelected = allowMultiSelected;
    _collectionView.allowsMultipleSelection = allowMultiSelected;
}

- (void)setPreferStyles:(NSMutableArray *)preferStyles {
    if (!preferStyles) {
        return;
    }
    _preferStyles = preferStyles;
    for (NSNumber *type in preferStyles) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self indexItemFromStyle:(BLStyleType)type.integerValue] inSection:0];
        [_collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark Getter
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
    
    UIFont *font = [BLFontDefinition normalFont:18.0f];
    self.style = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - font.lineHeight, self.frame.size.width, font.lineHeight)];
    self.style.backgroundColor = [UIColor clearColor];
    self.style.font = [BLFontDefinition normalFont:18.0f];
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
