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
        
    }
    return self;
}

#pragma mark - handle CollectionView delegate and datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLSexualityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BLSexualityCollectionViewCell class])
                                                                                    forIndexPath:indexPath];
    cell.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"sexuality_selected_icon%li", indexPath.item]];
    cell.unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"sexuality_unselected_icon%li", indexPath.item]];
    cell.imageView.image = cell.unselectedImage;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.sexuality = (BLSexualityType)indexPath.item;
    if ([self respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
        [self.delegate tableViewCell:self didChangeValue:[NSNumber numberWithInteger:self.sexuality]];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake((self.content.bounds.size.height - BL_SEXUALITY_CELL_WIDTH) * 0.5f, 0,
                            (self.content.bounds.size.height - BL_SEXUALITY_CELL_WIDTH) * 0.5f, 0);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
