//
//  ACProgressHUD.m
//  ACProgressHUD
//
//  Created by Achilles on 16/8/1.
//  Copyright © 2016年 Achilles. All rights reserved.
//

#import "ACProgressHUD.h"
NSString * TOAST_COLOR = @"TOAST_COLOR";
NSString * BASE_COLOR = @"BASE_COLOR";

#define ACProgressHUD_ScreenWidth [UIScreen mainScreen].bounds.size.width //the screen width

/*delay time ,unit NSTimeInterval */
static CGFloat  apperDuration;//delay apperDuration until alpha = 1.0,default 0.3
static CGFloat  disapperDuration;//delay disapperDuration until alpha = 0.0,default 0.3
static CGFloat  showTime;//duration showTime alpha = 0.0,default 1.5

/*the distance of UI*/
static CGFloat  btnImageTxtMargin;//the margin between image to txt,default 15
static CGFloat  hudMaxHeight;//tht Max height of content (contain image and txt),default 50

static CGFloat  contentMargin;//the margin is the distance between to the nearest side,default 15.0
static CGFloat  contentCornerRadius;//content view cornerRadius,default 5.0

/*the size of loading view */
static CGSize  indicatorViewSize;//default {30,30}

static UIFont *  textFont;//tht txt. font
static UIColor *  textColor;//tht txt color

/*lock the screen */
static BOOL lockyScreen = NO;// change the value is yes,the screen is unvisable

static UIWindow * _window;

@implementation ACProgressHUD

+(void)load
{
    apperDuration = 0.3;
    disapperDuration = 0.3;
    showTime = 1.5;
    btnImageTxtMargin = 15;
    hudMaxHeight = 50;
    contentMargin = 15.0;
    contentCornerRadius = 5.0;
    indicatorViewSize = CGSizeMake(30, 30);
    textFont = [UIFont systemFontOfSize:15.0];
    textColor = [UIColor whiteColor];
//    hudToTop = [UIScreen mainScreen].bounds.size.height * 0.5 - 50;
    lockyScreen = NO;
}

+ (void)setToastBackgroundColor:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue andAlpha:(CGFloat)alpha
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSArray arrayWithObjects:@(red),@(green),@(blue),@(alpha), nil] forKey:TOAST_COLOR];
}

+ (void)setBackgroundColor:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue andAlpha:(CGFloat)alpha
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSArray arrayWithObjects:@(red),@(green),@(blue),@(alpha), nil] forKey:BASE_COLOR];
}

+ (UIWindow *)alterWindow:(CGFloat)hudToTop
{
    if(!_window)
    {
        CGRect frame = lockyScreen ? [UIScreen mainScreen].bounds : CGRectMake(0, hudToTop, ACProgressHUD_ScreenWidth, hudMaxHeight);
        _window = [[UIWindow alloc] initWithFrame:frame];
        _window.windowLevel = UIWindowLevelAlert;
        _window.alpha = 0.0;
        _window.hidden = NO;
    }
    return _window;
}

+ (void)toastScuess:(NSString *)message
{
    [ACProgressHUD toastMessage:message withImage:[UIImage imageNamed:@"ACProgressHUD.bundle/success"]];
}

+ (void)showScuess:(NSString *)message
{
    [ACProgressHUD showMessage:message withImage:[UIImage imageNamed:@"ACProgressHUD.bundle/success"]];
}

+ (void)showError:(NSString *)message
{
    [ACProgressHUD showMessage:message withImage:[UIImage imageNamed:@"ACProgressHUD.bundle/error"]];
}

+(void)showLoading
{
    [ACProgressHUD showLoading:@"正在加载..."];
}

