//
//  PVRecentShowsViewController.m
//  PiVision
//
//  Created by Dany on 10/5/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVRecentEpisodesViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "PVEpisodeViewController.h"
#import "PVEpisode.h"

@implementation PVRecentEpisodesViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"Test Recording";
    cell.detailTextLabel.text = @"#1";
    //cell.imageView.image = [UIImage imageNamed:@"new"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSURL *contentURL = [[NSBundle mainBundle] URLForResource:@"soup700" withExtension:@"mp4"];
    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:contentURL];
    [self.navigationController presentViewController:moviePlayer animated:YES completion:nil];
    
    /*PVEpisodeViewController *controller = [PVEpisodeViewController new];
    controller.episode = [PVEpisode generateTestEpisode];
    [self.navigationController pushViewController:controller animated:YES];*/
}

@end
