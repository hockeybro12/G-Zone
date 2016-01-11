//
//  GameOverLayer.h
//  GZone
//
//  Created by Nikhil Mehta on 10/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "GameCenterManager.h"
#import "GCViewController.h"
#import <GameKit/GameKit.h>
#import "GZGameData.h"
#import "MainScene.h"
#import <iAd/iAd.h>
#import <RevMobAds/RevMobAds.h>
#import "Flurry.h"



@interface GameOverLayer : CCNode {
    
    float newScore;
    NSInteger currentScore;
    BOOL highScoreIsSet;
    
    BOOL chartBoostFailed;
    
    CCTime maxStopRecordingTime;
    
    BOOL stoppedRecording;
}

@property (nonatomic, assign) BOOL highScoreIsSet;
@property (nonatomic, strong) RevMobFullscreen *fullScreen;
@property (nonatomic, assign) BOOL chartBoostFailed;
@property (nonatomic, assign) BOOL stoppedRecording;



-(void)setMessage:(NSString *)message score:(NSInteger)score;

@end
