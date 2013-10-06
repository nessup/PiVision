//
//  PVEpisodeViewController.m
//  PiVision
//
//  Created by Dany on 10/6/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVEpisodeViewController.h"

#import "PVEpisode.h"

@interface PVEpisodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@end

@implementation PVEpisodeViewController

- (id)init
{
    self = [super initWithNibName:@"PVEpisodeViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViews {
    self.showLabel.text = self.title = self.episode.programName;
    self.titleLabel.text = self.episode.title;
    self.channelLabel.text = self.episode.channelName;
}

#pragma mark - Episode

- (void)setEpisode:(PVEpisode *)episode {
    _episode = episode;
    [self updateViews];
}

#pragma mark - Actions

- (IBAction)recordEpisode:(UIButton *)sender {
    [self toggleCheckForButton:sender checkedTitle:@"Will Record" uncheckedTitle:@"Record Episode"];
}

- (IBAction)recordAllEpisodes:(id)sender {
    [self toggleCheckForButton:sender checkedTitle:@"Will Record Season" uncheckedTitle:@"Record Season"];
}

- (void)toggleCheckForButton:(UIButton *)button checkedTitle:(NSString *)checkedTitle uncheckedTitle:(NSString *)uncheckedTitle {
    // This is dirty
    button.imageEdgeInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, 10.f);
    if ([button imageForState:UIControlStateNormal]) {
        [button setImage:nil forState:UIControlStateNormal];
        [button setTitle:uncheckedTitle forState:UIControlStateNormal];
    }
    else {
        button.imageView.alpha = 0.f;
        [button setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.15f delay:0.15F options:UIViewAnimationOptionCurveEaseInOut animations:^{
            button.imageView.alpha = 1.f;
        } completion:nil];
        [button setTitle:checkedTitle forState:UIControlStateNormal];
    }
}

@end
