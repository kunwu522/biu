//
//  BLPickerView.m
//  biu
//
//  Created by Tony Wu on 5/28/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLPickerView.h"

@interface BLCollectionViewLayout : UICollectionViewFlowLayout

@end

@interface BLCollectionViewCell : UICollectionViewCell
@property (retain, nonatomic) UILabel *label;
@property (retain, nonatomic) UIFont *font;
@property (retain, nonatomic) UIFont *highLightedFont;
@end

@interface BLPickerView() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
@property (retain, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) NSUInteger selectedRow;
@end

@implementation BLPickerView

- (void)setup {
    self.font = self.font ? : [BLFontDefinition normalFont:26.0f];
    self.highLightedFont = self.highLightedFont ? : [BLFontDefinition boldFont:27.0f];
    self.textColor = self.textColor ? : [UIColor darkGrayColor];
    self.highLightedTextColor = self.highLightedTextColor ? : [BLColorDefinition greenColor];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:[self collectionViewLayout]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[BLCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BLCollectionViewCell class])];
    
    self.collectionView.layer.mask = ({
        CAGradientLayer *maskLayer = [CAGradientLayer layer];
        maskLayer.frame = self.collectionView.bounds;
        maskLayer.colors = @[(id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor clearColor] CGColor],];
        maskLayer.locations = @[@0.0, @0.33, @0.66, @1.0];
        maskLayer.startPoint = CGPointMake(0.0, 0.0);
        maskLayer.endPoint = CGPointMake(0.0, 1.0);
        maskLayer;
    });
    
    [self addSubview:_collectionView];
}

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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.collectionViewLayout = [self collectionViewLayout];
    if ([self.dataSource numberOfRowsInPickerView:self]) {
        [self scrollToRow:self.selectedRow animated:NO];
    }
    self.collectionView.layer.mask.frame = self.collectionView.bounds;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, MAX(self.font.lineHeight, self.highLightedFont.lineHeight));
}

- (BLCollectionViewLayout *)collectionViewLayout
{
    BLCollectionViewLayout *layout = [BLCollectionViewLayout new];
    return layout;
}

- (CGSize)sizeForString:(NSString *)string
{
    CGSize size;
    CGSize highlightedSize;
#ifdef __IPHONE_7_0
    size = [string sizeWithAttributes:@{NSFontAttributeName: self.font}];
    highlightedSize = [string sizeWithAttributes:@{NSFontAttributeName: self.highLightedFont}];
#else
    size = [string sizeWithFont:self.font];
    highlightedSize = [string sizeWithFont:self.highlightedFont];
#endif
    return CGSizeMake(ceilf(MAX(size.width, highlightedSize.width)), ceilf(MAX(size.height, highlightedSize.height)));
}

- (void)setFisheyeFactor:(CGFloat)fisheyeFactor {
    _fisheyeFactor = fisheyeFactor;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -MAX(MIN(self.fisheyeFactor, 1.0), 0.0);
    self.collectionView.layer.sublayerTransform = transform;
}

- (void)reloadData
{
    [self invalidateIntrinsicContentSize];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
    if ([self.dataSource numberOfRowsInPickerView:self]) {
        [self selectRow:self.selectedRow animated:NO notifySelection:NO];
    }
}

- (CGFloat)offsetForItem:(NSUInteger)item
{
    NSAssert(item < [self.collectionView numberOfItemsInSection:0],
             @"item out of range; '%lu' passed, but the maximum is '%lu'", (unsigned long)item, (long)[self.collectionView numberOfItemsInSection:0]);
    
    CGFloat offset = 0.0;
    
    for (NSInteger i = 0; i < item; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGSize cellSize = [self collectionView:self.collectionView layout:self.collectionView.collectionViewLayout sizeForItemAtIndexPath:indexPath];
        offset += cellSize.height;
    }
    
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    CGSize firstSize = [self collectionView:_collectionView layout:_collectionView.collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
    CGSize selectedSize = [self collectionView:self.collectionView layout:self.collectionView.collectionViewLayout sizeForItemAtIndexPath:selectedIndexPath];
    offset -= (firstSize.height - selectedSize.height) / 2;
    
    return offset;
}

- (void)scrollToRow:(NSUInteger)row animated:(BOOL)animated {
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, [self offsetForItem:row]) animated:animated];
}

- (void)selectRow:(NSUInteger)row animated:(BOOL)animated {
    [self selectRow:row animated:animated notifySelection:YES];
}

