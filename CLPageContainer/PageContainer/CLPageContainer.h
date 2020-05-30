//
//  CLPageContainer.h
//  CLPageContainer
//
//  Created by tigerfly on 2020/5/30.
//  Copyright © 2020 tigerfly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CLPageContainer;
@protocol CLPageContainerViewDataSource <NSObject>

@optional
- (NSInteger)numberOfItemForPageContainer:(CLPageContainer *)container;
- (UIViewController *)pageContainer:(CLPageContainer *)container viewControllerForIndex:(NSUInteger)index;
- (NSArray *)titleForPageContainer:(CLPageContainer *)container;
 
@end

@interface CLPageContainer : UIView

@property (nonatomic, weak)id<CLPageContainerViewDataSource>dataSource;

@property (nonatomic, weak) UIViewController *superViewController;
 
@end

NS_ASSUME_NONNULL_END
