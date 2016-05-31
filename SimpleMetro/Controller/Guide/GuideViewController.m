//
//  GuideViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "GuideViewController.h"
#import "UIView+Common.h"

static CGFloat GuideViewAnimationDuration       = 0.25f;

@interface GuideViewController ()

@property (nonatomic ,strong) IBOutlet UILabel       * titleViwGuide;
@property (nonatomic ,strong) IBOutlet UILabel       * cellGuide;
@property (nonatomic ,strong) IBOutlet UILabel       * leftMenuGuide;

@property (nonatomic ,strong) NSArray                * guideViews;

@property (nonatomic ,strong) IBOutlet UIButton      * skipButton;

@property (nonatomic ,assign) NSInteger       count;

@end
@implementation GuideViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];

    self.titleViwGuide.alpha        = 0.0f;
    self.cellGuide.alpha            = 0.0f;
    self.leftMenuGuide.alpha        = 0.0f;
    
    _guideViews = @[self.titleViwGuide,self.leftMenuGuide,self.cellGuide];
    
    self.delegate = self;
    
    _count = 0;
    
    [self next:NO];
}

- (void) gudideViewAnimation{
    
    for (NSInteger index = 0; index < self.guideViews.count; index ++) {
    
        UILabel * guideView = self.guideViews[index];
        
        [UIView animateWithDuration:GuideViewAnimationDuration animations:^{
            
            guideView.alpha = index == self.count ? 1.0f : 0.0f;
        }];
    }
}
#pragma mark - Action

- (IBAction) skipButtonDidPressed:(UIButton *)button{

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Guide Handle

- (void) next:(BOOL)animation{
    
    [self gudideViewAnimation];
    
    switch (self.count) {
        case 0:
            self.spotlight = [[HLLSpotlight alloc] initSpotlightForRounedRectWithCenter:CGPointMake(self.view.width/2 + 10, 42) andSize:CGSizeMake(180, 40) andRadius:6];
            [self.spotlightView appearWithSpotlight:self.spotlight
                                           duration:0.25];
            break;
        case 1:{
        
            HLLSpotlight * spotlight = [[HLLSpotlight alloc] initSpotlightForOvalWithCenter:CGPointMake(30, 40) andWidth:40];
            
            [self.spotlightView moveToSpotlight:spotlight
                                       duration:.25
                                       moveType:SpotlightMoveDirect];
        }
            break;
        case 2:{
            HLLSpotlight * spotlight = [[HLLSpotlight alloc] initSpotlightForRounedRectWithCenter:CGPointMake(self.view.width/2, 64 + 2.5 * 55) andSize:CGSizeMake(self.view.width - 8, 56) andRadius:6];
            
            [self.spotlightView moveToSpotlight:spotlight
                                       duration:.25
                                       moveType:SpotlightMoveDisappear];
        }
            break;
        case 3:
        {
//            HLLSpotlight * spotlight = [[HLLSpotlight alloc] initSpotlightForOvalWithCenter:CGPointMake(375/2, 200) andWidth:220];
//            
//            [self.spotlightView moveToSpotlight:spotlight
//                                       duration:.25
//                                       moveType:SpotlightMoveDisappear];
            [self dismissViewControllerAnimated:animation completion:nil];
        }
            break;
        default:
            break;
    }
    _count ++;
}
#pragma mark - HLLSpotlightDelegate

- (void) spotlightViewControllerDidTap:(HLLSpotlightViewController *)spotlightViewController{
    
    LOG_DEBUG(@"tap");
    [self next:YES];
}


@end
