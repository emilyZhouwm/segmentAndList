//
//  WMDropDown2View.h
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OPDropDownViewBlock)(NSInteger index, NSInteger secondIndex, NSString *title);

@interface WMDropDown2View : UIView

- (id)initWithFrame:(CGRect)frame
             titles:(NSArray *)titles   // 接受字串数组，
                                        // 或字典数组（二级列表）字典:
                                        // left Key对应左边列表，right Key字串数组对应右边二级列表
       defaultIndex:(NSInteger)index
        secondIndex:(NSInteger)secondIndex
      selectedBlock:(OPDropDownViewBlock)selectedHandle;
- (void)changeWithTitles:(NSArray *)titles
            defaultIndex:(NSInteger)index
             secondIndex:(NSInteger)secondIndex
           selectedBlock:(OPDropDownViewBlock)selectedHandle;

- (void)showView;
- (void)hideView;

@end
