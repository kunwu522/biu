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
        
        _stringOfStyleMan = @{[NSNumber numberWithInteger:BLStyleManTypeRich] : NSLocalizedString(@"Rich", nil),
                            [NSNumber numberWithInteger:BLStyleManTypeGFS] : NSLocalizedString(@"GFS", nil),
                            [NSNumber numberWithInteger:BLStyleManTypeDS] : NSLocalizedString(@"DS Man", nil),
                            [NSNumber numberWithInteger:BLStyleManTypeTalent] : NSLocalizedString(@"Talent", nil),
                            [NSNumber numberWithInteger:BLStyleManTypeSport] : NSLocalizedString(@"Sport", nil),
                            [NSNumber numberWithInteger:BLStyleManTypeFashion] : NSLocalizedString(@"Fashion", nil),
                            [NSNumber numberWithInteger:BLStyleManTypeYoung] : NSLocalizedString(@"Young", nil),
                            [NSNumber numberWithInteger:BLStyleManTypeCommon] : NSLocalizedString(@"Common", nil),
                            [NSNumber numberWithInteger:BLStyleManTypeAll] : NSLocalizedString(@"All", nil),};
        
        _stringOfSytleWoman = @{[NSNumber numberWithInteger:BLStyleWomanTypeGodness] : NSLocalizedString(@"Godness", nil),
                                [NSNumber numberWithInteger:BLStyleWomanTypeBFM] : NSLocalizedString(@"BFM", nil),
                                [NSNumber numberWithInteger:BLStyleWomanTypeDS] : NSLocalizedString(@"DS Woman", nil),
                                [NSNumber numberWithInteger:BLStyleWomanTypeTalent] : NSLocalizedString(@"Talent", nil),
                                [NSNumber numberWithInteger:BLStyleWomanTypeSport] : NSLocalizedString(@"Sport", nil),
                                [NSNumber numberWithInteger:BLStyleWomanTypeSexy] : NSLocalizedString(@"Sexy", nil),
                                [NSNumber numberWithInteger:BLStyleWomanTypeLovely] : NSLocalizedString(@"Lovely", nil),
                                [NSNumber numberWithInteger:BLStyleWomanTypeSuccessFul] : NSLocalizedString(@"OfficeLady", nil),
                                [NSNumber numberWithInteger:BLStyleWomanTypeAll] : NSLocalizedString(@"All", nil),};
        
    }
    return self;
}

#pragma mark - handle collection view delegate and data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.gender == BLGenderMale) {
        return _stringOfStyleMan.count;
    } else {
        return _stringOfSytleWoman.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLStyleCollectionViewCell *cell = (BLStyleCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BLStyleCollectionViewCell class]) forIndexPath:indexPath];
    if (self.gender == BLGenderMale) {
        cell.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"style_man_selected_icon%ld.png", indexPath.item]];
        cell.unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"style_man_unselected_icon%ld.png", indexPath.item]];
        cell.imageView.image = cell.unselectedImage;
        cell.style.text = [_stringOfStyleMan objectForKey:[NSNumber numberWithInteger:indexPath.item]];
    } else {
        cell.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"style_woman_selected_icon%ld.png", indexPath.item]];
        cell.unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"style_woman_unselected_icon%ld.png", indexPath.item]];
        cell.style.text = [_stringOfSytleWoman objectForKey:[NSNumber numberWithInteger:indexPath.item]];
    }
    return cell;
}

- (void)setGender:(BLGender)gender {
    if (self.gender == gender) {
        return;
    }
    
    _gender = gender;
    [_collectionView reloadData];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
