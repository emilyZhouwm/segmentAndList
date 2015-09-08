//
//  WMMenuHead.h
//  segmentAndListDemo
//
//  Created by zwm on 15/6/3.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMPickerControl;
@interface WMMenuHead : UIView

// 继承必须实现函数
+ (CGFloat)headHeight;
+ (UIView *)addHeadTo:(WMPickerControl *)control withTitle:(NSString *)title;

@end
