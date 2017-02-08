//
//  GAToastStyle.h
//  GAToast-Master
//
//  Created by oftenfull on 16/3/29.
//  Copyright © 2016年 GikkAres. All rights reserved.
//

#import <UIKit/UIKit.h>
//结构
typedef NS_ENUM(NSUInteger, GAToastPosition) {
  GAToastPositionCenter,
  GAToastPositionTop,
  GAToastPositionBottom
};


@interface GAToastStyle: NSObject


/**
 The background color. Default is `[UIColor blackColor]` at 80% opacity.
 */
@property (strong, nonatomic) UIColor *backgroundColor;



/**
 The message color. Default is `[UIColor whiteColor]`.
 */
@property (strong, nonatomic) UIColor *messageColor;




/**
 A percentage value from 0.0 to 1.0, representing the maximum width of the toast
 view relative to it's superview. Default is 0.8 (80% of the superview's width).
 */
@property (assign, nonatomic) CGFloat maxWidthPercentage;

/**
 A percentage value from 0.0 to 1.0, representing the maximum height of the toast
 view relative to it's superview. Default is 0.8 (80% of the superview's height).
 */
@property (assign, nonatomic) CGFloat maxHeightPercentage;

/**
 The spacing from the horizontal edge of the toast view to the content. When an image
 is present, this is also used as the padding between the image and the text.
 Default is 10.0.
 */
@property (assign, nonatomic) CGFloat horizontalPadding;

/**
 The spacing from the vertical edge of the toast view to the content. When a title
 is present, this is also used as the padding between the title and the message.
 Default is 10.0.
 */
@property (assign, nonatomic) CGFloat verticalPadding;

/**
 The corner radius. Default is 10.0.
 */
@property (assign, nonatomic) CGFloat cornerRadius;



/**
 The message font. Default is `[UIFont systemFontOfSize:16.0]`.
 */
@property (strong, nonatomic) UIFont *messageFont;


/**
 The message text alignment. Default is `NSTextAlignmentLeft`.
 */
@property (assign, nonatomic) NSTextAlignment messageAlignment;

#pragma mark 阴影

/**
 Enable or disable a shadow on the toast view. Default is `NO`.
 */
@property (assign, nonatomic) BOOL displayShadow;

/**
 The shadow color. Default is `[UIColor blackColor]`.
 */
@property (strong, nonatomic) UIColor *shadowColor;

/**
 A value from 0.0 to 1.0, representing the opacity of the shadow.
 Default is 0.8 (80% opacity).
 */
@property (assign, nonatomic) CGFloat shadowOpacity;

/**
 The shadow radius. Default is 6.0.
 */
@property (assign, nonatomic) CGFloat shadowRadius;

/**
 The shadow offset. The default is `CGSizeMake(4.0, 4.0)`.
 */
@property (assign, nonatomic) CGSize shadowOffset;

#pragma mark 时间
//消失动画持续时间.
@property (assign, nonatomic) NSTimeInterval fadeDuration;
//显示动画持续时间.
@property (nonatomic,assign)NSTimeInterval showDuration;

#pragma mark flag

//在显示activity的时候,是否加一个保护层
@property (nonatomic,assign)BOOL isProtectedWhenActivityViewIsShown;
//activityView是否显示GAToastStyle中配置的样式.
@property (nonatomic,assign)BOOL isActivityViewUseCenterAppearanceStyle;
@property (assign, nonatomic) BOOL shouldDismissWhenTapped;
@property (assign, nonatomic) BOOL shouldShowMessageInQueue;

//activityView是否显示文字
@property(assign,nonatomic) BOOL shouldActivityViewShowText;
@property(nonatomic,strong) NSString *activityViewText;

#pragma mark 位置
//toast的位置关系
@property (nonatomic,assign)GAToastPosition position;
//toast的具体中心点.
@property (nonatomic,assign)NSValue *centerPoint;

+ (instancetype)defaultStyle;

//更新默认值
+(void)updateDefaultShowDuration:(NSInteger)defaultShowDuration;
+(void)updateDefaultFadeDuration:(NSInteger)defaultFadeDuration;
+(void)updateDefaultShouldDismissWhenTapped:(BOOL)shouldDismissWhenTapped;
+(void)updateDefaultShouldShowMessageInQueue:(BOOL)shouldShowMessageInQueue;

@end
