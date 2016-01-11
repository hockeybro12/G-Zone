/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"

#import "AppDelegate.h"
#import "CCBuilderReader.h"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import <FacebookSDK/FacebookSDK.h>




@implementation AppController


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[RevMobAds startSessionWithAppID:@"54893a085e656e5c09f90cda"];
    
    //[Chartboost startWithAppId:@"5489ed5b0d6025329ab81d1d"
      //            appSignature:@"7a0175b1ab2c7b1ea6011b140796de6e2c59b1d2"
        //              delegate:self];
    
    
   // window_.rootViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
   // window_.rootViewController.view = [[CCDirector sharedDirector] view];
    
    [Flurry startSession:@"P7782K36HSH5C82B7BJS"];

    //kamcord
    [Kamcord setDeveloperKey:@"GpIjnYiwtvg0Mc0GnOtkvi9lTcloEQ5MPYLspLaWETK" developerSecret:@"UjbTiAKum8MBAqfTZ1YmHawXJrkTCQl1TYHXMGGRW2F" appName:@"" parentViewController:[CCDirector sharedDirector]];
    
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];
    

    
    [self setupCocos2dWithOptions:cocos2dSetup];
    
    [FBAppEvents activateApp];

    
    return YES;
}



- (CCScene*) startScene
{
    
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults]
                                objectForKey:@"aValue"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"aValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        /*
        [[OALSimpleAudio sharedInstance] stopBg];
        CCScene *gameplayScene = [CCBReader loadAsScene:@"TutorialNode"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
        */
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Help" message:@"This is the tutorial for this game. You can access it any time by clicking the tutorial button from the home screen. Reading the tutorial is VITAL to your success in this game. There are a total of 4 screens and you can navigate through them by swiping right or left. Close the tutorial with the button on the top right." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        
        return [CCBReader loadAsScene:@"TutorialNode"];
         
         
    }
    return [CCBReader loadAsScene:@"MainScene"];
}

@end
