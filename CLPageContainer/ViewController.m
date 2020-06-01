//
//  ViewController.m
//  CLPageContainer
//
//  Created by tigerfly on 2020/5/30.
//  Copyright © 2020 tigerfly. All rights reserved.
//

#import "ViewController.h"
#import "CLPageContainer.h"
#import "DemoViewController.h"

@interface ViewController ()<CLPageContainerViewDataSource>

@end

@implementation ViewController {
    
    NSArray *_viewControllers;
    NSArray *_titles;
}

- (void)loadView {
    [super loadView];
    
    _titles = @[@"关注",@"推荐",@"抗疫",@"在家上课",@"小视频",@"热点",@"合肥",@"小说",@"视频",@"科技"];
    _viewControllers = @[[DemoViewController new],
                         [DemoViewController new],
                         [DemoViewController new],
                         [DemoViewController new],
                         [DemoViewController new],
                         [DemoViewController new],
                         [DemoViewController new],
                         [DemoViewController new],
                         [DemoViewController new],
                         [DemoViewController new]];
    
    CLPageContainer *pageContainer = [[CLPageContainer alloc] initWithFrame:[UIScreen mainScreen].bounds];
    pageContainer.superViewController = self;
    pageContainer.dataSource = self;
    self.view = pageContainer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


#pragma mark -- CLPageContainerViewDataSource

- (NSInteger)numberOfItemForPageContainer:(CLPageContainer *)container {
    return _viewControllers.count;
}

- (UIViewController *)pageContainer:(CLPageContainer *)container viewControllerForIndex:(NSUInteger)index {
    return _viewControllers[index];
}

- (NSArray *)titleForPageContainer:(CLPageContainer *)container {
    return _titles;
}




@end
