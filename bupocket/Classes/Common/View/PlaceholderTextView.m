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
        //  top、left、bottom、right
        self.textContainerInset = UIEdgeInsetsMake(EDGEINSET_WIDTH, EDGEINSET_WIDTH, 0, EDGEINSET_WIDTH);
        // When the cursor is on the last line, it always shows a low margin, so you need to use contentInset to set the bottom.
        self.contentInset = UIEdgeInsetsMake(0, 0, EDGEINSET_WIDTH, 0);
        //Prevent jitter in spelling and typing（防止在拼音打字时抖动）
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
