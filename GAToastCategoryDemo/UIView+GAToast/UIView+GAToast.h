//
//  UIView+GAToast.h
//  GAToastCategoryDemo
//
//  Created by GikkiAres on 2017/2/7.
//  Copyright © 2017年 GikkiAres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAToastStyle.h"

@interface UIView (GAToast)
#pragma mark  1 显示Activity,网络请求的提示
//不要加在scrollView上,否则现象有点奇怪.
//#1 便利构造函数
- (void)gaShowActivity;
//#2 完全构造函数
- (void)gaShowActivityWithStyle:(GAToastStyle *)style;
- (void)gaHideActivity;


#pragma mark 2 显示MessageView,不是网络请求的提示.
//1 便利构造函数
- (void)gaShowMessage:(NSString *)msg;
- (void)gaShowMessage:(NSString *)msg completion:(void(^)(BOOL isFromTap))completion;
//3 完全构造函数
- (void)gaShowMessage:(NSString *)msg  style:(GAToastStyle *)style completion:(void(^)(BOOL isFromTap))completion;



@end
