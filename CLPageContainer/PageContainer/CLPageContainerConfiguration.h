//
//  CLPageContainerConfiguration.h
//  CLPageContainer
//
//  Created by tigerfly on 2020/5/30.
//  Copyright © 2020 tigerfly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CLPageContainerConfiguration : NSObject

/// 默认字体颜色
@property (nonatomic, strong) UIColor *defaultTitleColor;
/// 选择字体颜色
@property (nonatomic, strong) UIColor *selectedTitleColor;
/// 默认字体大小
@property (nonatomic, strong) UIFont *defaultFont;
/// 选中字体大小
@property (nonatomic, strong) UIFont *selectedFont;
/// 分割线颜色
@property (nonatomic, strong) UIColor *shadowColor;
/// 选择项大小
@property (nonatomic, assign) CGFloat itemWidth;
/// 选择项大小
@property (nonatomic, assign) CGFloat itemSpace;



@end

NS_ASSUME_NONNULL_END
