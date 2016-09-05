//
//  WMDropDown2View.h
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WMDropDown2ViewBlock)(NSInteger index, NSInteger secondIndex, NSString *title);

@interface WMDropDown2View : UIView

///  初始化
///  @param frame       区域
///  @param titles      接受字串数组或字典数组（二级列表，@[@{@"left":@[字串数组对应左边列表],@"right":@"字串数组对应右边二级列表"
///  @param index       默认索引
///  @param secondIndex 假如是二级列表，二级默认索引
///  @param blcok       回调
///  @return WMDropDown2View
- (id)initWithFrame:(CGRect)frame
             titles:(NSArray *)titles
       defaultIndex:(NSInteger)index
        secondIndex:(NSInteger)secondIndex
      selectedBlock:(WMDropDown2ViewBlock)block;
///  改变内容，参数同上
- (void)changeWithTitles:(NSArray *)titles
            defaultIndex:(NSInteger)index
             secondIndex:(NSInteger)secondIndex
           selectedBlock:(WMDropDown2ViewBlock)block;

- (void)showView;
- (void)hideView;

@end
