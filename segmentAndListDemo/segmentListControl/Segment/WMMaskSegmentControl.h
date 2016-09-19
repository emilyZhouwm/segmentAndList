//
//  WMMaskSegmentControl.h
//
//  Created by zwm on 16/8/30.
//  Copyright © 2016年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, WMMaskSegmentType) {
    WMMaskSegmentAll = 0,        /**< 一屏等分，默认模式 */
    WMMaskSegmentWidth = 1,      /**< 指定宽度，kMaskDefultWidth */
    WMMaskSegmentSize = 2,       /**< 跟随内容，间隔kMaskDefultSpace */
};

// 焦点所在底色
#define kMaskGroundColor [UIColor colorWithRed:0/255.0 green:206/255.0 blue:13/255.0 alpha:1.0]
// 分割线颜色
#define kMaskLineColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0]
// 常态文本的颜色
#define kMaskTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
// 焦点所在文本的颜色
#define kMaskTextSColor [UIColor whiteColor]

#define kMaskTextFont (15)        // 文本字体大小
#define kMaskGroundSpace (0)      // 底块水平间隔
#define kMaskGroundSpaceH (0)     // 底块垂直间隔
#define kMaskGroundRadius (0)     // 底块圆角，如果为0则为方块
#define kMaskUpLineH (0.5)        // 上分割线高，为0则没有分割线
#define kMaskBottomLineH (0.5)    // 下分割线高，为0则没有分割线
#define kMaskLineW (0.5)          // 竖分割线宽，为0则没有竖分割线
#define kMaskLineSpace (0)        // 竖分割线的垂直间隔
#define kMaskAnimationTime (0.25) // 动画时长
#define kMaskDefultWidth (100)    // WMMaskSegmentWidth类型时生效
#define kMaskDefultSpace (10)     // WMMaskSegmentSize类型时生效，应大于kMaskGroundSpace

// 回调当前选项索引以及是否重复点击了选项
typedef void (^WMMaskSegmentControlBlock)(NSInteger index, BOOL isRepeat);

@class WMMaskSegmentControl;
@protocol WMMaskSegmentControlDelegate <NSObject>
@required
// 回调当前选项索引以及是否重复点击了选项
- (void)segmentControl:(WMMaskSegmentControl *)control selectedIndex:(NSInteger)index isRepeat:(BOOL)isRepeat;
@end

@interface WMMaskSegmentControl : UIView

@property (nonatomic, readonly) NSInteger currentIndex;                 /**< 当前选项索引 */
@property (nonatomic, weak) id <WMMaskSegmentControlDelegate> delegate; /**< 回调 */
@property (nonatomic, assign) WMMaskSegmentType segmentType;            /**< 类型，在配置选项之前指定 */
@property (nonatomic, assign) BOOL isStop;                              /**< 转屏时控制一下 */

///  1、配置选项
///  @param titleArray  选项数组
///  @param scrollView  联动scrollView，如果不必联动可为nil
///  @param block       改变选项回调，也可以nil使用delegate
- (void)setItemsWithTitleArray:(NSArray<NSString *> *)titleArray
                 andScrollView:(UIScrollView *)scrollView
                 selectedBlock:(WMMaskSegmentControlBlock)block;

@end
