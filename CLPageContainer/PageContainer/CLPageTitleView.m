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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selected"]) {
        if ([change[@"new"] intValue] == 1) {
            _titleLab.textColor = [UIColor redColor];
        }else {
            _titleLab.textColor = [UIColor blackColor];
        }
    }
}

@end

/*
 需要解决的问题
 1.快速滑动到每一个指定的滑块时，需要明确显示其选中状态
 2.滑动页面时，选中滑块必须出现可视视野中
 3.点击滑块可居中显示
 4.点击滑块联动列表页
 */
@interface CLPageTitleView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@end

@implementation CLPageTitleView {
    
    UICollectionView *_collectionView;
    UIView *_bottomLine;
    NSUInteger _defaultSelectIndex;
    CGFloat _titleContentWidth;
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
        _defaultSelectIndex = 0; //默认选中第一项
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
    _collectionView.allowsSelection = true;
    [self addSubview:_collectionView];

    [_collectionView registerClass:[CLPageTitleCell class] forCellWithReuseIdentifier:titleIdentifier];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor redColor];
    [self addSubview:_bottomLine];

}

#pragma mark -- UICollectionViewDataSource

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
    if ([_delegate respondsToSelector:@selector(pageTitleView:index:)]) {
        [_delegate pageTitleView:self index:indexPath.row];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}


#pragma mark -- Setter

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [_collectionView reloadData];
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_defaultSelectIndex inSection:0] animated:true scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)setPageContainerOffset:(CGFloat)pageContainerOffset {
    
    NSInteger selectedIndex = pageContainerOffset / SCREEN_WIDTH;
}


/// 设置下一个选中项
/// @param nextIndex 指定滑块的index
- (void)setNextIndex:(NSUInteger)nextIndex {
    if (_nextIndex == nextIndex) return;
    _nextIndex = nextIndex;

    //处理指定滑块的选中状态
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndex inSection:0] animated:true scrollPosition:UICollectionViewScrollPositionNone];
    
    CGSize contentSize = _collectionView.contentSize;
    UICollectionViewCell *nextCell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndex inSection:0]];
    CGPoint origin = nextCell.frame.origin;
    CGSize cellSize = nextCell.frame.size;
    //指定滑块中心点距离
    CGFloat anotherMove = (origin.x + cellSize.width/2.0);
    CGFloat rightInset = (contentSize.width - (origin.x + cellSize.width/2.0));
    
    if (anotherMove >= SCREEN_WIDTH / 2.0 && rightInset > SCREEN_WIDTH / 2.0) {
        [UIView animateWithDuration:0.25 animations:^{
            _collectionView.contentOffset = CGPointMake(anotherMove - SCREEN_WIDTH/2.0, 0);
        } completion:^(BOOL finished) {
        }];
    }
    if (anotherMove < SCREEN_WIDTH / 2.0) {
        [UIView animateWithDuration:0.25 animations:^{
            _collectionView.contentOffset = CGPointZero;
        }];
    }
    if (rightInset <= SCREEN_WIDTH / 2.0) {
        [UIView animateWithDuration:0.25 animations:^{
            _collectionView.contentOffset = CGPointMake(contentSize.width - SCREEN_WIDTH, 0);
        }];
    }
}


@end
