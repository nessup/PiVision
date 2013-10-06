//
//  PVRoviManager.m
//  PiVision
//
//  Created by Ari on 10/6/13.
//  Copyright (c) 2013 PiVision. All rights reserved.
//

#import "PVRoviManager.h"
#import "ASIHTTPRequest.h"
#import "PVChannel.h"
#import "PVEpisode.h"

static NSString * const kPVRoviTVListingsAPIKey = @"39tptunjf5yx7rh3fam4jfbz";

static NSString * const kPVRoviServiceID = @"20405";

static PVRoviManager *_sharedRoviManager;

@interface PVRoviManager () <ASIHTTPRequestDelegate>

@property (nonatomic, strong) NSArray *channels;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation PVRoviManager

+ (instancetype)sharedManager {
    if (!_sharedRoviManager) {
        _sharedRoviManager = [[self alloc] init];
        
        [_sharedRoviManager fetchTVListings];
    }
    
    return _sharedRoviManager;
}

- (void)fetchTVListings {
    NSDate *date = [NSDate date];
    // Include listings from the recent past.
    NSDate *lastHalfHour = [NSDate dateWithTimeIntervalSinceReferenceDate:[date timeIntervalSinceReferenceDate] - 30 * 60];
    NSString *startDate = [self.dateFormatter stringFromDate:lastHalfHour];
    
    NSDictionary *arguments = @{@"locale": @"en-US",
                                @"duration": @240,
                                @"inprogress": @"false",
                                @"oneairingpersourceid": @"false",
                                @"apikey": kPVRoviTVListingsAPIKey,
                                @"startdate": startDate};
    NSString *queryString = [self queryStringWithQueryDictionary:arguments];
    
    NSString *URLString = [NSString stringWithFormat:@"http://api.rovicorp.com/TVlistings/v9/listings/gridschedule/%@/info?%@", kPVRoviServiceID, queryString];
    NSURL *APIURL = [NSURL URLWithString:URLString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:APIURL];
    request.delegate = self;
    [request startAsynchronous];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    }
    
    return _dateFormatter;
}

#pragma mark - ASIHTTPRequestDelegate methods

- (void)requestFinished:(ASIHTTPRequest *)request {
    switch (request.responseStatusCode) {
        case 200: {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:&error];
            if (error || ![response isKindOfClass:[NSDictionary class]]) {
                request.error = error;
                [self requestFailed:request];
                return;
            }
            
            NSDictionary *gridSchedule = response[@"GridScheduleResult"];
            NSArray *gridChannels = gridSchedule[@"GridChannels"];
            
            NSMutableArray *channels = [NSMutableArray arrayWithCapacity:[gridChannels count]];
            
            for (NSDictionary *gridChannel in gridChannels) {
                PVChannel *channel = [[PVChannel alloc] init];
                channel.channelNumber = gridChannel[@"Channel"];
                channel.callLetters = gridChannel[@"CallLetters"];
                channel.displayName = gridChannel[@"DisplayName"];
                channel.longName = gridChannel[@"SourceLongName"];

                NSArray *airings = gridChannel[@"Airings"];
                
                NSMutableArray *episodes = [NSMutableArray arrayWithCapacity:[airings count]];
                
                for (NSDictionary *airing in airings) {
                    PVEpisode *episode = [[PVEpisode alloc] init];
                    episode.title = airing[@"EpisodeTitle"];
                    episode.programName = airing[@"Title"];
                    episode.channelNumber = channel.channelNumber;
                    episode.channel = channel;
                    
                    NSDate *date = [self.dateFormatter dateFromString:airing[@"AiringTime"]];
                    episode.startTime = [date timeIntervalSince1970];
                    
                    NSNumber *durationInMinutes = airing[@"Duration"];
                    episode.endTime = episode.startTime + ([durationInMinutes integerValue] * 60);
                    
                    [episodes addObject:episode];
                }
                
                channel.episodes = episodes;
                [channels addObject:channel];
            }
            
            self.channels = channels;
            
            break;
        }
            
        default:
            [self requestFailed:request];
            break;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"Fail! %@", request.error);
    // uh oh.
}

#pragma mark - NSDictionary utilities

- (NSString *)queryStringWithQueryDictionary:(NSDictionary *)queryDictionary {
    NSMutableString *queryString = [NSMutableString string];
    for (NSString *queryKey in [queryDictionary allKeys])
        [queryString appendFormat:@"&%@=%@", queryKey, [queryDictionary objectForKey:queryKey]];
    
    if ([queryString length] && [queryString characterAtIndex:0] == '&')
        [queryString deleteCharactersInRange:NSMakeRange(0, 1)];
    
    return [queryString copy];
}

@end
