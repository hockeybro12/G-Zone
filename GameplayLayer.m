//
//  GameplayLayer.m
//  GZone
//
//  Created by Nikhil Mehta on 10/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameplayLayer.h"
#import "MainScene.h"
#import <AVFoundation/AVFoundation.h>
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>


@implementation GameplayLayer
@synthesize isGameOver;
@synthesize stopUpdatingGameOver;
@synthesize stateChanged;
@synthesize alreadyFinishedGameOver;
@synthesize soundIsActive;
@synthesize alreadyCalledUpdate;
@synthesize alreadyCalledSecondUpdate;



-(id)init {
    if (self = [super init]) {
        
        isGameOver = NO;
        
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
        
        radiusSpeed = 110;
        
        timeToRotate = 5.0f;
        
        stateChanged = NO;
                
        self.userInteractionEnabled = YES;
        
        gameHasBegan = YES;
        
        alreadyFinishedGameOver = NO;
        
        moveInOutSpeed = 10.f;
        
        scoreSpeed = 2.0f;
        distanceTravelled = 0.f;
        
        stopUpdatingGameOver = NO;
        
        
        [[CCDirector sharedDirector] setDisplayStats:NO];

        size = [[CCDirector sharedDirector] viewSize];
        
        obstacleSpritesCreated = [[NSMutableArray alloc] init];
        obstacleSpritesDestroyed = [[NSMutableArray alloc] init];
        
        angle = 0.f;
        
        //add hud layer
        hudLayer = [[GZHUDLayer alloc] init];
        [self addChild:hudLayer z:50];
        
        [self addPlanetAtPos:ccp(size.width/2, size.height/2)];
        
        CGPoint planetPos = planet.position;
        
        //needs to be at 85 to be touching earth
        [self addSatelliteAtPos:ccpAdd(ccp(110, 0), planetPos)];
        
        
        
    }
    
    return self;
}


-(void)didLoadFromCCB {
    
    [Kamcord startRecording];
    
    if (soundIsActive == YES) {
        [[OALSimpleAudio sharedInstance] playBg:@"Gameplay music.mp3" loop:YES];
        alreadyCalledUpdate = NO;
        alreadyCalledSecondUpdate = YES;
    } else {
        alreadyCalledSecondUpdate = NO;
        alreadyCalledUpdate = YES;
    }
}

-(void)update:(CCTime)delta {
    
    if (isGameOver) {
        return;
    }
    
    if (soundIsActive == NO && (alreadyCalledUpdate == NO)) {
        [[OALSimpleAudio sharedInstance] stopBg];
        alreadyCalledUpdate = YES;
        alreadyCalledSecondUpdate = NO;
    }
    
    if (soundIsActive == YES && (alreadyCalledSecondUpdate == NO)) {
        [[OALSimpleAudio sharedInstance] playBg:@"Gameplay music.mp3" loop:YES];
        alreadyCalledSecondUpdate = YES;
        alreadyCalledUpdate = NO;
    }
    
    [self updateSatellite];
    
    [self updateTiles];
  //  CCLOG(@"%u", satellite.state);
}

