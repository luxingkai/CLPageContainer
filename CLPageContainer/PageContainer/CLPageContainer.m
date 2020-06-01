//
//  CLPageContainer.m
//  CLPageContainer
//
//  Created by tigerfly on 2020/5/30.
//  Copyright © 2020 tigerfly. All rights reserved.
//

#import "CLPageContainer.h"
#import "CLPageTitleView.h"

@interface CLPageContainer ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end
 
@implementation CLPageContainer {
    
    UICollectionView *_containerView;
    CLPageTitleView *_titleView;
    
    NSUInteger _number;//页码数
    UIViewController *_currentViewController;//控制器
    NSArray *_titles;
}

static NSString *const cellIdentifier = @"cellIdentifier";

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
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    _titleView = [[CLPageTitleView alloc] initWithFrame:CGRectMake(0, STATUSBAR + 44.0, SCREEN_WIDTH, 50)];
    [self addSubview:_titleView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR - 44.0 - 50.0);
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    _containerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44.0 + STATUSBAR + 50.0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR - 44.0 - 50.0) collectionViewLayout:flowLayout];
    _containerView.delegate = self;
    _containerView.dataSource = self;
    _containerView.backgroundColor = UIColor.whiteColor;
    _containerView.pagingEnabled = YES;
    _containerView.automaticallyAdjustsScrollIndicatorInsets = false;
    _containerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _containerView.showsHorizontalScrollIndicator = false;
    _containerView.showsVerticalScrollIndicator = false;
    _containerView.scrollEnabled = true;
    _containerView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self addSubview:_containerView];
    
    [_containerView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
}


#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _number;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:(arc4random()%256)/255.0 green:(arc4random()%256)/255.0 blue:(arc4random()%256)/255.0 alpha:1.0];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentViewController = [_dataSource pageContainer:self viewControllerForIndex:indexPath.row];
    [cell.contentView addSubview:_currentViewController.view];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentViewController = [_dataSource pageContainer:self viewControllerForIndex:indexPath.row];
    [_currentViewController.view removeFromSuperview];
}


#pragma mark -- Setter

- (void)setDataSource:(id<CLPageContainerViewDataSource>)dataSource {
    if (_dataSource == dataSource) return;
    _dataSource = dataSource;
    _number = [dataSource numberOfItemForPageContainer:self];
    _titles = [dataSource titleForPageContainer:self];
    _titleView.titles = _titles;
    [_containerView reloadData];
}

#pragma mark -- 处理滚动过程

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x <= 0.0) {
        scrollView.contentOffset = CGPointZero;
        return;
    }
    if (scrollView.contentOffset.x >= (_number - 1) * SCREEN_WIDTH) {
        scrollView.contentOffset = CGPointMake((_number - 1) * SCREEN_WIDTH, 0);
        return;
    }
    _titleView.pageContainerOffset = scrollView.contentOffset.x;
}

// 处理开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"开始拖拽");
}
//拖拽过程中手指离开，将要结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset  {
//    NSLog(@"将要结束拖拽");
}
//拖拽过程中手指离开，结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"结束拖拽");
}
//开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"开始减速");
}
//结束减速，停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"结束减速");
    
    _titleView.nextIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    
}
// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}








@end
