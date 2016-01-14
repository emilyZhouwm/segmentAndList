//
//  SegmentControl.h
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

// 焦点所在底色，可为块状，可为条状
#define kGroundColor [UIColor colorWithRed:0/255.0 green:206/255.0 blue:13/255.0 alpha:1.0]
// 分割线颜色
#define kLineColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0]
// 常态文本的颜色
#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
// 焦点所在文本的颜色，如果底为条则可与kGroundColor同色
#define kTextSColor [UIColor whiteColor]
#define kTextFont (15)          // 文本字体大小
#define kGroundSpace (0)        // 底块或条的水平间隔
#define kGroundHeight (0)       // 如果高为0则，为块状，比如高为2则为条状
#define kUpLineH (0.5)            // 上分割线高，为0则没有分割线
#define kBottomLineH (0.5)        // 下分割线高，为0则没有分割线
#define kLineW (0.5)              // 竖分割线宽，为0则没有竖分割线
#define kLineSpace (0)          // 竖分割线的垂直间隔
#define kAnimationTime (0.3)    // 动画时长

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
