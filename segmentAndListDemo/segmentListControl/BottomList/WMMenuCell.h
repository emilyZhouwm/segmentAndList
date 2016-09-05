//
//  WMMenuCell.h
//
//  Created by zwm on 15/6/3.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMMenuCell : UITableViewCell

// 继承必须实现以下函数

///  list在屏幕占高
+ (CGFloat)tableHeight;

///  每项cell高
+ (CGFloat)cellHeight;

///  设置信息
- (void)setInfo:(id)info;

///  设置选中状态
- (void)setIsSelect:(BOOL)selected;

@end
