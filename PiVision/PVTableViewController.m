//
//  PVTableViewController.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVTableViewController.h"

@interface PVTableViewController ()
@end

@implementation PVTableViewController

- (void)viewDidLoad {
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view

- (UITableView *)tableView {
    if (_tableView)
        return _tableView;
    
    _tableView = [UITableView new];
    _tableView.frame = (CGRect) {
        CGPointZero,
        self.view.frame.size
    };
    
    return _tableView;
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @throw [NSException exceptionWithName:@"Unimplemented method" reason:@"Must be overridden by subclass" userInfo:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:@"Unimplemented method" reason:@"Must be overridden by subclass" userInfo:nil];
}

@end
