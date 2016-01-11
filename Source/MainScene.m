//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import <FacebookSDK/FacebookSDK.h>


@implementation MainScene {
    CCLabelTTF *volumeControlString;
    CCButton *muteButtonPicture;
    CCSprite *muteImage;
}
@synthesize chartBoostFailed;
@synthesize soundIsActive;
@synthesize alreadyCalledUpdate;
@synthesize alreadyCalledSecondUpdate;

-(void)play {
    
    [[OALSimpleAudio sharedInstance] stopBg];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GameplayLayer"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)muteButton {
    if (muteButtonValue == 1) {
        soundIsActive = NO;
        muteButtonValue = 2;
        [GZGameData sharedGameData].newMuteNumber = muteButtonValue;
        [[GZGameData sharedGameData] save];
        
        [volumeControlString setString:@"Play"];
        NSString *boxNm = [NSString stringWithFormat:@"GroundPNGFiles/Mute.png"];
        CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [muteImage setSpriteFrame:[cache spriteFrameByName:boxNm]];
    } else if (muteButtonValue == 2) {
        soundIsActive = YES;
        muteButtonValue = 1;
        [GZGameData sharedGameData].newMuteNumber = muteButtonValue;
        [[GZGameData sharedGameData] save];
        
        [volumeControlString setString:@"Mute"];
        NSString *boxNm = [NSString stringWithFormat:@"GroundPNGFiles/Unmute.png"];
        CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [muteImage setSpriteFrame:[cache spriteFrameByName:boxNm]];
    }
}

-(void)goTutorial {
    
    [[OALSimpleAudio sharedInstance] stopBg];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"TutorialNode"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)update:(CCTime)delta {
    if (soundIsActive == NO && (alreadyCalledUpdate == NO)) {
        [[OALSimpleAudio sharedInstance] stopBg];
        alreadyCalledUpdate = YES;
        alreadyCalledSecondUpdate = NO;
    }
    
    if (soundIsActive == YES && (alreadyCalledSecondUpdate == NO)) {
        [[OALSimpleAudio sharedInstance] playBg:@"TitleTheme.mp3" loop:YES];
        alreadyCalledSecondUpdate = YES;
        alreadyCalledUpdate = NO;
    }
}

- (BOOL)shouldRequestInterstitialsInFirstSession {
    return NO;
}
/*
+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 3;
    [iRate sharedInstance].usesUntilPrompt = 3;
    
    
}
 */

- (void)didLoadFromCCB {
    
   /* if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults]
                                objectForKey:@"aValue"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"aValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [[OALSimpleAudio sharedInstance] stopBg];
        CCScene *gameplayScene = [CCBReader loadAsScene:@"TutorialNode"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Help" message:@"This is the tutorial for this game. You can access it any time by clicking the tutorial button from the home screen. Reading the tutorial is VITAL to your success in this game. There are a total of 4 screens and you can navigate through them by swiping right or left." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        
        return;
    }
    */
    
    size = [[CCDirector sharedDirector] viewSize];

    
    chartBoostFailed = NO;
   // [iAdHelper sharedHelper];
   // [iAdHelper setBannerPosition:BOTTOM];
   /*
    interstitial = [[ADInterstitialAd alloc] init];
    interstitial.delegate = self;
    CCLOG(@"Hey");
    if (interstitial.loaded)
    {
        CCLOG(@"Called");
        [interstitial presentFromViewController:self];
    }
    */
    
    [Chartboost startWithAppId:@"5489ed5b0d6025329ab81d1d"
                  appSignature:@"7a0175b1ab2c7b1ea6011b140796de6e2c59b1d2"
                      delegate:self];
    
    [Chartboost showInterstitial:CBLocationHomeScreen];
    
    
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
    
    if (soundIsActive == YES) {
        [[OALSimpleAudio sharedInstance] playBg:@"TitleTheme.mp3" loop:YES];
        alreadyCalledUpdate = NO;
        alreadyCalledSecondUpdate = YES;
    } else {
        alreadyCalledSecondUpdate = NO;
        alreadyCalledUpdate = YES;
    }
    
    //EverPlay integration
   // [window_ addSubview:navController_.view];
    
    // Start recording video

    /*
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.center = CGPointMake(size.width /2, size.height - 40);
    [[[CCDirector sharedDirector] view] addSubview:loginView];
     */
     

    
    
}

-(void)revMobStuff {
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
}