-(void)updateSatellite {
    
    CGPoint satellitePos = satellite.position;

    
    if (timeToRotate > -4) {
        timeToRotate = timeToRotate - (0.0166);
        if (timeToRotate < 0 && (stateChanged == NO) && (alreadyFinishedGameOver == NO)) {
            [satellite stateChangeTo:kSatelliteMovingOut];
            stateChanged = YES;
        }
        
    }
    
    if (satellite.state == kSatelliteConstant) {
        float x = (size.width/2) + cosf(angle) * 110;
        float y = (size.height/2) + sinf(angle) * 110;
        
        satellitePos = ccp(x, y);
        
        satellite.position = satellitePos;
        
        angle = angle + 0.025f;
    }
    
    if (satellite.state == kSatelliteMovingIn) {
        float x = (size.width/2) + cosf(angle) * (radiusSpeed);
        float y = (size.height/2) + sinf(angle) * (radiusSpeed);
        
        satellitePos = ccp(x, y);
        
        satellite.position = satellitePos;
        
        angle = angle + 0.025f;
        radiusSpeed = radiusSpeed - 1;
    }
    
    if (satellite.state == kSatelliteMovingOut) {
        float x = (size.width/2) + cosf(angle) * (radiusSpeed);
        float y = (size.height/2) + sinf(angle) * (radiusSpeed);
        
        satellitePos = ccp(x, y);
        
        satellite.position = satellitePos;
        
        angle = angle + 0.025f;
        
        radiusSpeed = radiusSpeed + 1;
    }

    //Update HUD
    if (isGameOver == NO) {
        distanceTravelled = distanceTravelled + ((scoreSpeed / 100) * 10);
        [hudLayer changeDistanceTo:distanceTravelled];
    }
    
    for (ObstacleSprite *aTile in obstacleSpritesCreated) {
        if (CGRectIntersectsRect(satellite.collisionSensor, aTile.collisionSensor)) {
            if (stopUpdatingGameOver == NO) {
                /*
                AVAudioPlayer *audioPlayer;
                NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"mp3"];
                NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
                [audioPlayer play]; */
                [self playSound];
                [self gameOver];
            }
           
        }
    }
    satellite.position = satellitePos;
    
    if ((satellite.position.x > (size.width + 50)) || (satellite.position.y > (size.height + 50)) || (satellite.position.x < -50) || (satellite.position.y < -50)) {
        if (stopUpdatingGameOver == NO) {
            CCLOG(@"x + %f, y + %f", satellitePos.x, satellitePos.y);
            [self gameOver];
        }
    }
    
}

-(void)playSound {
    /*
    AVAudioPlayer *audioPlayer;
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"mp3"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    [audioPlayer play];
     
     */
    
    if (soundIsActive == YES) {
        [[OALSimpleAudio sharedInstance] playEffect:@"Explosion.mp3"];
    }
    

}

-(void)addPlanetAtPos:(CGPoint)pos {
    
    planet = [PlanetSprite spriteWithImageNamed:@"GroundPNGFiles/Planet.png"];
    [planet setPosition:pos];
    //[planet setPf:self];
    [planet setScale:0.4];
    [self addChild:planet z:5];
    
  //  [hero loadAnimations];
    
}

-(void)addSatelliteAtPos:(CGPoint)pos {
    
    satellite = [SatelliteSprite spriteWithImageNamed:@"GroundPNGFiles/Moon.png"];
    [satellite setPosition:pos];
    //[planet setPf:self];
    [satellite setScale:0.15];
    [satellite stateChangeTo:kSatelliteConstant];
    [self addChild:satellite z:5];
    
    //  [hero loadAnimations];
    
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
    if (alreadyFinishedGameOver == NO) {
        alreadyFinishedGameOver = YES;
    }
    
    if (satellite.state == kSatelliteConstant) {

        [satellite stateChangeTo:kSatelliteMovingOut];
        return;
    }
    
    if (satellite.state == kSatelliteMovingOut) {
        
        [satellite stateChangeTo:kSatelliteMovingIn];
        
        return;
    }
    
    if (satellite.state == kSatelliteMovingIn) {
        
        [satellite stateChangeTo:kSatelliteMovingOut];
        return;
    }
    
}

-(void)addObstacle {
    
    maxTileX = maxTileX + 200;
    NSInteger currentTile = 8;
    NSInteger randomImage = ( arc4random() % 3) + 1;
    NSString *tileNm;
    if (randomImage == 1) {
        tileNm = [NSString stringWithFormat:@"GroundPNGFiles/Asteroid.png"];
    } else {
        tileNm = [NSString stringWithFormat:@"GroundPNGFiles/Comet1.png"];
    }
    
    
    ObstacleSprite *tile = [ObstacleSprite spriteWithImageNamed:tileNm];
    
    
    //Tile position
    [tile setAnchorPoint:ccp(0.5, 0)];
    
    NSInteger tileSize = (arc4random() % 300) + 10;
    
    float newY = tileSize;
    
    [tile setPosition:ccp(maxTileX, newY)];
    
    [tile setScale:0.2];
    [tile setRotation:-50];
    
    [obstacleSpritesCreated addObject:tile];
    [self addChild:tile z:currentTile];
}


