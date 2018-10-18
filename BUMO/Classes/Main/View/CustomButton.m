//
//  CustomButton.m
//  BUMO
//
//  Created by bubi on 2018/10/17.
//  Copyright © 2018年 bubi. All rights reserved.
//

#import "CustomButton.h"
#import "UIView+Extension.h"

@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat buttonW = self.frame.size.width;
    CGFloat buttonH = self.frame.size.height;
    CGFloat imageW = self.imageView.frame.size.width;
    CGFloat imageH = self.imageView.frame.size.height;
    CGFloat titleH = self.titleLabel.frame.size.height;
    switch (self.layoutMode) {
        case HorizontalNormal:
            break;
    case HorizontalInverted:
            self.titleLabel.x = 0;
            self.imageView.x = self.titleLabel.width;
        /*
         // 用于设置控件的偏移位
         titleLabel?.frame.offsetBy(dx: -imageView!.frame.width, dy: 0)
         imageView?.frame.offsetBy(dx: titleLabel!.frame.width, dy: 0)
         */
            break;
    case VerticalNormal:
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.imageView.frame = CGRectMake((buttonW - imageW) / 2, ScreenScale(10), imageW, imageH);
            self.titleLabel.frame = CGRectMake(0, imageH + ScreenScale(10), buttonW, buttonH - imageH - ScreenScale(10));
            break;
    case VerticalInverted:
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.frame = CGRectMake(0, ScreenScale(10), buttonW, titleH);
            self.imageView.frame = CGRectMake((buttonW - imageW) / 2, titleH + ScreenScale(10), imageW, buttonH - titleH - ScreenScale(10));
            break;
    }
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    switch (self.layoutMode) {
        case HorizontalNormal:
            [super setTitle:[NSString stringWithFormat:@"  %@", title] forState:state];
            break;
        case HorizontalInverted:
            [super setTitle:[NSString stringWithFormat:@"%@  ", title] forState:state];
            break;
        default:
            [super setTitle:title forState:state];
            break;
    }
}

//+ (UIButton *)buttonWithLayoutMode:(LayoutMode)layoutMode title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(CGFloat)titleFont imageName:(NSString *)imageName target:(id)target action:(SEL)action btnTag:(int)btnTag
//{
//    UIButton * button = [[CustomButton alloc]init];
//    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    //    button.backgroundColor = [UIColor whiteColor];
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:titleColor forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:titleFont];
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    button.tag = btnTag;
//    return button;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
