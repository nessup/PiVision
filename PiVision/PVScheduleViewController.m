//
//  PVScheduleViewController.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVScheduleViewController.h"

#import "PVGridViewController.h"

@interface PVScheduleViewController ()
@property (nonatomic, strong) PVGridViewController *gridViewController;
@end

@implementation PVScheduleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Listings";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Listings" image:[UIImage imageNamed:@"schedule"] tag:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.gridViewController];
    [self.view addSubview:self.gridViewController.view];
    self.gridViewController.view.frame = self.view.bounds;
    [self.gridViewController didMoveToParentViewController:self];
}

#pragma mark - Grid view controller

- (PVGridViewController *)gridViewController {
    if (_gridViewController)
        return _gridViewController;
    
    _gridViewController = [PVGridViewController new];
    
    return _gridViewController;
}

@end
