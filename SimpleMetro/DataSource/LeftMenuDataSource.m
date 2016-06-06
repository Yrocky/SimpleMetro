//
//  LeftMenuDataSource.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LeftMenuDataSource.h"
#import "LeftMenuCell.h"


NSString * const kLeftMenuIconKey = @"icon";
NSString * const kLeftMenuTitleKey = @"title";

static NSString * const leftMenuCellIdentifier = @"leftMenuCellIdentifier";

@interface LeftMenuDataSource ()

@property (nonatomic ,strong) NSArray * leftMenuItems;
@end

@implementation LeftMenuDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        CGFloat inSideSize = 20.0f;
        
        FAKIcon *squareOIcon = [FAKFontAwesome squareOIconWithSize:35];
        [squareOIcon addAttribute:NSForegroundColorAttributeName value:[UIColor customWhiteColor]];
        
        // 站点信息
        FAKIcon * stationInfo = [FAKFontAwesome subwayIconWithSize:inSideSize];
        [stationInfo addAttribute:NSForegroundColorAttributeName value:[UIColor customWhiteColor]];
        NSArray * stationInfoIcons = @[stationInfo, squareOIcon];
        
        // 便捷乘车
        FAKIcon * map = [FAKFontAwesome mapOIconWithSize:25];
        [map addAttribute:NSForegroundColorAttributeName value:[UIColor customWhiteColor]];
        NSArray * convenientIcons = @[map];
        
        // 周边服务
        FAKIcon * mapMarket = [FAKFontAwesome mapMarkerIconWithSize:30];
        [mapMarket addAttribute:NSForegroundColorAttributeName value:[UIColor customWhiteColor]];
        NSArray * aroundServerIcons = @[mapMarket];
        
        // 地铁公告
        FAKIcon * ad = [FAKFontAwesome infoCircleIconWithSize:30];
        [ad addAttribute:NSForegroundColorAttributeName value:[UIColor customWhiteColor]];
        NSArray * adIcons = @[ad];

        _leftMenuItems = @[@[@{kLeftMenuIconKey:stationInfoIcons,
                               kLeftMenuTitleKey:@"站点信息"},
                             @{kLeftMenuIconKey:convenientIcons,
                               kLeftMenuTitleKey:@"便捷乘车"},
                             @{kLeftMenuIconKey:aroundServerIcons,
                               kLeftMenuTitleKey:@"周边服务"},
//                             @{kLeftMenuIconKey:adIcons,
//                               kLeftMenuTitleKey:@"地铁公告"}
                             ],
                           @[@{kLeftMenuIconKey:[NSNull new],
                               kLeftMenuTitleKey:@"意见反馈"},
                             @{kLeftMenuIconKey:[NSNull new],
                               kLeftMenuTitleKey:@"Third-Party Lib"},
                             @{kLeftMenuIconKey:[NSNull new],
                               kLeftMenuTitleKey:@"关于"}]];
    }
    return self;
}

#pragma mark - API
- (UIViewController *) viewControllerWithIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0 ) {//
        
        switch (indexPath.row) {
            case 0:
            {
                UINavigationController * metroNavigationController = (UINavigationController *)[StoryBoardUtilities viewControllerForStoryboardName:@"MetroInfo" storyBoardID:MetroNavigationControllerStoryBoardID];
                return metroNavigationController;
            }
                break;
            case 1:
            {
                UINavigationController * takeMetroNavigationController = (UINavigationController *)[StoryBoardUtilities viewControllerForStoryboardName:@"TakeMetro" storyBoardID:TakeMetroNavigationControllerID];
                return takeMetroNavigationController;
            }
                break;
            case 2:
            {
                UINavigationController * aroundServiceNavigationController = (UINavigationController *)[StoryBoardUtilities viewControllerForStoryboardName:@"AroundService" storyBoardID:AroundServiceNavigationControllerStoryBoardID];
                
                return aroundServiceNavigationController;
            }
                break;
            case 3:
            {
                UINavigationController * aboutNavigationController = (UINavigationController *)[StoryBoardUtilities viewControllerForStoryboardName:@"Main" storyBoardID:AboutMetroNavigationControllerStoryBoardID];
                
                return aboutNavigationController;
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
    
        switch (indexPath.row) {
            case 0:
            {
                return nil;
            }
                break;
            case 1:
            {
                UINavigationController * openSourceNavigationController = (UINavigationController *)[StoryBoardUtilities viewControllerForStoryboardName:@"Main" storyBoardID:OpenSourceNavigationControllerStoryBoardID];
                
                return openSourceNavigationController;
            }
                break;
            case 2:
            {
                UINavigationController * aboutMeNavigationController = (UINavigationController *)[StoryBoardUtilities viewControllerForStoryboardName:@"Main" storyBoardID:AboutMeViewControllerStoryBoardID];
                
                return aboutMeNavigationController;
            }
                break;
            default:
                break;
        }
    }
    return nil;
}
#pragma mark - DataSourceProtocol
//
-(NSString *)name{
    
    return @"";
}

- (id)elementForIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * sections = self.leftMenuItems[indexPath.section];

    return sections[indexPath.row];
}

- (Class)cellClass{
    
    return [LeftMenuCell class];
}

- (UINib *) nib{

    return  [UINib nibWithNibName:@"LeftMenuCell" bundle:nil];
}
- (NSString *)cellIdentifier{
    
    return leftMenuCellIdentifier;
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.leftMenuItems.count;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * sections = self.leftMenuItems[section];
    
    return sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        LeftMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:leftMenuCellIdentifier
                                                              forIndexPath:indexPath];
        
        NSDictionary * data = [self elementForIndexPath:indexPath];
        
        [cell configureCellWithData:data];
        
        return cell;
    }else if (indexPath.section == 1){
    
        static NSString * cellIdentifier = @"cellIdentifier";
        UITableViewCell * cell;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.textColor = [UIColor customWhiteColor];
//            cell.textLabel.font = [UIFont fontWithName:@"" size:16];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        NSDictionary * data = [self elementForIndexPath:indexPath];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",data[kLeftMenuTitleKey]];
        
        return cell;
    }
    return nil;
}

@end
