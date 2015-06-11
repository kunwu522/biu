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
@property (retain, nonatomic) NSDictionary *stringOfZodiac;

@end

@implementation BLZodiacTableViewCell

@synthesize zodiac;

static const float INSET_LEFT_RIGHT = 42.7f;
static const float MIN_INTERITEM_SPACING = 5.0f;
static const float MIN_LINE_SPACING = 21.5f;
static const float CELL_HEIGHT = 109.3;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title.text = NSLocalizedString(@"Choose your Zodiac", nil);
        
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
        
        _stringOfZodiac = @{[NSNumber numberWithInteger:BLZodiacAries] : NSLocalizedString(@"Aries", nil),
                            [NSNumber numberWithInteger:BLZodiacTaurus] : NSLocalizedString(@"Taurus", nil),
                            [NSNumber numberWithInteger:BLZodiacGemini] : NSLocalizedString(@"Gemini", nil),
                            [NSNumber numberWithInteger:BLZodiacCancer] : NSLocalizedString(@"Cancer", nil),
                            [NSNumber numberWithInteger:BLZodiacLeo] : NSLocalizedString(@"Leo", nil),
                            [NSNumber numberWithInteger:BLZodiacVirgo] : NSLocalizedString(@"Virgo", nil),
                            [NSNumber numberWithInteger:BLZodiacLibra] : NSLocalizedString(@"Libra", nil),
                            [NSNumber numberWithInteger:BLZodiacScorpio] : NSLocalizedString(@"Scorpio", nil),
                            [NSNumber numberWithInteger:BLZodiacSagittarius] : NSLocalizedString(@"Sagittarius", nil),
                            [NSNumber numberWithInteger:BLZodiacCapricorn] : NSLocalizedString(@"Capricorn", nil),
                            [NSNumber numberWithInteger:BLZodiacAquarius] : NSLocalizedString(@"Aquarius", nil),
                            [NSNumber numberWithInteger:BLZodiacPisces] : NSLocalizedString(@"Pisces", nil)};
        
        [self.content addSubview:_collectionView];
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
    cell.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"zodiac_selected_icon%li", indexPath.item]];
    cell.unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"zodiac_unselected_icon%li", indexPath.item]];
    cell.imageView.image = cell.unselectedImage;
    cell.lbZoidac.text = [_stringOfZodiac objectForKey:[NSNumber numberWithInteger:indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.zodiac = indexPath.item;
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
        [self.delegate tableViewCell:self didChangeValue:[NSNumber numberWithInteger:self.zodiac]];
    }
}

#pragma mark - 
- (void)setZodiac:(BLZodiac)zodiac {
    NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndex:zodiac];
    [_collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
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
