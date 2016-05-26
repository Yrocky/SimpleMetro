//
//  GuideViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "GuideViewController.h"
#import "UIView+Common.h"

@interface GuideViewController ()

@property (nonatomic ,assign) NSInteger count;

@end
@implementation GuideViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.delegate = self;
    _count = 0;
    [self next:NO];
}

- (void) next:(BOOL)animation{
    
    switch (self.count) {
        case 0:
            self.spotlight = [[HLLSpotlight alloc] initSpotlightForRounedRectWithCenter:CGPointMake(self.view.width/2, 42) andSize:CGSizeMake(120, 40) andRadius:6];
            [self.spotlightView appearWithSpotlight:self.spotlight
                                           duration:0.25];
            break;
        case 1:{
        
            HLLSpotlight * spotlight = [[HLLSpotlight alloc] initSpotlightForOvalWithCenter:CGPointMake(30, 40) andWidth:40];
            
            [self.spotlightView moveToSpotlight:spotlight
                                       duration:.25
                                       moveType:SpotlightMoveDisappear];
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
    
    NSLog(@"tap");
    [self next:YES];
}


@end
