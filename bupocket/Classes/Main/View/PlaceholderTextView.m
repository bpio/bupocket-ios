//
//  PlaceholderTextView.m
//  tiantianhuigou
//
//  Created by 霍双双 on 17/3/6.
//  Copyright © 2017年 hyck. All rights reserved.
//

#import "PlaceholderTextView.h"

@implementation PlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    CGFloat x = ScreenScale(12);
    CGFloat w = ScreenScale(rect.size.width - 2 * x);
    CGFloat y = ScreenScale(8);
    CGFloat h = ScreenScale(rect.size.height - 2 * y);
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
}


@end