-(void)addHardObstacle {
    
    maxTileX = maxTileX + 200;
    NSInteger currentTile = 8;
    
    NSInteger randomImage = ( arc4random() % 3) + 1;
    NSString *tileNm;
    if (randomImage == 1) {
        tileNm = [NSString stringWithFormat:@"GroundPNGFiles/Asteroid.png"];
    } else {
        tileNm = [NSString stringWithFormat:@"GroundPNGFiles/Comet1.png"];
    }
    
    
    ObstacleSprite *tile = [ObstacleSprite spriteWithImageNamed:tileNm];
    
    
    //Tile position
    [tile setAnchorPoint:ccp(0.5, 0)];
    
    NSInteger tileSize = (arc4random() % 300) + 10;
    
    float newY = tileSize;
    
    [tile setPosition:ccp(maxTileX, newY)];
    
    [tile setScale:0.25];
    [tile setRotation:-50];
    
    [obstacleSpritesCreated addObject:tile];
    [self addChild:tile z:currentTile];
}

-(void)updateTiles {
    
    for (CCSprite *aTile in obstacleSpritesCreated) {
        //change x position of tile so it moves to the left
        [aTile setPosition:ccpAdd(aTile.position, ccp(-scoreSpeed, 0))];
    }
    if (gameHasBegan) {
        maxTileX = 500;
        gameHasBegan = NO;
    } else {
        maxTileX = 0;
    }

    for (ObstacleSprite *aTile in obstacleSpritesCreated) {
        //check for tiles scrolled away
        if (aTile.position.x < -100) {
            [obstacleSpritesDestroyed addObject:aTile];
            [aTile removeFromParentAndCleanup:YES];
        }
        
        //check for rightmost tiles
        if (aTile.position.x > maxTileX) {
            //maxTileX should always hold position of right most tile
            maxTileX = aTile.position.x;
        }
    }
    
    [obstacleSpritesCreated removeObjectsInArray:obstacleSpritesDestroyed];
    [obstacleSpritesDestroyed removeAllObjects];
    
    if (distanceTravelled < 500) {
        if (maxTileX < (size.width * 1.1)) {
            [self addObstacle];
        }
    } else if (distanceTravelled >= 500 && (distanceTravelled < 1000)) {
        if (maxTileX < (size.width * 1.1)) {
            [self addObstacle];
            [self addObstacle];
        }
    } else {
        if (maxTileX < (size.width * 1.1)) {
            [self addHardObstacle];
            [self addHardObstacle];
        }
    }
    
    if (scoreSpeed < 7.00) {
        scoreSpeed = scoreSpeed + 0.001;
    }
    


}

-(void)gameOver {
    
    self.userInteractionEnabled = NO;
    
    stopUpdatingGameOver = YES;
    
    // [[CCDirector sharedDirector] pause];
    
//    preventTouches = YES;
    isGameOver = YES;
//    isScrolling = NO;
    
    /* CCLabelTTF *gameOver = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Verdana" fontSize:30];
     [gameOver setPosition:ccp(size.width/2, size.height/2)];
     [self addChild:gameOver z:5];
     
     CCActionDelay *delay = [CCActionDelay actionWithDuration:2.0f];
     CCActionCallBlock *resume = [CCActionCallBlock actionWithBlock:^{
     preventTouches = NO;
     }];
     
     [self runAction:[CCActionSequence actions:delay, resume, nil]];
     */
    GameOverLayer *gameOverPopUp = (GameOverLayer *)[CCBReader load:@"GameEnd"];
    gameOverPopUp.positionType = CCPositionTypeNormalized;
    //gameOverPopUp.anchorPoint = ccp(0.5, 0.5); size.height - 320, size.width - 480
    if ((size.width == 480) && (size.height == 320)) {
        gameOverPopUp.position = ccp(size.height - 320, size.width - 480);
        gameOverPopUp.anchorPoint = ccp(0, 0);
    } else {
        gameOverPopUp.position = ccp(0.5, 0.5);
    }
    gameOverPopUp.zOrder = INT_MAX;
    [gameOverPopUp setMessage:@"Score" score:distanceTravelled];
    [self addChild:gameOverPopUp];
}




@end
