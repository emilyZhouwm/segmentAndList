# 各种效果的分段选择和下拉列表，二级下拉列表，可自定义列表样式。

![](./segmentAndList.gif)

    // 1.设置数据
    NSArray *titleAry = @[@"精选精选", @"优惠优惠", @"海淘海淘", @"精选", @"优惠", @"海淘", @"精选一", @"优惠二", @"海淘三"];
    _navTabBar.delegate = self;
    _navTabBar.isFont = TRUE;
    [_navTabBar setItemTitles:titleAry andScrollView:_scrollView1 selectedBlock:nil];

    // 1.3 分段改变
    if (isRepeat) {
        // 1.3.1 重复点击，可以选择回滚到头部
        [self scrollHead:index];
    } else {
        // 1.3.2 如果没加载数据则加载数据，懒加载模式
        [self loadData:index];
    }

    // 1.1 转屏时设置一下，不支持转屏可以没有这部分
    _navTabBar.isStop = TRUE;

    // 1.2 转屏完设置一下
    _navTabBar.isStop = FALSE;

ps:
如果手写代码不要忘了    _scrollView.pagingEnabled = TRUE;