- (void)didFailToLoadInterstitial:(NSString *)location {
    NSLog(@"Failed to load");
    chartBoostFailed = YES;
    
    [self revMobStuff];
}

-(void)goTwitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/mehtaiphoneapps"]];

}

-(void)goFaceBook {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/pages/Mehtaiphoneapps/889176784448927?ref=aymt_homepage_panel"]];
}


- (BOOL)shouldRequestInterstitial:(NSString *)location {
    NSLog(@"Should request");
    return YES;
}


/*
-(IBAction)showFs:(id)sender {
    if (self.fullScreen) {
        [self.fullScreen showAd];
    }
}

-(void)loadFs:(id)sender {
    self.fullScreen = [[RevMobAds session] fullscreen];
    self.fullScreen.delegate = self;
    [self.fullScreen loadAd];
    
}
 */

-(void)revmobAdDidFailWithError:(NSError *)error {
    NSLog(@"GZone Ad failed %@", error);
}

-(void)revmobAdDidReceive {
    NSLog(@"Gzone Ad loaded");
}

-(void)revmobUserClosedTheAd {
    NSLog(@"Gzone Ad Close");
}

-(void)showLeaderboards {
    
    BOOL available = [[GameCenterManager sharedManager] checkGameCenterAvailability];
    if (available) {
        GKGameCenterViewController *leaderboardViewController = [[GKGameCenterViewController alloc] init];
        leaderboardViewController.delegate = self;
        
        [[CCDirector sharedDirector] presentViewController:leaderboardViewController animated:YES completion:nil];
        
        leaderboardViewController.gameCenterDelegate = self;
        
        //  [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:myView];
    } else {
        #if __CC_PLATFORM_IOS
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Help" message:@"Game Center Not Available. Please Sign In." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [message show];
        
        #endif
        
        #if __CC_PLATFORM_ANDROID    // __CC_PLATFORM_ANDROID = 1 when building for ANDROID
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AndroidAlertDialogBuilder *builder = [[AndroidAlertDialogBuilder alloc] initWithContext:self theme:AndroidAlertDialogThemeHoloDark];
            
            [builder setTitleByCharSequence:@"Game Center Not Available. Please Sign in."];
            
            [builder setPositiveButton:@"OK" onClickListener:nil];
            
            //[builder setNegativeButton:@"No" onClickListener:nil];
            
            [builder show];
            
        });
        
        #endif
        
        
        
    }

    
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)shareHighScore {
    NSInteger highScoreFromGameData = [GZGameData sharedGameData].newScore;
    
    NSString *shareString = [NSString stringWithFormat:@"Check out my High Score of %ld in G-Zone! Available on the app store now! https://itunes.apple.com/us/app/g-zone/id932686907?mt=8", (long)highScoreFromGameData];
    
    NSArray *itemsToShare = @[shareString];
    
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
   // activity.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypePrint];
    [[CCDirector sharedDirector] presentViewController:activity animated:YES completion:nil];
    
    
    
}

-(id)init {
    if ((self = [super init])) {
        
        NSInteger highScoreFromGameData = [GZGameData sharedGameData].newScore;
        NSString *newValue = [NSString stringWithFormat:@"High Score: %ld", (long)highScoreFromGameData];
        
        CCLabelTTF *dist = [CCLabelTTF labelWithString:@"Score:" fontName:@"Helvetica" fontSize:24];
    //    CCLabelTTF *dist = [CCLabelTTF labelWithString : @"Hello" fontName:@"Arial Rounded MT Bold" fontSize:8];
        [dist setAnchorPoint:ccp(0, 0)];
        [dist setPosition:ccp(5,    0)];
        dist.color = [CCColor whiteColor];
        [self addChild:dist z:500];
        
        [dist setString:newValue];
        
        muteButtonValue = [GZGameData sharedGameData].newMuteNumber;
        
        if (muteButtonValue == 0) {
            muteButtonValue = 1;
            soundIsActive = YES;
        }
        
        if (muteButtonValue == 1) {
            soundIsActive = YES;
        }
        
        if (muteButtonValue == 2) {
            soundIsActive = NO;
        }
        
        
        
        [[GameCenterManager sharedManager] setDelegate:self];
        
        BOOL available = [[GameCenterManager sharedManager] checkGameCenterAvailability];
        if (available) {
            //  [self.navigationController.navigationBar setValue:@"GameCenter Available" forKeyPath:@"prompt"];
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
