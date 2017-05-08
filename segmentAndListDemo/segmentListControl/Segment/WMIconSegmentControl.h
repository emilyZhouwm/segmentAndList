//
//  WMIconSegmentControl.h
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kIconLineColor [UIColor colorWithRed:0/255.0 green:206/255.0 blue:13/255.0 alpha:1.0]
#define kHLineColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0]
#define kIconDefault [UIImage imageNamed:@"home_avatar"]
#define kIconWidth (40)
#define kIconHeight (40)
#define kItemWidth (60)

// 回调当前选项索引以及是否重复点击了选项
typedef void (^WMIconSegmentControlBlock)(NSInteger index, BOOL isRepeat);

@class WMIconSegmentControl;
@protocol WMIconSegmentControlDelegate <NSObject>
@required
// 回调当前选项索引以及是否重复点击了选项
- (void)segmentControl:(WMIconSegmentControl *)control selectedIndex:(NSInteger)index isRepeat:(BOOL)isRepeat;
@end

@protocol WMWebImageDelegate <NSObject>
@required
- (void)setWebImage:(UIImageView *)imgView imgUrl:(NSString *)imgUrl;
@end

@interface WMIconSegmentControl : UIView

@property (nonatomic, assign, readonly) NSInteger currentIndex;         /**< 当前选项索引 */
@property (nonatomic, weak) id <WMIconSegmentControlDelegate> delegate; /**< 回调 */
@property (nonatomic, weak) id <WMWebImageDelegate> imgDelegate;        /**< 交给外部取网络图片 */
@property (nonatomic, assign) BOOL isStop;                              /**< 转屏时控制一下 */

///  1、配置选项
///  @param titleArray  选项数组
///  @param scrollView  联动scrollView，如果不必联动可为nil
///  @param block       改变选项回调，也可以nil使用delegate
- (void)setItemsWithIconArray:(NSArray *)titleItem
                andScrollView:(UIScrollView *)scrollView
                selectedBlock:(WMIconSegmentControlBlock)block;

@end
