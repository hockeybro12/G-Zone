//
//  TutorialLayer.m
//  GZone
//
//  Created by Nikhil Mehta on 12/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TutorialLayer.h"

@implementation TutorialLayer {
    CCButton *backButtons;
}

-(void)goBack {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
    for (UIView *subview in [self->view subviews]) {
        if (subview.tag == 7) {
            [subview removeFromSuperview];
        }
    }
    
    [Scroller removeFromSuperview];
    
    [button removeFromSuperview];
    [button2 removeFromSuperview];
    
    
}

-(void)showAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Help" message:@"This is the tutorial for this game. You can access it any time by clicking the tutorial button from the home screen. Reading the tutorial is VITAL to your success in this game. There are a total of 4 screens and you can navigate through them by swiping right or left." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
}

-(id)init {
    if (self = [super init]) {
        
        size = [[CCDirector sharedDirector] viewSize];

    }
    
    return self;
}

-(void)didLoadFromCCB {
    
    [backButtons setZOrder:1000];
    
    //How many pages do we want?
    int PageCount = 4;
    
    //Setup scroll view
    if ((size.width == 480) && (size.height == 320)) {
        Scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(size.width - 480, 0, 480, 320)];
    } else if (size.width == 568 && (size.height == 320)) {
        Scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(44, 0, 480, 320)];
    } else if ((size.width == 667) && (size.height == 375)) {
        Scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(93.5, 0, 480, 320)];
    } else if ((size.width == 736) && (size.height == 414)) {
        Scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(128, 0, 480, 320)];
    } else {
        Scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(size.width - 480, 0, 480, 320)];
    }
    
    Scroller.backgroundColor = [UIColor clearColor];
    Scroller.pagingEnabled = YES;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    Scroller.layer.zPosition = -1;
    
    //Setup Each View Size
    CGRect ViewSize = Scroller.bounds;
    
    //Setup and Add Images
    UIImageView *ImgView = [[UIImageView alloc] initWithFrame:ViewSize];
    [ImgView setImage:[UIImage imageNamed:@"Tutorial 1.png"]];
    [Scroller addSubview:ImgView];
    ImgView.layer.zPosition = -1;
    
    //Offset View Size
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
    
    UIImageView *ImgView2 = [[UIImageView alloc] initWithFrame:ViewSize];
    [ImgView2 setImage:[UIImage imageNamed:@"Tutorial 2.png"]];
    [Scroller addSubview:ImgView2];
    
    //Offset View Size
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
    
    UIImageView *ImgView3 = [[UIImageView alloc] initWithFrame:ViewSize];
    [ImgView3 setImage:[UIImage imageNamed:@"Tutorial 3.png"]];
    [Scroller addSubview:ImgView3];
    
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
    
    UIImageView *ImgView4 = [[UIImageView alloc] initWithFrame:ViewSize];
    [ImgView4 setImage:[UIImage imageNamed:@"Tutorial 4.png"]];
    [Scroller addSubview:ImgView4];
    
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);

    view = [CCDirector sharedDirector].view;
    view.layer.zPosition = -1;
    [view addSubview:Scroller];
    view.tag = 7;
    
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button sizeToFit];
    
    // Set a new (x,y) point for the button's center
    button.center = CGPointMake(20, size.height - 300);
    
    [button addTarget:self action:@selector(goBack)
     forControlEvents:UIControlEventTouchUpInside];
    
    button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"Help" forState:UIControlStateNormal];
    [button2 sizeToFit];
    
    // Set a new (x,y) point for the button's center
    button2.center = CGPointMake(size.width - 20, size.height - 300);
    
    [button2 addTarget:self action:@selector(showAlertView)
     forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    [view addSubview:button2];
    


}



@end
