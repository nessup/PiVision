//
//  PVTabBarController.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVTabBarController.h"

#import "PVScheduleViewController.h"
#import "PVMyEpisodesViewController.h"
#import "PVUpcomingEpisodesViewController.h"

@implementation PVTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewControllers:@[
                              [[UINavigationController alloc] initWithRootViewController:[PVScheduleViewController new]],
                              [[UINavigationController alloc] initWithRootViewController:[PVUpcomingEpisodesViewController new]],
                               [[UINavigationController alloc] initWithRootViewController:[PVMyEpisodesViewController new]]
                               ]];
}

@end
