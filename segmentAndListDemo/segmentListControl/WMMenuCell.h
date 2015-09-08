//
//  WMMenuCell.h
//  segmentAndListDemo
//
//  Created by zwm on 15/6/3.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WMMenuCell : UITableViewCell

// 继承必须实现函数
+ (CGFloat)tableHeight;
+ (CGFloat)cellHeight;
- (void)setInfo:(id)info;
- (void)setIsSelect:(BOOL)selected;

@end