+ (void)showLoading:(NSString *)message
{
    if (_window) return;
    
    [ACProgressHUD alterWindow:[UIScreen mainScreen].bounds.size.height * 0.5 - 50];
    
    UIView * view = [[UIView alloc] init];
    NSArray * arr = [[NSUserDefaults standardUserDefaults] valueForKey:BASE_COLOR];
    UIColor * color = [UIColor colorWithRed:[arr[0] floatValue]/255.0 green:[arr[1] floatValue]/255.0 blue:[arr[2] floatValue]/255.0 alpha:[arr[3] floatValue]];
    view.backgroundColor = color ? color : [UIColor blackColor];
    //文字最大宽度
    CGFloat maxViewWidth = ACProgressHUD_ScreenWidth - indicatorViewSize.width - contentMargin * 2;
    
    //计算字大小
    CGSize txtSize = [ACProgressHUD sizeWithText:message font:textFont maxSize:CGSizeMake(maxViewWidth, MAXFLOAT)];
    //计算内容宽高（包括活动指示器和文字）
    CGFloat contentWidth = txtSize.width + indicatorViewSize.width + contentMargin * 2;
    CGFloat contentHeight = MAX(txtSize.height, indicatorViewSize.height) + contentMargin * 2;
    
    CGFloat contentOriginY = contentHeight > hudMaxHeight ? 0 : (hudMaxHeight - contentHeight) * 0.5;
    
    view.frame = CGRectMake((ACProgressHUD_ScreenWidth - contentWidth) * 0.5, contentOriginY, contentWidth, contentHeight);
    // 文字
    UILabel *label = [[UILabel alloc] init];
    CGRect labelFrame = CGRectMake(indicatorViewSize.width + contentMargin, (contentHeight - txtSize.height) * 0.5, txtSize.width, txtSize.height);
    label.frame = labelFrame;
    label.numberOfLines = 0;
    label.font = textFont;
    label.text = message;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];

    // 菊花转
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicatorView startAnimating];
    CGRect indicatorViewFrame = CGRectMake(contentMargin,(contentHeight - indicatorViewSize.height) * 0.5,indicatorViewSize.width,indicatorViewSize.height);
    indicatorView.frame = indicatorViewFrame;
    [view addSubview:indicatorView];
    
    view.layer.cornerRadius = contentCornerRadius;
    view.clipsToBounds = YES;
    
    [_window addSubview:view];
    
    if (lockyScreen) view.center = _window.center;
    
    // 动画
    [UIView animateWithDuration:apperDuration animations:^{
        _window.alpha = 1.0;
    }];
}

+ (void)showSaving
{
    [ACProgressHUD showLoading:@"正在保存..."];
}

+ (void)showLoadingWithCustomMessage:(NSString *)message
{
    [ACProgressHUD showLoading:message];
}

+ (void)hide
{
    if (_window) {
        [UIView animateWithDuration:disapperDuration animations:^{
            _window.alpha = 0;
        } completion:^(BOOL finished) {
            _window = nil;
        }];
    }
}

+ (void)showMessage:(NSString *)message
{
    if (_window) return;
    [ACProgressHUD alterWindow:[UIScreen mainScreen].bounds.size.height * 0.5 - 50];
    // 文字
    UILabel *label = [[UILabel alloc] init];
    
    //文字最大宽度
    CGFloat maxTxtWidth = ACProgressHUD_ScreenWidth -contentMargin * 2;
    //计算字大小
    CGSize txtSize = [ACProgressHUD sizeWithText:message font:textFont maxSize:CGSizeMake(maxTxtWidth, MAXFLOAT)];
    //增加 margin
    CGSize contentSize = {txtSize.width + contentMargin * 2,txtSize.height + contentMargin * 2};
    
    label.frame = CGRectMake((ACProgressHUD_ScreenWidth - contentSize.width) * 0.5, (hudMaxHeight - contentSize.height) * 0.5, contentSize.width, contentSize.height);
    
    label.layer.cornerRadius = contentCornerRadius;
    label.clipsToBounds = YES;
    
    label.font = textFont;
    label.text = message;
    label.numberOfLines = 0;
    label.textColor = textColor;
    NSArray * arr = [[NSUserDefaults standardUserDefaults] valueForKey:BASE_COLOR];
    UIColor * color = [UIColor colorWithRed:[arr[0] floatValue]/255.0 green:[arr[1] floatValue]/255.0 blue:[arr[2] floatValue]/255.0 alpha:[arr[3] floatValue]];
    label.backgroundColor = color ? color : [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [_window addSubview:label];
    
    if (lockyScreen) label.center = _window.center;
    // 动画
    [ACProgressHUD animate];
}

+ (void)showMessage:(NSString *)message withImage:(UIImage *)image;
{
    if(_window)return;
    [ACProgressHUD alterWindow:[UIScreen mainScreen].bounds.size.height * 0.5 - 50];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];

    [btn setImage:image forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, btnImageTxtMargin, 0, 0);
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.font = textFont;
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setTitle:message forState:UIControlStateNormal];
    NSArray * arr = [[NSUserDefaults standardUserDefaults] valueForKey:BASE_COLOR];
    UIColor * color = [UIColor colorWithRed:[arr[0] floatValue]/255.0 green:[arr[1] floatValue]/255.0 blue:[arr[2] floatValue]/255.0 alpha:[arr[3] floatValue]];
    [btn  setBackgroundColor:color];
    
    //计算图片和文字尺寸大小
    CGSize imgSize = image.size;
    //文字最大宽度
    CGFloat maxTxtWidth = ACProgressHUD_ScreenWidth -contentMargin * 2 - imgSize.width - btnImageTxtMargin;
    
    CGSize txtSize = [ACProgressHUD sizeWithText:message font:textFont maxSize:CGSizeMake(maxTxtWidth, MAXFLOAT)];
    
    //计算按钮宽高
    CGFloat btnWidth = txtSize.width + btnImageTxtMargin + imgSize.width + contentMargin * 2;
    CGFloat btnHeight = MAX(imgSize.height, txtSize.height) + contentMargin * 2;
    
    btn.frame = CGRectMake((ACProgressHUD_ScreenWidth - btnWidth) * 0.5, (hudMaxHeight - btnHeight) * 0.5, btnWidth, btnHeight);
    btn.layer.cornerRadius = contentCornerRadius;
    btn.clipsToBounds = YES;
    [_window addSubview:btn];
    
    if (lockyScreen) btn.center = _window.center;
    
    [ACProgressHUD animate];
}

