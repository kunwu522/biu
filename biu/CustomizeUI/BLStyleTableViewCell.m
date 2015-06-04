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

@end

@interface BLStyleTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (retain, nonatomic) UICollectionView *collectionView;

@end

@implementation BLStyleTableViewCell

static const float INSET_LEFT_RIGHT = 42.7f;
static const float MIN_INTERITEM_SPACING = 5.0f;
static const float MIN_LINE_SPACING = 21.5f;
static const float CELL_HEIGHT = 109.3;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title.text = NSLocalizedString(@"Choose your style", nil);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(20, INSET_LEFT_RIGHT, 20, INSET_LEFT_RIGHT);
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
    }
    return self;
}

#pragma mark - handle collection view delegate and data source


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
