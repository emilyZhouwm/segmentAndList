//
//  WMSegmentControl.h
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLineColor [UIColor colorWithRed:0/255.0 green:206/255.0 blue:13/255.0 alpha:1.0]
#define kHLineColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0]
#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define kTextFont (15)
#define kIconSpace (4)
#define kIconW (12)
#define kIconH (7)
#define kIconSelect [UIImage imageNamed:@"icon_arrow_up"]
#define kIconNomal  [UIImage imageNamed:@"icon_arrow"]

typedef void(^WMTabControlBlock)(NSInteger index);

@class WMTabControl;
@protocol WMTabControlDelegate <NSObject>

- (void)segmentControl:(WMTabControl *)control selectedIndex:(NSInteger)index;

@end

@interface WMTabControl : UIView

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, copy) id<WMTabControlDelegate> delegate;

- (void)setItemsWithTitleArray:(NSArray *)titleArray selectedBlock:(WMTabControlBlock)selectedHandle;
- (void)setItemsWithTitleArray:(NSArray *)titleArray;

- (void)setTitle:(NSString *)title withIndex:(NSInteger)index;

- (void)selectIndex:(NSInteger)index;

@end
