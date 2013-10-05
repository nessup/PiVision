//
//  PVSegmentedViewController.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVSegmentedViewController.h"

#import "PVSegmentedControl.h"

@interface PVSegmentedViewController ()
@property (nonatomic, strong, readwrite) PVSegmentedControl *segmentedControlView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;
@end

@implementation PVSegmentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.view addSubview:self.segmentedControlView];
    [self.view addSubview:self.containerView];
}

#pragma mark - Container view

- (UIView *)containerView {
    if (_containerView)
        return _containerView;
    
    _containerView = [UIView new];
    _containerView.frame = (CGRect) {
        0.f,
        CGRectGetMaxY(self.segmentedControlView.frame),
        self.view.frame.size.width,
        self.view.frame.size.height - PVSegmentedControlHeight
    };
    _containerView.backgroundColor = [UIColor greenColor];
    
    return _containerView;
}

#pragma mark - Segmented control

- (PVSegmentedControl *)segmentedControlView {
    if (_segmentedControlView)
        return _segmentedControlView;
    
    _segmentedControlView = [PVSegmentedControl new];
    _segmentedControlView.frame = (CGRect) {
        0.f,
        CGRectGetMaxY(self.navigationController.navigationBar.frame),
        self.view.frame.size.width,
        PVSegmentedControlHeight
    };
    [_segmentedControlView.segmentedControl addTarget:self action:@selector(selectedIndexDidChange) forControlEvents:UIControlEventValueChanged];
    
    return _segmentedControlView;
}

- (NSInteger)selectedIndex {
    return self.segmentedControlView.segmentedControl.selectedSegmentIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    self.segmentedControlView.segmentedControl.selectedSegmentIndex = selectedIndex;
    [self displayViewControllerAtIndex:selectedIndex];
}

#pragma mark - View controllers

- (void)setViewControllers:(NSArray *)controllers titles:(NSArray *)titles {
    [self.segmentedControlView setItems:titles];
    
    for (UIViewController *controller in self.childViewControllers) {
        [controller willMoveToParentViewController:nil];
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
    }
    
    self.viewControllers = controllers;
    self.selectedIndex = 0;
}

- (void)displayViewControllerAtIndex:(NSInteger)index {
    if (self.currentViewController) {
        UIViewController *fromViewController = self.currentViewController;
        [fromViewController willMoveToParentViewController:nil];
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
    }
    
    UIViewController *toViewController = self.viewControllers[index];
    [self addChildViewController:toViewController];
    [self.containerView addSubview:toViewController.view];
    toViewController.view.frame = self.containerView.bounds;
    [toViewController didMoveToParentViewController:self];
    
    self.currentViewController = toViewController;
}

- (void)selectedIndexDidChange {
    [self displayViewControllerAtIndex:self.selectedIndex];
}

@end
