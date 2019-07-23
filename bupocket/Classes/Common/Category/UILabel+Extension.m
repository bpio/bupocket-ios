//
//  UILabel+Extension.m
//  bupocket
//
//  Created by bupocket on 2019/1/2.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "UILabel+Extension.h"
//#import <objc/runtime.h>

@implementation UILabel (Extension)

- (BOOL)copyable
{
    return [objc_getAssociatedObject(self, @selector(copyable)) boolValue];
}
- (void)setCopyable:(BOOL)copyable
{
    objc_setAssociatedObject(self, @selector(copyable),
                             [NSNumber numberWithBool:copyable], OBJC_ASSOCIATION_ASSIGN);
    if (copyable == YES) {
        [self addTapGestureRecognizer];
    } else {
        self.userInteractionEnabled = NO;
    }
}
- (void)addTapGestureRecognizer
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyAction)];
    [self addGestureRecognizer:tap];
}
- (BOOL)canBecomeFirstResponder
{
    return [objc_getAssociatedObject(self, @selector(copyable)) boolValue];
}
- (BOOL)canPerformAcrion:(SEL)action sender:(id)sender
{
    if (action == @selector(copyAction)) {
        return YES;
    }
    return NO;
}
- (void)copyAction
{
    [self resignFirstResponder];
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    if (self.text) {
        pastboard.string = self.text;
    } else {
        pastboard.string = self.attributedText.string;
    }
    [MBProgressHUD showTipMessageInWindow:Localized(@"Replicating")];
}
+ (UILabel *)createTitleLabel
{
    UILabel * label = [[UILabel alloc] init];
    label.textColor = COLOR_6;
    label.font = FONT_15;
    label.numberOfLines = 0;
    return label;
}
@end
