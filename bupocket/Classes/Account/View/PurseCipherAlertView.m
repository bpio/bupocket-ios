//
//  PurseCipherAlertView.m
//  bupocket
//
//  Created by bupocket on 2018/10/18.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "PurseCipherAlertView.h"

@interface PurseCipherAlertView()<UITextFieldDelegate>

@end

@implementation PurseCipherAlertView

- (instancetype)initWithFrame:(CGRect)frame confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = ScreenScale(5);
    
    UIButton * closeBtn = [UIButton createButtonWithNormalImage:@"close" SelectedImage:@"close" Target:self Selector:@selector(cancleBtnClick)];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(45), 45));
    }];
    
    UILabel * title = [UILabel new];
    title.font = FONT(27);
    title.textColor = TITLE_COLOR;
    title.text = Localized(@"PurseCipherConfirm");
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ScreenScale(35));
        make.centerX.equalTo(self);
    }];
    
    UILabel * prompt = [UILabel new];
    prompt.font = FONT(14);
    prompt.textColor = COLOR(@"666666");
    prompt.text = Localized(@"PurseCipherPrompt");
    [self addSubview:prompt];
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(ScreenScale(10));
        make.centerX.equalTo(self);
    }];
    
    UITextField * PWTextField = [[UITextField alloc] init];
    PWTextField.delegate = self;
    PWTextField.textColor = TITLE_COLOR;
    PWTextField.font = FONT(14);
    PWTextField.placeholder = Localized(@"PWPlaceholder");
    PWTextField.layer.cornerRadius = ScreenScale(3);
    PWTextField.layer.borderColor = COLOR(@"E3E3E3").CGColor;
    PWTextField.layer.borderWidth = ScreenScale(0.5);
    PWTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenScale(10), ScreenScale(50))];
    PWTextField.leftViewMode = UITextFieldViewModeAlways;
    PWTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenScale(10), ScreenScale(50))];
    PWTextField.rightViewMode = UITextFieldViewModeAlways;
    [self addSubview:PWTextField];
    [PWTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(prompt.mas_bottom).offset(ScreenScale(25));
        make.left.equalTo(self).offset(ScreenScale(25));
        make.right.equalTo(self).offset(-ScreenScale(25));
        make.height.mas_equalTo(ScreenScale(50));
    }];
    
    UIButton * sureBtn = [UIButton createButtonWithTitle:Localized(@"Confirm") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(sureBtnClick)];
    [self addSubview:sureBtn];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = ScreenScale(4);
    sureBtn.backgroundColor = MAIN_COLOR;
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-ScreenScale(27));
        make.left.right.equalTo(PWTextField);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}

- (void)cancleBtnClick {
    [self hideView];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
- (void)sureBtnClick {
    [self hideView];
    if (_sureBlock) {
        _sureBlock();
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
