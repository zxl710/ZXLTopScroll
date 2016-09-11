//
//  ZXLTitleView.h
//  高仿自选股
//
//  Created by macbook on 16/9/10.
//  Copyright © 2016年 曾晓利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXLTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame titleList:(NSArray<NSString *>*)titleList firstIndex:(NSInteger)firstIndex navigationItem:(UINavigationItem *)navigationItem;

- (void)observeScrollDidScroll:(UIScrollView *)scrollView;
- (void)observeScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
