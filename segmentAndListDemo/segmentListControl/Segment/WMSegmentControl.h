//
//  WMSegmentControl.h
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, WMSegmentType) {
    WMSegmentAll = 0,        /**< 一屏等分，默认模式 */
    WMSegmentWidth = 1,      /**< 指定宽度，kSegmentDefultWidth */
    WMSegmentSize = 2,       /**< 跟随内容，间隔kSegmentDefultSpace */
};

// 焦点所在底色，可为块状，可为条状
#define kGroundColor [UIColor colorWithRed:0/255.0 green:206/255.0 blue:13/255.0 alpha:1.0]
// 分割线颜色
#define kLineColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0]
// 常态文本的颜色
#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
// 焦点所在文本的颜色，如果底为条则最好与kGroundColor同色
#define kTextSColor kGroundColor//[UIColor whiteColor]

#define kTextFont (15)            // 文本字体大小
#define kGroundSpace (0)          // 底块或条的水平间隔
#define kGroundHeight (2)         // 如果高为0则，为块状，比如高为2则为条状
#define kUpLineH (0.5)            // 上分割线高，为0则没有分割线
#define kBottomLineH (0.5)        // 下分割线高，为0则没有分割线
#define kLineW (0.5)              // 竖分割线宽，为0则没有竖分割线
#define kLineSpace (0)            // 竖分割线的垂直间隔
#define kAnimationTime (0.3)      // 动画时长
#define kSegmentDefultWidth (100) // WMSegmentWidth类型时生效
#define kSegmentDefultSpace (20)  // WMSegmentSize类型时生效

// 回调当前选项索引以及是否重复点击了选项
typedef void (^WMSegmentControlBlock)(NSInteger index, BOOL isRepeat);

@class WMSegmentControl;
@protocol WMSegmentControlDelegate <NSObject>
@required
// 回调当前选项索引以及是否重复点击了选项
- (void)segmentControl:(WMSegmentControl *)control selectedIndex:(NSInteger)index isRepeat:(BOOL)isRepeat;
@end

@interface WMSegmentControl : UIView

@property (nonatomic, assign, readonly) NSInteger currentIndex;     /**< 当前选项索引 */
@property (nonatomic, weak) id <WMSegmentControlDelegate> delegate; /**< 回调 */
@property (nonatomic, assign) WMSegmentType segmentType;            /**< 类型，在配置选项之前指定 */
@property (nonatomic, assign) BOOL isStop;                          /**< 转屏时控制一下 */

///  1、配置选项
///  @param titleArray  选项数组
///  @param block       改变选项回调，也可以nil然后使用delegate
///  @param scrollView  联动scrollView，如果不必联动可为nil
- (void)setItemsWithTitleArray:(NSArray<NSString *> *)titleArray
                 andScrollView:(UIScrollView *)scrollView
                 selectedBlock:(WMSegmentControlBlock)block;

///  改变某一个选项的显示文本
///  @param title 选项文本
///  @param index 选项索引
- (void)setTitle:(NSString *)title withIndex:(NSInteger)index;

@end
