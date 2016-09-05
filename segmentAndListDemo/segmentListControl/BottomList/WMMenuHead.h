//
//  WMMenuHead.h
//
//  Created by zwm on 15/6/3.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMPickupList;
@interface WMMenuHead : UIView

// 继承必须实现以下函数
///  头部高度
+ (CGFloat)headHeight;

///  @param list   添加头部到list
///  @param title  显示内容
+ (UIView *)addHeadTo:(WMPickupList *)list withTitle:(NSString *)title;

@end
