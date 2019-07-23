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
        self.font = FONT_13;
        self.textColor = TITLE_COLOR;
        self.placeholderColor = PLACEHOLDER_COLOR;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textDidChange
{
    [self setNeedsDisplay];
}
+ (PlaceholderTextView *)createPlaceholderTextView:(UIView *)superView Target:(id)target placeholder:(NSString *)placeholder
{
    PlaceholderTextView * textView = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(Margin_Main, 0, View_Width_Main, TextViewH)];
    textView.backgroundColor = VIEWBG_COLOR;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = MAIN_CORNER;
    textView.delegate = target;
    textView.placeholder = placeholder;
    [superView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(View_Width_Main);
        make.height.mas_equalTo(TextViewH);
    }];
    return textView;
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
