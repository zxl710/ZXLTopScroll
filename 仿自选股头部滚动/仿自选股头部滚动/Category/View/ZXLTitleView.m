//
//  ZXLTitleView.m
//  高仿自选股
//
//  Created by macbook on 16/9/10.
//  Copyright © 2016年 曾晓利. All rights reserved.
//

#import "ZXLTitleView.h"
#import "UIView+Util.h"

#define ZXLLabelMarginX 30
#define ZXLLabelHeight 22
#define zxlLabelBaseTag 1000

@interface ZXLTitleView()

@property (nonatomic, strong)UIButton *titleButton;
@property (nonatomic, strong)UIScrollView  *scrollView;
@property (nonatomic ,strong)NSArray *titleList;
@property (nonatomic ,assign)NSInteger firstIndex;
@property (nonatomic ,assign)UINavigationItem *navigationItem;
@property (nonatomic ,strong)UIFont *seletedFont;
@property (nonatomic ,strong)UIFont *titleFont;
@property (nonatomic ,assign)CGFloat itemTitleUnselectedFontScale;

@end

@implementation ZXLTitleView

- (instancetype)initWithFrame:(CGRect)frame titleList:(NSArray<NSString *>*)titleList firstIndex:(NSInteger)firstIndex navigationItem:(UINavigationItem *)navigationItem
{
    if (self = [super initWithFrame:frame]) {
        self.titleList = titleList;
        self.firstIndex = firstIndex;
        self.navigationItem = navigationItem;
        self.seletedFont = [UIFont systemFontOfSize:17.f];
        self.titleFont = [UIFont systemFontOfSize:12.f];
        [self addSubview:self.scrollView];
        [self addSubview:self.titleButton];
        [self setUpScrollLabel];
    }
    return self;
}

-(void)setUpScrollLabel
{
    if (self.titleList.count) {
        for (int i=0; i<self.titleList.count; i++) {
            NSString *title = self.titleList[i];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*(self.width+ZXLLabelMarginX), 0, self.width, ZXLLabelHeight)];
            label.tag = zxlLabelBaseTag + i;
            label.text = title;
            label.font = self.titleFont;
            if (i == self.firstIndex) {
                label.transform = CGAffineTransformMakeScale(self.itemTitleUnselectedFontScale, self.itemTitleUnselectedFontScale);
            }
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            [self.scrollView addSubview:label];
        }
        self.scrollView.contentSize = CGSizeMake(self.width*self.titleList.count+ZXLLabelMarginX*(self.titleList.count-1), ZXLLabelHeight);
        if (self.firstIndex) {
            self.scrollView.contentOffset = CGPointMake(self.firstIndex*(ZXLLabelMarginX + self.width), 0);
        }
    
    }
}

- (CGFloat)itemTitleUnselectedFontScale
{
    return self.seletedFont.pointSize / self.titleFont.pointSize;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UIButton *)titleButton
{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.backgroundColor = [UIColor clearColor];
        [_titleButton setImage:[UIImage imageNamed:@"zxl_arrow"] forState:UIControlStateNormal];
    }
    return _titleButton;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleButton.frame = self.bounds;
    UIImage *image = [UIImage imageNamed:@"zxl_arrow"];
    self.titleButton.imageEdgeInsets = UIEdgeInsetsMake(self.titleButton.height-image.size.height, 0.5*(self.titleButton.width - image.size.width), 0, 0.5*(self.titleButton.width - image.size.width));
    self.scrollView.frame = CGRectMake(0, 10, self.width, ZXLLabelHeight);
}
- (void)observeScrollDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollView.clipsToBounds) {
        self.scrollView.clipsToBounds = NO;
    }
    if (!self.navigationItem.leftBarButtonItem.customView.hidden&&!self.navigationItem.rightBarButtonItem.customView.hidden) {
        self.navigationItem.leftBarButtonItem.customView.hidden = YES;
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    }
    
    [self changeTitleFont:scrollView];
    CGFloat offsetScale = (self.width + ZXLLabelMarginX)/scrollView.width;
    [self.scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x*offsetScale, 0) animated:YES];
}

- (void)observeScrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.scrollView.clipsToBounds = YES;
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    self.firstIndex = scrollView.contentOffset.x / scrollView.width;
}

- (void)changeTitleFont:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.width;
    if (offsetX < 0) {
        return;
    }
    if (offsetX > scrollView.contentSize.width - scrollViewWidth) {
        return;
    }
    NSInteger leftIndex = offsetX / scrollViewWidth;
    NSInteger rightIndex = leftIndex + 1;
    UILabel *leftLabel = [self.scrollView viewWithTag:zxlLabelBaseTag + leftIndex];
    UILabel *rightLabel = nil;
    if (rightIndex < self.titleList.count) {
        rightLabel = [self.scrollView viewWithTag:zxlLabelBaseTag + rightIndex];
    }
    
    // 计算右边按钮偏移量
    CGFloat rightScale = offsetX / scrollViewWidth;
    // 只想要 0~1
    rightScale = rightScale - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    if (scrollView.isDragging || scrollView.isDecelerating) {
        // 计算字体大小的差值
        CGFloat diff = self.itemTitleUnselectedFontScale - 1;
        // 根据偏移量和差值，计算缩放值
        rightLabel.transform = CGAffineTransformMakeScale(rightScale * diff + 1, rightScale * diff + 1);
        leftLabel.transform = CGAffineTransformMakeScale(leftScale * diff + 1, leftScale * diff + 1);
    }

    
}

@end
