//
//  UIView+GAToast.m
//  GAToastCategoryDemo
//
//  Created by GikkiAres on 2017/2/7.
//  Copyright © 2017年 GikkiAres. All rights reserved.
//

#import "UIView+GAToast.h"
#import "GADefaultActivityView.h"
#import <objc/runtime.h>

@implementation UIView (GAToast)

//关联的关键字
static const NSString * GAActivityViewKey   = @"GAActivityViewKey";
static const NSString * GAActivityProtectorViewKey   = @"GAActivityProtectorViewKey";
static const NSString * GAActivityViewCountKey   = @"GAActivityViewCountKey";

static const NSString * GAMessageViewKey = @"GAMessageViewKey";
static const NSString * GAMessageViewBlockKey = @"GAMessageViewBlockKey";
static const NSString * GAMessageViewArrayKey = @"GAMessageViewArrayKey";
static const NSString * GAMessageViewStyleKey = @"GAMessageViewStyleKey";

#pragma mark - 2 BasicFunc
#pragma mark 2.1 ActivityView的显示和隐藏
- (void)gaShowActivity {
    [self gaShowActivityWithStyle:[GAToastStyle defaultStyle]];
}

- (void)gaShowActivityWithStyle:(GAToastStyle *)style {
    //判断是否有activityView,有就将计数加一,否则创建,并设计数为1.
    UIView *activityView = objc_getAssociatedObject(self, &GAActivityViewKey);
    if(activityView) {
        NSNumber *activityViewCount = objc_getAssociatedObject(self, &GAActivityViewCountKey);
        NSInteger count = [activityViewCount integerValue];
        count ++;
        activityViewCount = @(count);
    }
    else {
        // 创建view和设置关联
        if (style.isProtectedWhenActivityViewIsShown) {
            UIView *protectorView = [[UIView alloc]initWithFrame:self.bounds];
            [self addSubview:protectorView];
            objc_setAssociatedObject(self, &GAActivityProtectorViewKey, protectorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        UIView *activityView = [[GADefaultActivityView alloc ]initWithToastStyle:style];
        [self addSubview:activityView];
        objc_setAssociatedObject(self, &GAActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &GAActivityViewCountKey, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        
        //1 静态样式调整-    //圆角和阴影
        if(style.isActivityViewUseCenterAppearanceStyle) {
            activityView.layer.cornerRadius = style.cornerRadius;
            if (style.displayShadow) {
                activityView.layer.shadowColor = style.shadowColor.CGColor;
                activityView.layer.shadowOpacity = style.shadowOpacity;
                activityView.layer.shadowRadius = style.shadowRadius;
                activityView.layer.shadowOffset = style.shadowOffset;
            }
        }
        //2 alpha动画
        activityView.alpha = 0;
        [UIView animateWithDuration:style.fadeDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             activityView.alpha = 1;
                         } completion:nil];
        
        // 中心点调整
        activityView.center = [self centerPointForSubview:activityView atSuperview:self style:style];
    }
}
- (void)gaHideActivity {
    UIView *activityView = objc_getAssociatedObject(self, &GAActivityViewKey);
    if (!activityView) return;
    NSNumber *activityViewCount = objc_getAssociatedObject(self, &GAActivityViewCountKey);
    NSInteger count = [activityViewCount integerValue];
    count --;
    activityViewCount = @(count);
    if(count ==0) {
        GAToastStyle *style = [GAToastStyle defaultStyle];
        [UIView animateWithDuration:style.fadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             activityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [activityView removeFromSuperview];
                             UIView *protectorView = objc_getAssociatedObject(self, &GAActivityProtectorViewKey);
                             [protectorView removeFromSuperview];
                             objc_setAssociatedObject(self, &GAActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                             objc_setAssociatedObject(self, &GAActivityViewCountKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                             objc_setAssociatedObject(self, &GAActivityProtectorViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                             
                         }];
    }
    
}

#pragma mark 2.2  MessageView的显示
- (void)gaShowMessage:(NSString *)msg {
    GAToastStyle *style = [GAToastStyle defaultStyle];
    [self gaShowMessage:msg style:style completion:nil];
}

- (void)gaShowMessage:(NSString *)msg completion:(void (^)(BOOL))completion {
    GAToastStyle *style = [GAToastStyle defaultStyle];
    [self gaShowMessage:msg style:style completion:completion];
}

//这个是showMsg系列的最终方法.
- (void)gaShowMessage:(NSString *)msg style:(GAToastStyle *)style completion:(void(^)(BOOL isFromTap))completion {
    //参数验证,显示时间少于0就不显示啦
    if(style.showDuration<=0) return;
    
    //总体分为两步,1 生成msgView 2 显示.
    if (!msg||!msg.length) return;
    UIView *messageView = [self messageViewForMessage:msg  style:style atSuperview:self];
    
    //如果self本身现在已经有了一个message,且开启了队列显示(即不是
    if (style.shouldShowMessageInQueue&&objc_getAssociatedObject(self, &GAMessageViewKey) != nil) {
        //关联队列数组
        NSMutableArray<UIView *> *messageViewQueue = objc_getAssociatedObject(self, &GAMessageViewArrayKey);
        if (messageViewQueue == nil) {
            messageViewQueue = [[NSMutableArray alloc] init];
            objc_setAssociatedObject(self, &GAMessageViewArrayKey, messageViewQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        objc_setAssociatedObject(messageView, &GAMessageViewStyleKey, style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [messageViewQueue addObject:messageView];
    } else {
        // 立即显示
        [self showMessageView:messageView atTargetView:self  style:style completion:completion];
    }
}

#pragma mark 根据msg,和样式生成MessageView.
//需要用到Superview的尺寸来决定生成的view的尺寸.
- (UIView *)messageViewForMessage:(NSString *)msg style:(GAToastStyle *)style atSuperview:(UIView *)view {
    if (!style) {
        style = [GAToastStyle defaultStyle];
    }
    UIView *msgView = [UIView new];
    
    //设置样式
    msgView.layer.cornerRadius = style.cornerRadius;
    if (style.displayShadow) {
        msgView.layer.shadowColor = style.shadowColor.CGColor;
        msgView.layer.shadowOpacity = style.shadowOpacity;
        msgView.layer.shadowRadius = style.shadowRadius;
        msgView.layer.shadowOffset = style.shadowOffset;
    }
    msgView.backgroundColor = style.backgroundColor;
    
    UILabel * messageLabel = [[UILabel alloc] init];
    messageLabel.font = style.messageFont;
    messageLabel.textAlignment = style.messageAlignment;
    messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    messageLabel.textColor = style.messageColor;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.alpha = 1.0;
    messageLabel.numberOfLines = 0;
    messageLabel.text = msg;
    
    //根据view的宽度,计算msgLbl和msgView的尺寸.
    CGSize sizeMessageLabel = [messageLabel sizeThatFits:CGSizeMake(view.bounds.size.width * style.maxWidthPercentage-style.horizontalPadding*2, 0) ];
    messageLabel.frame = CGRectMake(style.horizontalPadding, style.verticalPadding, sizeMessageLabel.width, sizeMessageLabel.height);
    CGFloat msgViewWidth = sizeMessageLabel.width+style.horizontalPadding*2;
    CGFloat msgViewHeight = sizeMessageLabel.height+style.verticalPadding*2;
    msgView.frame = CGRectMake(0.0, 0.0, msgViewWidth, msgViewHeight);
    [msgView addSubview:messageLabel];
    return msgView;
}

#pragma mark 显示MessageView,显示messageView的最终方法.直接显示
- (void)showMessageView:(UIView *)messageView atTargetView:(UIView *)targetView style:(GAToastStyle *)style completion:(void(^)(BOOL isFromTap))completion {
    messageView.center = [self centerPointForSubview:messageView atSuperview:self style:style];
    [targetView addSubview:messageView];
    //关联MessageView和completion
    objc_setAssociatedObject(messageView, &GAMessageViewBlockKey, completion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //关联targetView和messageView
    objc_setAssociatedObject(targetView, &GAMessageViewKey, messageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //是否添加点击手势
    if (style.shouldDismissWhenTapped) {
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [messageView addGestureRecognizer:gr];
        messageView.exclusiveTouch = YES;
    }
    //alpha动画
    messageView.alpha = 0;
    [UIView animateWithDuration:[style fadeDuration]
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         messageView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer timerWithTimeInterval:style.showDuration target:self selector:@selector(onTimer:) userInfo:messageView repeats:NO];
                         [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                     }];
}

- (void)removeMessageView:(UIView *)messageView isFromTap:(BOOL)isFromTap {
    [UIView animateWithDuration:[GAToastStyle defaultStyle].fadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         messageView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         //移除messageView
                         UIView *targetView = messageView.superview;
                         [messageView removeFromSuperview];
                         
                         //解除关联
                         objc_setAssociatedObject(targetView, &GAMessageViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         // execute the completion block, if necessary,先处理block然后再处理队列的.只有这个block执行完,才算这个view执行完.
                         void (^completion)(BOOL isFromTap) = objc_getAssociatedObject(messageView, &GAMessageViewBlockKey);
                         if (completion) {
                             completion(isFromTap);
                             objc_setAssociatedObject(messageView, &GAMessageViewBlockKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }
                         
                         //检查队列中是否还有要show的messageView.
                         NSMutableArray *messageViewQueue = objc_getAssociatedObject(targetView, &GAMessageViewArrayKey);
                         if (messageViewQueue) {
                             if(messageViewQueue.count) {
                                 UIView *nextMessageView = messageViewQueue[0];
                                 [messageViewQueue removeObjectAtIndex:0];
                                 // present the next toast
                                 GAToastStyle *style = objc_getAssociatedObject(nextMessageView, &GAMessageViewStyleKey);
                                 [self showMessageView:nextMessageView atTargetView:targetView style:style completion:nil];
                             }
                             else  {
                                 objc_setAssociatedObject(targetView, &GAMessageViewArrayKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                             }
                             
                         }
                     }];
}


#pragma mark 2.3 工具函数
//返回Subview在supview中指定位置关系的中心点的坐标.
- (CGPoint)centerPointForSubview:(UIView *)subview atSuperview:(UIView *)superview style:(GAToastStyle *)style{
    //如果style中指定了toastCenterPoint,就返回这个点,否则根据postition来.
    if(style.centerPoint) {
        return [style.centerPoint CGPointValue];
    }
    switch (style.position) {
        case GAToastPositionTop:
            return CGPointMake(superview.bounds.size.width/2, (subview.frame.size.height / 2) + style.verticalPadding);
            break;
            
        case GAToastPositionCenter:
            return CGPointMake(superview.bounds.size.width/2, superview.bounds.size.height/2);
            break;
            
        case GAToastPositionBottom:
            return CGPointMake(superview.bounds.size.width/2, (superview.bounds.size.height- subview.frame.size.height / 2) - style.verticalPadding);
            break;
    }
}

#pragma mark 4 Event
- (void)onTimer:(NSTimer *)timer {
    [self removeMessageView:timer.userInfo isFromTap:NO];
    
}

- (void)onTap:(UITapGestureRecognizer *)gr {
    [self removeMessageView:gr.view isFromTap:YES];
}






@end
