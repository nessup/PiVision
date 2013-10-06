//
//  PVMyShowsViewController.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVMyEpisodesViewController.h"

#import "PVRecentEpisodesViewController.h"

@interface PVMyEpisodesViewController ()
@end

@implementation PVMyEpisodesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"My Episodes";
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewControllers:@[
                               [PVRecentEpisodesViewController new],
                               [UIViewController new]
                               ]
                      titles:@[
                               @"Recent Shows",
                               @"All Shows"
                               ]];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end
