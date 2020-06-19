//
//  WMNavTabBar.h
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

// 焦点所在选项的颜色
#define kRed 51
#define kGreen 51
#define kBlue 51
#define kCurrentColor [UIColor colorWithRed:kRed/255.0 green:kGreen/255.0 blue:kBlue/255.0 alpha:1.0]
#define kLineColor [UIColor colorWithRed:kRed/255.0 green:kGreen/255.0 blue:kBlue/255.0 alpha:1.0]

// 左右遮罩图
#define kShadeLeft [UIImage imageNamed:@"Shade_Left"]
#define kShadeRight [UIImage imageNamed:@"Shade_Right"]
// 遮罩图宽
#define kShadeW 40

// 焦点所在选项字体
#define kBarFont 17.0
// 焦点不在时的字体缩小比例，如果为1则不变
#define kBarFontScale 0.94

// 回调当前选项索引以及是否重复点击了选项
typedef void (^WMNavTabBarBlock)(NSInteger index, NSInteger isRepeat);

@class WMNavTabBar;
@protocol WMNavTabBarDelegate <NSObject>
@required
// 回调当前选项索引以及是否重复点击了选项
- (void)itemDidSelected:(WMNavTabBar *)tabBar withIndex:(NSInteger)index isRepeat:(BOOL)isRepeat;
@end

@protocol WMVCDelegate <NSObject>
@required
- (void)showNavView:(BOOL)isShow;
@end

@interface WMNavTabBar : UIView

@property (nonatomic, weak) id <WMNavTabBarDelegate>delegate;   /**< 回调 */
@property (nonatomic, assign) NSInteger currentItemIndex;       /**< 当前选项索引 */
@property (nonatomic, assign) BOOL isSamp;                      /**< 是否平摊，配置选项之前设置 */
@property (nonatomic, assign) BOOL isFont;                      /**< 是否改变字体大小，配置选项之前设置 */
@property (nonatomic, assign) BOOL isStop;                      /**< 转屏时控制一下 */

/// 0、配置ui数值，需要先执行
- (void)setBarFont:(CGFloat)font;
- (void)setBarFontScale:(CGFloat)font;
- (void)setBarLineH:(CGFloat)height;
- (void)setLineColor:(UIColor *)color;

///  1、配置选项
///  @param itemTitles  选项数组
///  @param scrollView  联动scrollView，如果不必联动可为nil
///  @param block       改变选项回调，也可以nil使用delegate
- (void)setItemTitles:(NSArray<NSString *> *)itemTitles
        andScrollView:(UIScrollView *)scrollView
        selectedBlock:(WMNavTabBarBlock)block;

@end
