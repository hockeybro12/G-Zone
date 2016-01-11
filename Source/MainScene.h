//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "GameCenterManager.h"
#import "GCViewController.h"
#import "TutorialLayer.h"
#import <GameKit/GameKit.h>
#import "GZGameData.h"
#import <iAd/iAd.h>
#import <RevMobAds/RevMobAds.h>
#import "GZGameData.h"
#import "iRate.h"





@interface MainScene : CCNode <RevMobAdsDelegate, UIApplicationDelegate, CCDirectorDelegate> {
    
    ADInterstitialAd *interstitial;
    
    BOOL chartBoostFailed;
    
    BOOL soundIsActive;
    
    NSInteger muteButtonValue;
    
    BOOL alreadyCalledUpdate;
    BOOL alreadyCalledSecondUpdate;
    
    CGSize size;

}

@property (nonatomic, strong) RevMobFullscreen *fullScreen;
@property (nonatomic, assign) BOOL chartBoostFailed;
@property (nonatomic, assign) BOOL soundIsActive;
@property (nonatomic, assign) BOOL alreadyCalledUpdate;
@property (nonatomic, assign) BOOL alreadyCalledSecondUpdate;

//-(IBAction)showFs:(id)sender;
//-(IBAction)loadFs:(id)sender;

@end