+ (void)toastMessage:(NSString *)message withImage:(UIImage *)image
{
    if(_window)return;
    [ACProgressHUD alterWindow:-50];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:image forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, btnImageTxtMargin, 0, 0);
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.font = textFont;
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setTitle:message forState:UIControlStateNormal];
    NSArray * arr = [[NSUserDefaults standardUserDefaults] valueForKey:TOAST_COLOR];
    UIColor * color = [UIColor colorWithRed:[arr[0] floatValue]/255.0 green:[arr[1] floatValue]/255.0 blue:[arr[2] floatValue]/255.0 alpha:[arr[3] floatValue]];
    [btn  setBackgroundColor:color];
    
    //计算图片和文字尺寸大小
    CGSize imgSize = image.size;
    //文字最大宽度
    CGFloat maxTxtWidth = ACProgressHUD_ScreenWidth -contentMargin * 2 - imgSize.width - btnImageTxtMargin;
    
    CGSize txtSize = [ACProgressHUD sizeWithText:message font:textFont maxSize:CGSizeMake(maxTxtWidth, MAXFLOAT)];
    
    //计算按钮宽高
//    CGFloat btnWidth = txtSize.width + btnImageTxtMargin + imgSize.width + contentMargin * 2;
    CGFloat btnHeight = MAX(imgSize.height, txtSize.height) + contentMargin * 2;
    
    btn.frame = CGRectMake(0, (hudMaxHeight - btnHeight) * 0.5, ACProgressHUD_ScreenWidth, btnHeight);
//    btn.layer.cornerRadius = contentCornerRadius;
//    btn.clipsToBounds = YES;
    [_window addSubview:btn];
    
    if (lockyScreen) btn.center = _window.center;
    
    [ACProgressHUD toastAnimate];
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (void)animate
{
    [UIView animateWithDuration:apperDuration animations:^{
        _window.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:disapperDuration delay:showTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _window.alpha = 0.0;
        } completion:^(BOOL finished) {
            _window = nil;
        }];
    }];
}

+ (void)toastAnimate
{
    [UIView animateWithDuration:apperDuration animations:^{
        _window.alpha = 1.0;
        _window.center = CGPointMake(ACProgressHUD_ScreenWidth * 0.5, 25);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:disapperDuration delay:showTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _window.center = CGPointMake(ACProgressHUD_ScreenWidth * 0.5, -25);
            _window.alpha = 0.0;
        } completion:^(BOOL finished) {
            _window = nil;
        }];
    }];
}
@end
