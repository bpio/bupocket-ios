//
//  BottomAlertView.m
//  bupocket
//
//  Created by huoss on 2019/6/18.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BottomAlertView.h"

@interface BottomAlertView()

@property (nonatomic, strong) NSArray * handlerArray;
@property (assign, nonatomic) HandlerType handlerType;

@property (nonatomic, strong) UIButton * cancelBtn;

@end

@implementation BottomAlertView

- (instancetype)initWithHandlerArray:(NSArray *)array handlerType:(HandlerType)handlerType handlerClick:(void (^)(UIButton * btn))handlerClick cancleClick:(void (^)(void))cancleClick
{
    self = [super init];
    if (self) {
        self.handlerArray = array;
        self.handlerType = handlerType;
        _handlerClick = handlerClick;
        _cancleClick = cancleClick;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = VIEWBG_COLOR;
    
    [self addSubview:self.cancelBtn];
    for (NSInteger i = 0; i < self.handlerArray.count; i++) {
        UIColor * textColor = TITLE_COLOR;
        if (self.handlerType == HandlerTypeNodeSettings && i == 0) {
            textColor = MAIN_COLOR;
        }
        UIButton * btn = [UIButton createButtonWithTitle:self.handlerArray[i] TextFont:FONT_15 TextNormalColor:textColor TextSelectedColor:textColor Target:self Selector:@selector(handlerBtnClick:)];
        btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset((Margin_50 + LINE_WIDTH) * i);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(Margin_50);
        }];
    }
    CGFloat viewBgH = (ScreenScale(55) + (Margin_50 + LINE_WIDTH) * self.handlerArray.count) + SafeAreaBottomH;
    self.frame = CGRectMake(0, DEVICE_HEIGHT - viewBgH, DEVICE_WIDTH, viewBgH);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-SafeAreaBottomH);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, Margin_50));
    }];
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton createButtonWithTitle:Localized(@"Cancel") TextFont:FONT_15 TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 Target:self Selector:@selector(cancleBtnClick)];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
    }
    return _cancelBtn;
}

- (void)cancleBtnClick {
    [self hideView];
    if (_cancleClick) {
        _cancleClick();
    }
}
- (void)handlerBtnClick:(UIButton *)button {
    [self hideView];
    if (_handlerClick) {
        _handlerClick(button);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
