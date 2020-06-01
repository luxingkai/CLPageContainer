//
//  CLPageTitleView.h
//  CLPageContainer
//
//  Created by tigerfly on 2020/5/30.
//  Copyright © 2020 tigerfly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLPageTitleCell : UICollectionViewCell

@property (nonatomic, strong) NSString *title;

@end

@interface CLPageTitleView : UIView

@property (nonatomic, strong) NSArray *titles;
/// 分页器偏移量
@property (nonatomic, assign) CGFloat pageContainerOffset;
/// 选中项
@property (nonatomic, assign) NSUInteger nextIndex;

@end

NS_ASSUME_NONNULL_END
