//
//  PVAllShowsViewController.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVUpcomingEpisodesViewController.h"

#import "PVRoviManager.h"
#import "PVEpisode.h"
#import "PVChannel.h"
#import "PVEpisodeViewController.h"

@interface PVUpcomingEpisodesViewController ()
@property (nonatomic, strong) NSMutableArray *upcomingEpisodes;
@end

@implementation PVUpcomingEpisodesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Upcoming";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Upcoming" image:[UIImage imageNamed:@"upcoming"] tag:1];
       [[PVRoviManager sharedManager] addObserver:self forKeyPath:@"channels" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
    [[PVRoviManager sharedManager] removeObserver:self forKeyPath:@"channels"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"channels"]) {
        [self updateView];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (NSArray *)channels {
    return [[PVRoviManager sharedManager] channels];
}

#define KEY_SCHEDULED @"SCHEDULED"

- (void)updateView {
    NSMutableArray *allPrograms = [NSMutableArray new];
    for (PVChannel *programs in self.channels) {
        [allPrograms addObjectsFromArray:programs.episodes];
    }
    
    self.upcomingEpisodes = [NSMutableArray new];
    
    NSMutableArray *elements = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_SCHEDULED];
    for (NSDictionary *element in elements) {
        for (PVEpisode *episode in allPrograms) {
            if ([episode.id isEqualToString:element[@"identifier"]]) {
                [self.upcomingEpisodes addObject:episode];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITa`bleView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.upcomingEpisodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    PVEpisode *episode = self.upcomingEpisodes[indexPath.row];
    cell.textLabel.text = episode.programName;
    cell.imageView.image = [UIImage imageNamed:@"new"];
    
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [NSDateFormatter new];
        formatter.timeStyle = NSDateFormatterShortStyle;
    }
    NSString *startTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:episode.startTime]];
    NSString *endTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:episode.endTime]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PVEpisodeViewController *controller = [PVEpisodeViewController new];
    controller.episode = self.upcomingEpisodes[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
