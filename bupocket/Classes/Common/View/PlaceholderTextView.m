//
//  PlaceholderTextView.m
//  tiantianhuigou
//
//  Created by bupocket on 17/3/6.
//  Copyright © 2017年 hyck. All rights reserved.
//

#import "PlaceholderTextView.h"

@implementation PlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 使用textContainerInset设置top、left、right
        self.textContainerInset = UIEdgeInsetsMake(EDGEINSET_WIDTH, EDGEINSET_WIDTH, 0, EDGEINSET_WIDTH);
        //当光标在最后一行时，始终显示低边距，需使用contentInset设置bottom.
        self.contentInset = UIEdgeInsetsMake(0, 0, EDGEINSET_WIDTH, 0);
        //防止在拼音打字时抖动
        self.layoutManager.allowsNonContiguousLayout = NO;
        self.font = TITLE_FONT;
        self.textColor = COLOR_6;
        self.placeholderColor = PLACEHOLDER_COLOR;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textDidChange
{
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    if (self.hasText) return;
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    CGFloat x = Margin_15;
    CGFloat w = ScreenScale(rect.size.width - 2 * x);
    CGFloat y = EDGEINSET_WIDTH;
    CGFloat h = ScreenScale(rect.size.height - 2 * y);
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
}


@end
