//
//  WMPickerControl.h
//
//  Created by zwm on 15/6/2.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WMPickupListBlock)(id title, NSInteger index);

@interface WMPickupList : UIView

// 配置cell类，基类必须是WMMenuCell
+ (void)setCellClass:(Class)cellClass;
// 配置head类，基类必须是WMMenuCell
+ (void)setHeadClass:(Class)headClass;

///  从底部弹出选项list
///  @param title   标题
///  @param titles  选项数组
///  @param index   默认选中
///  @param block   回调
+ (void)showWithTitle:(NSString *)title
           WithTitles:(NSArray *)titles
         defaultIndex:(NSInteger)index
        selectedBlock:(WMPickupListBlock)block;

///  关闭list
- (void)hideView;

@end
