//
//  WMTabControl.h
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

// 选中时出现底线的颜色，
#define kLineColor [UIColor colorWithRed:0/255.0 green:206/255.0 blue:13/255.0 alpha:1.0]
// 底线高度
#define kLineHeight (2)
// 底线左右间隔
#define kHspace (0)

// 分割线颜色
#define kHLineColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0]
// 垂直分割线上下间隔
#define kVerticalLineSpace (5)
// 水平分割线高度
#define kHorizontalLineH (1)

// 文本常态颜色
#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
// 文本选中颜色
#define kTextSelectColor [UIColor colorWithRed:0/255.0 green:206/255.0 blue:13/255.0 alpha:1.0]
// 文本字体
#define kTextFont (15)
// 右边icon间隔
#define kIconSpace (4)
// 右边icon宽高
#define kIconW (12)
#define kIconH (7)
// 右边icon选中图
#define kIconSelect [UIImage imageNamed:@"icon_arrow_up"]
// 右边icon常态图
#define kIconNomal  [UIImage imageNamed:@"icon_arrow"]
// 动画时长
#define kAnimationTime (0.3)

typedef void (^WMTabControlBlock)(NSInteger index);

@class WMTabControl;
@protocol WMTabControlDelegate <NSObject>
- (void)control:(WMTabControl *)control selectedIndex:(NSInteger)index;
@end

@interface WMTabControl : UIView

@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, copy) id<WMTabControlDelegate> delegate;

- (void)setItemsWithTitleArray:(NSArray *)titleArray
                 selectedBlock:(WMTabControlBlock)block;

- (void)setTitle:(NSString *)title withIndex:(NSInteger)index;

- (void)selectIndex:(NSInteger)index;

@end
