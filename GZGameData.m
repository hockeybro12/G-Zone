//
//  GZGameData.m
//  GZone
//
//  Created by Nikhil Mehta on 11/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GZGameData.h"

@implementation GZGameData
@synthesize newScore;
@synthesize newMuteNumber;
static NSString* const SSGameDataHighScoreKey = @"highScore";
static NSString* const SSGameDataTotalDistanceKey = @"totalDistance";
static NSString* const SSGameDataAdvertisementNumber = @"advertisementNumber";
static NSString* const SSGameDataMuteNumber = @"muteNumber";


/*
 
 set high score label to whatever stored in GZGameData's highScore property
 _highScore.text = [NSString stringWithFormat:@"High: %li pt", [RWGameData sharedGameData].highScore];
 */
//-(void)giveScore:(NSInteger)score {
-(void)setMessage:(NSString *)message scores:(NSInteger)score {
    score = newScore;
 //   score = [GZGameData sharedGameData].newScore;
}
-(void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeDouble:newScore forKey:SSGameDataHighScoreKey];
    [encoder encodeDouble:newAdvertisementNumber forKey:SSGameDataAdvertisementNumber];
    [encoder encodeDouble:newMuteNumber forKey:SSGameDataMuteNumber];
    
}

-(instancetype)initWithCoder:(NSCoder *)decoder {
    
    self = [self init];
    if (self) {
      //  CCLOG(@"%ld", (long)newScore);
        newScore = [decoder decodeDoubleForKey:SSGameDataHighScoreKey];
        newAdvertisementNumber = [decoder decodeDoubleForKey:SSGameDataAdvertisementNumber];
        newMuteNumber = [decoder decodeDoubleForKey:SSGameDataMuteNumber];
      //  newDistance = [decoder decodeDoubleForKey:SSGameDataTotalDistanceKey];
    }
    return self;
}

+(NSString*)filePath {
    static NSString* filePath = nil;
    if (!filePath) {
        filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"gamedata"];
    }
    return filePath;
}

+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}

+(instancetype)loadInstance {
    NSData* decodedData = [NSData dataWithContentsOfFile:[GZGameData filePath]];
    if (decodedData) {
        GZGameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    
    return [[GZGameData alloc] init];
}

-(void)save {
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[GZGameData filePath] atomically:YES];
}


@end
