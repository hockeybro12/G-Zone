//
//  GameOverLayer.m
//  GZone
//
//  Created by Nikhil Mehta on 10/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOverLayer.h"
@class GKGameCenterViewController;
#import <Foundation/Foundation.h>
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>


@implementation GameOverLayer {
    
    CCLabelTTF *scoreLabel;
    CCLabelTTF *gameOverLabel;
    CCLabelTTF *scorePointsLabel;
    
}
@synthesize highScoreIsSet;
@synthesize chartBoostFailed;
@synthesize stoppedRecording;


-(void)goBack {
    CCScene *mainMenu = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainMenu];
}

-(void)newGame {
    [Flurry logEvent:@"Restart_Game"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GameplayLayer"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)setMessage:(NSString *)message score:(NSInteger)score {
    
    gameOverLabel.string = message;
    scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)score];
    newScore = score;
    
    currentScore = [GZGameData sharedGameData].newScore;
    
   // GZGameData *gameData = [GZGameData sharedGameData];
  //  GZGameData *gameData;
    //[gameData giveScore:score];
  //  [gameData setMessage:@"Hey" scores:score];
    
    if (currentScore < score) {
        [GZGameData sharedGameData].newScore = score;
        [[GZGameData sharedGameData] save];

    }
    
    [self submitScore];

}

-(void)shareVideo {
    
    if (stoppedRecording == NO) {
        [Kamcord stopRecording];
        stoppedRecording = YES;
    }
    [Kamcord showView];
}

-(void)didLoadFromCCB {
    
    chartBoostFailed = NO;
    
    
    NSInteger currentAdvertisementValue = [GZGameData sharedGameData].newAdvertisementNumber;
    
    if (currentAdvertisementValue >= 4) {
        
        currentAdvertisementValue = 1;
        [GZGameData sharedGameData].newAdvertisementNumber = currentAdvertisementValue;
        [[GZGameData sharedGameData] save];
        
        [Chartboost startWithAppId:@"5489ed5b0d6025329ab81d1d"
                      appSignature:@"7a0175b1ab2c7b1ea6011b140796de6e2c59b1d2"
                          delegate:self];
        
        [Chartboost showInterstitial:CBLocationHomeScreen];
        
        
        if (chartBoostFailed == YES) {
            [RevMobAds startSessionWithAppID:@"54893a085e656e5c09f90cda"];
            [[RevMobAds session] showFullscreen];
            
            CCLOG(@"Called");
            
            
            
            if (self.fullScreen) {
                [self.fullScreen showAd];
            }
            
            self.fullScreen = [[RevMobAds session] fullscreen];
            self.fullScreen.delegate = self;
            [self.fullScreen loadAd];
            
        }

    } else {
        currentAdvertisementValue = currentAdvertisementValue + 1;
        [GZGameData sharedGameData].newAdvertisementNumber = currentAdvertisementValue;
        [[GZGameData sharedGameData] save];
    }
    
}

- (void)didFailToLoadInterstitial:(NSString *)location {
    NSLog(@"Failed to load");
    chartBoostFailed = YES;
    [self revMobStuff];
}

-(void)revMobStuff {
    if (chartBoostFailed == YES) {
        [RevMobAds startSessionWithAppID:@"54893a085e656e5c09f90cda"];
        [[RevMobAds session] showFullscreen];
        
        
        if (self.fullScreen) {
            [self.fullScreen showAd];
        }
        
        self.fullScreen = [[RevMobAds session] fullscreen];
        self.fullScreen.delegate = self;
        [self.fullScreen loadAd];
        
    }
}


-(void)submitScore {
    
  //  [[GameCenterManager sharedManager] saveAndReportScore:[[GameCenterManager sharedManager] highScoreForLeaderboard:@"HighScoreLeaderboard"] leaderboard:@"HighScoreLeaderboard" sortOrder:GameCenterSortOrderHighToLow];
    BOOL available = [[GameCenterManager sharedManager] checkGameCenterAvailability];

    if (available) {
        [[GameCenterManager sharedManager] saveAndReportScore:newScore leaderboard:@"High_Score_Leaderboard"  sortOrder:GameCenterSortOrderHighToLow];
    }
    

    
    /*
    BOOL available = [[GameCenterManager sharedManager] checkGameCenterAvailability];
    if (available) {
        GKGameCenterViewController *leaderboardViewController = [[GKGameCenterViewController alloc] init];
        leaderboardViewController.delegate = self;
        
        [[CCDirector sharedDirector] presentViewController:leaderboardViewController animated:YES completion:nil];
        
        leaderboardViewController.gameCenterDelegate = self;

      //  [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:myView];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Help" message:@"Game Center Not Available. Please Sign In." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
        [message show];
        
        

    }
     */
    

}



- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
    
    [gameCenterViewController dismissModalViewControllerAnimated:YES];
    
}

-(void)update:(CCTime)delta {
    
    if (maxStopRecordingTime >= 0) {
        maxStopRecordingTime = maxStopRecordingTime - (0.0166);
        
        if (maxStopRecordingTime <= 0) {
            [Kamcord stopRecording];
            stoppedRecording = YES;
        }
    }
    
}


-(id)init {
    if ((self = [super init])) {
        
        highScoreIsSet = NO;
        

        stoppedRecording = NO;
        maxStopRecordingTime = 0.2f;
        
        [[GZGameData sharedGameData] save];
        
    /*    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Help" message:@"%d", [[GZGameData sharedGameData].newScore] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [message show]; */
        
      //  CCLOG(@"%ld", (long)[GZGameData sharedGameData].newScore);
        
        //[[GameCenterManager sharedManager] saveAndReportScore:newScore leaderboard:@"High_Score_Leaderboard"  sortOrder:GameCenterSortOrderHighToLow];
        
        
        [[GameCenterManager sharedManager] setDelegate:self];

        BOOL available = [[GameCenterManager sharedManager] checkGameCenterAvailability];
        if (available) {
          //  [self.navigationController.navigationBar setValue:@"GameCenter Available" forKeyPath:@"prompt"];
            [[GameCenterManager sharedManager] saveAndReportScore:newScore leaderboard:@"High_Score_Leaderboard"  sortOrder:GameCenterSortOrderHighToLow];

        } else {
            //[self.navigationController.navigationBar setValue:@"GameCenter Unavailable" forKeyPath:@"prompt"];
        }
        
        GKLocalPlayer *player = [[GameCenterManager sharedManager] localPlayerData];
        if (player) {
            if ([player isUnderage] == NO) {
           //     actionBarLabel.title = [NSString stringWithFormat:@"%@ signed in.", player.displayName];
             //   playerName.text = player.displayName;
               // playerStatus.text = @"Player is not underage";
                [[GameCenterManager sharedManager] localPlayerPhoto:^(UIImage *playerPhoto) {
               //     playerPicture.image = playerPhoto;
                }];
            } else {
               // playerName.text = player.displayName;
               // playerStatus.text = @"Player is underage";
               // actionBarLabel.title = [NSString stringWithFormat:@"Underage player, %@, signed in.", player.displayName];
            }
        } else {
           // actionBarLabel.title = [NSString stringWithFormat:@"No GameCenter player found."];
        }
    }
    
    return self;
}


@end
