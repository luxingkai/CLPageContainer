//
//  CLPageTitleView.m
//  CLPageContainer
//
//  Created by tigerfly on 2020/5/30.
//  Copyright © 2020 tigerfly. All rights reserved.
//

#import "CLPageTitleView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation CLPageTitleCell {
    
    UILabel *_titleLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView {
    
    _titleLab = [UILabel new];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLab];
    _titleLab.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLab.text = title;
}

#pragma mark --

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"selected"]) {
        if ([change[@"new"] intValue] == 1) {
            _titleLab.textColor = [UIColor redColor];
        }else {
            _titleLab.textColor = [UIColor blackColor];
        }
    }
}

@end


@interface CLPageTitleView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@end

@implementation CLPageTitleView {
    
    UICollectionView *_collectionView;
    NSUInteger _defaultSelectIndex;
}

static NSString *const titleIdentifier = @"titleIdentifier";

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        _defaultSelectIndex = 1; //默认选中第一项
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50.0) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.allowsSelection = YES;
    [self addSubview:_collectionView];
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:true scrollPosition:UICollectionViewScrollPositionNone];

    [_collectionView registerClass:[CLPageTitleCell class] forCellWithReuseIdentifier:titleIdentifier];
}

#pragma mark --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CLPageTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:titleIdentifier forIndexPath:indexPath];
    cell.title = _titles[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width = [_titles[indexPath.row] boundingRectWithSize:CGSizeMake(MAXFLOAT, 45.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSc-Regular" size:12]} context:nil].size.width;
    return CGSizeMake(width + 16.0, 45.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}



#pragma mark -- Setter

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [_collectionView reloadData];
}



@end
