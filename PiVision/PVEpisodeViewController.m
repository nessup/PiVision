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
    self.channelLabel.text = self.episode.channelNumber;
    
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [NSDateFormatter new];
        formatter.timeStyle = NSDateFormatterShortStyle;
    }
    NSString *startTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.episode.startTime]];
    NSString *endTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.episode.endTime]];
    self.durationLabel.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
}

#pragma mark - Episode

- (void)setEpisode:(PVEpisode *)episode {
    _episode = episode;
    [self updateViews];
}

#pragma mark - Actions

- (IBAction)recordEpisode:(UIButton *)sender {
    BOOL checked = [self toggleCheckForButton:sender checkedTitle:@"Will Record" uncheckedTitle:@"Record Episode"];
    [self manageEpisodeID:self.episode.id channelNumber:self.episode.channelNumber remove:!checked];
}

- (IBAction)recordAllEpisodes:(id)sender {
    [self toggleCheckForButton:sender checkedTitle:@"Will Record Season" uncheckedTitle:@"Record Season"];
}

#define KEY_SCHEDULED @"SCHEDULED"

- (void)manageEpisodeID:(NSString *)identifier channelNumber:(NSString *)channelNumber remove:(BOOL)remove {
    NSDictionary *dict = @{
                           @"identifier": identifier,
                           @"channelNumber": channelNumber
                           };
    NSMutableArray *elements = [[[NSUserDefaults standardUserDefaults] valueForKey:KEY_SCHEDULED] mutableCopy];
    if (!elements) {
        elements = [NSMutableArray new];
    }
    if (remove) {
        for (NSDictionary *element in elements) {
            if ([element[@"identifier"] isEqualToString:identifier] && [element[@"channelNumber"] isEqualToString:channelNumber]) {
                [elements removeObject:element];
                break;
            }
        }
    }
    else {
        [elements addObject:dict];
    }
    [[NSUserDefaults standardUserDefaults] setValue:elements forKey:KEY_SCHEDULED];
}

- (BOOL)toggleCheckForButton:(UIButton *)button checkedTitle:(NSString *)checkedTitle uncheckedTitle:(NSString *)uncheckedTitle {
    // This is dirty
    button.imageEdgeInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, 10.f);
    if ([button imageForState:UIControlStateNormal]) {
        [button setImage:nil forState:UIControlStateNormal];
        [button setTitle:uncheckedTitle forState:UIControlStateNormal];
        return false;
    }
    else {
        button.imageView.alpha = 0.f;
        [button setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.15f delay:0.15F options:UIViewAnimationOptionCurveEaseInOut animations:^{
            button.imageView.alpha = 1.f;
        } completion:nil];
        [button setTitle:checkedTitle forState:UIControlStateNormal];
        return true;
    }
}

@end
