//
//  SegmentControl.h
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLineColor [UIColor colorWithRed:0/255.0 green:206/255.0 blue:13/255.0 alpha:1.0]
#define kHLineColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0]
#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define kTextFont (15)

typedef void(^WMSegmentControlBlock)(NSInteger index);

@class WMSegmentControl;
@protocol WMSegmentControlDelegate <NSObject>

- (void)segmentControl:(WMSegmentControl *)control selectedIndex:(NSInteger)index;

@end

@interface WMSegmentControl : UIView

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic , weak) id <WMSegmentControlDelegate> delegate;

- (void)setItemsWithTitleArray:(NSArray *)titleArray selectedBlock:(WMSegmentControlBlock)selectedHandle;
- (void)setItemsWithTitleArray:(NSArray *)titleArray;

- (void)selectIndex:(NSInteger)index;

- (void)setTitle:(NSString *)title withIndex:(NSInteger)index;

- (void)moveIndexWithProgress:(float)progress;

@end