- (void)selectRow:(NSUInteger)row animated:(BOOL)animated notifySelection:(BOOL)notifySelection {
    [_collectionView selectItemAtIndexPath:[NSIndexPath
                          indexPathForItem:row inSection:0]
                                  animated:animated
                            scrollPosition:UICollectionViewScrollPositionNone];
    [self scrollToRow:row animated:animated];
    
    self.selectedRow = row;
    
    if (notifySelection &&
        [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:)]) {
        [self.delegate pickerView:self didSelectRow:row];
    }
}

- (void)didEndScrolling {
    if ([self.dataSource numberOfRowsInPickerView:self]) {
        for (NSUInteger i = 0; i < [self collectionView:self.collectionView numberOfItemsInSection:0]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            BLCollectionViewCell *cell = (BLCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            if ([self offsetForItem:i] + cell.bounds.size.height > self.collectionView.contentOffset.y) {
                [self selectRow:i animated:YES];
                break;
            }
        }
    }
}


#pragma mark - UIcollectionView DataSource and Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfRowsInPickerView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BLCollectionViewCell class]) forIndexPath:indexPath];
    if ([self.dataSource respondsToSelector:@selector(pickerView:titleForRow:)]) {
        NSString *title = [self.dataSource pickerView:self titleForRow:indexPath.item];
        cell.label.text = title;
        cell.label.textColor = self.textColor;
        cell.label.highlightedTextColor = self.highLightedTextColor;
        cell.label.font = self.font;
        cell.font = self.font;
        cell.highLightedFont = self.highLightedFont;
        cell.label.bounds = (CGRect){CGPointZero, [self sizeForString:title]};
    }
    cell.selected = (indexPath.item == self.selectedRow);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height / 5);
    return size;
}

//每个item之间的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSInteger number = [self collectionView:collectionView numberOfItemsInSection:section];
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:number - 1 inSection:section];
    CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
    return UIEdgeInsetsMake((collectionView.bounds.size.height - firstSize.height) / 2, 0,
                            (collectionView.bounds.size.height - lastSize.height) / 2, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectRow:indexPath.item animated:YES];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
    
    if (!scrollView.isTracking) {
        [self didEndScrolling];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    if (!decelerate) {
        [self didEndScrolling];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    self.collectionView.layer.mask.frame = self.collectionView.bounds;
    [CATransaction commit];
}

@end

@interface BLCollectionViewLayout()
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat midY;
@property (assign, nonatomic) CGFloat maxAngle;
@end

@implementation BLCollectionViewLayout

- (id)init {
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsZero;
        self.minimumLineSpacing = 0.0f;
        self.minimumInteritemSpacing = 0.0f;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (void)prepareLayout {
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    _midY = CGRectGetMidY(visibleRect);
    _height = CGRectGetHeight(visibleRect) * 0.5f;
    _maxAngle = M_PI_2;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGFloat distance = CGRectGetMidY(attributes.frame) - _midY;
    CGFloat currentAngle = _maxAngle * distance / _height / M_PI_2;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, distance, -_height);
    transform = CATransform3DRotate(transform, currentAngle, 1, 0, 0);
    transform = CATransform3DTranslate(transform, 0, 0, _height);
    attributes.transform3D = transform;
    attributes.alpha = (ABS(currentAngle) < _maxAngle);
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    if ([self.collectionView numberOfSections]) {
        for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}

@end

@implementation BLCollectionViewCell

- (void)setup {
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    self.label.numberOfLines = 1;
    self.label.highlightedTextColor = [BLColorDefinition greenColor];
    self.label.font = [BLFontDefinition normalFont:26.0f];
    self.label.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                   UIViewAutoresizingFlexibleLeftMargin |
                                   UIViewAutoresizingFlexibleBottomMargin |
                                   UIViewAutoresizingFlexibleRightMargin);
    [self addSubview:self.label];
}

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

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
//    self.label.textColor = [BLColorDefinition greenColor];
    
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionFade];
    [transition setDuration:0.15];
    [self.label.layer addAnimation:transition forKey:nil];
    
    self.label.font = self.selected ? self.highLightedFont : self.font;
    if (selected) {
        
        self.label.highlighted = YES;//刷新UIScrollView，设置高亮
        self.label.highlightedTextColor = [BLColorDefinition greenColor];
    }

}

@end
