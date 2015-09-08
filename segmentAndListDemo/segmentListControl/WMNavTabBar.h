//
//  WMNavTabBar.h
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRed 39
#define kGreen 72
#define kBlue 249
#define kLineColor [UIColor colorWithRed:kRed/255.0 green:kGreen/255.0 blue:kBlue/255.0 alpha:1.0]
#define kShadeLeft [UIImage imageNamed:@"Shade_Left"]
#define kShadeRight [UIImage imageNamed:@"Shade_Right"]
#define kShadeW 40

@class WMNavTabBar;
@protocol WMNavTabBarDelegate <NSObject>
@required
- (void)itemDidSelected:(WMNavTabBar *)tabBar withIndex:(NSInteger)index isRepeat:(BOOL)isRepeat;
@end

@interface WMNavTabBar : UIView 

@property (nonatomic, weak) id <WMNavTabBarDelegate>navDelegate;

- (void)setItemTitles:(NSArray *)itemTitles andScrollView:(UIScrollView *)scrollView;

@property (nonatomic, assign) NSInteger currentItemIndex;

@property (nonatomic, assign) BOOL isSamp;

@end
