//
//  GAToastStyle.m
//  GAToast-Master
//
//  Created by oftenfull on 16/3/29.
//  Copyright © 2016年 GikkAres. All rights reserved.
//

#import "GAToastStyle.h"

@implementation GAToastStyle
static NSInteger _defaultShowDuration = 1;
static NSInteger _defaultFadeDuration = 0.2;
static BOOL _shouldDismissWhenTapped = YES;
static BOOL _shouldShowMessageInQueue = YES;
+ (instancetype)defaultStyle {
  //为什么这里不能写init呢?因为在init函数后面加了NS_UNAVAILABLE
  GAToastStyle *defaultStyle = [[GAToastStyle alloc]init];
  if (defaultStyle) {
    //颜色
    defaultStyle.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.8];
    defaultStyle.messageColor = [UIColor whiteColor];
    //距离
    defaultStyle.maxWidthPercentage = 0.8;
    defaultStyle.maxHeightPercentage = 0.8;
    defaultStyle.horizontalPadding = 10.0;
    defaultStyle.verticalPadding = 10.0;
    defaultStyle.cornerRadius = 10.0;
    //字体
    defaultStyle.messageFont = [UIFont systemFontOfSize:16.0];
    defaultStyle.messageAlignment = NSTextAlignmentLeft;

    //阴影
    defaultStyle.displayShadow = YES;
    defaultStyle.shadowOpacity = 0.8;
    defaultStyle.shadowRadius = 6.0;
    defaultStyle.shadowOffset = CGSizeMake(4.0, 4.0);

    //时间
    defaultStyle.fadeDuration = _defaultFadeDuration;
    defaultStyle.showDuration = _defaultShowDuration;
    
    //其他
    defaultStyle.isProtectedWhenActivityViewIsShown = YES;
    defaultStyle.isActivityViewUseCenterAppearanceStyle = YES;
    defaultStyle.position = GAToastPositionCenter;
    defaultStyle.shouldDismissWhenTapped = _shouldDismissWhenTapped;
    defaultStyle.shouldShowMessageInQueue = _shouldShowMessageInQueue;
    defaultStyle.shouldActivityViewShowText = YES;
    defaultStyle.activityViewText = @"正在加载...";
    
  }
  return defaultStyle;
}

+(void)updateDefaultFadeDuration:(NSInteger)defaultFadeDuration {
    _defaultFadeDuration = defaultFadeDuration;
}
+ (void)updateDefaultShowDuration:(NSInteger)defaultShowDuration {
    _defaultShowDuration = defaultShowDuration;
}
+(void)updateDefaultShouldDismissWhenTapped:(BOOL)shouldDismissWhenTapped {
    _shouldDismissWhenTapped = shouldDismissWhenTapped;
}
+(void)updateDefaultShouldShowMessageInQueue:(BOOL)shouldShowMessageInQueue {
    _shouldShowMessageInQueue = shouldShowMessageInQueue;
}

@end
