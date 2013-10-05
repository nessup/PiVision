//
//  PVTabBarController.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVTabBarController.h"

#import "PVMyShowsViewController.h"
#import "PVAllShowsViewController.h"

@implementation PVTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewControllers:@[
                               [[UINavigationController alloc] initWithRootViewController:[PVMyShowsViewController new]],
                               [[UINavigationController alloc] initWithRootViewController:[PVAllShowsViewController new]]
                               ]];
    
}

@end
