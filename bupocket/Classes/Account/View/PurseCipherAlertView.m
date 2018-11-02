//
//  PurseCipherAlertView.m
//  bupocket
//
//  Created by bupocket on 2018/10/18.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "PurseCipherAlertView.h"

@interface PurseCipherAlertView()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * PWTextField;

@end

@implementation PurseCipherAlertView

- (instancetype)initWithConfrimBolck:(void (^)(NSString * password))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
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
        make.size.mas_equalTo(CGSizeMake(MAIN_HEIGHT, MAIN_HEIGHT));
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
    prompt.textColor = COLOR_6;
    prompt.text = Localized(@"PurseCipherPrompt");
    prompt.numberOfLines = 0;
    prompt.textAlignment = NSTextAlignmentCenter;
    [self addSubview:prompt];
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(Margin_10);
        make.left.equalTo(self).offset(Margin_25);
        make.right.equalTo(self).offset(-Margin_25);
    }];
    
    UITextField * PWTextField = [[UITextField alloc] init];
    PWTextField.delegate = self;
    PWTextField.textColor = TITLE_COLOR;
    PWTextField.font = FONT(14);
    PWTextField.placeholder = Localized(@"PWPlaceholder");
    PWTextField.layer.cornerRadius = ScreenScale(3);
    PWTextField.layer.borderColor = COLOR(@"E3E3E3").CGColor;
    PWTextField.layer.borderWidth = LINE_WIDTH;
    PWTextField.secureTextEntry = YES;
    PWTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_10, ScreenScale(50))];
    PWTextField.leftViewMode = UITextFieldViewModeAlways;
    PWTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_10, ScreenScale(50))];
    PWTextField.rightViewMode = UITextFieldViewModeAlways;
    [self addSubview:PWTextField];
    [PWTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(prompt.mas_bottom).offset(Margin_25);
        make.left.right.equalTo(prompt);
        make.height.mas_equalTo(ScreenScale(50));
    }];
    self.PWTextField = PWTextField;
    
    UIButton * sureBtn = [UIButton createButtonWithTitle:Localized(@"Confirm") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(sureBtnClick)];
    [self addSubview:sureBtn];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = ScreenScale(4);
    sureBtn.backgroundColor = MAIN_COLOR;
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-ScreenScale(27));
        make.left.right.equalTo(prompt);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    CGFloat height = [Encapsulation rectWithText:Localized(@"PurseCipherPrompt") fontSize:15 textWidth:DEVICE_WIDTH - ScreenScale(110)].size.height + ScreenScale(255);
    self.bounds = CGRectMake(0, 0, DEVICE_WIDTH - ScreenScale(60), height);
}

- (void)cancleBtnClick {
    [self hideView];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
- (void)sureBtnClick {
    [self hideView];
    if ([RegexPatternTool validatePassword:self.PWTextField.text] == NO) {
        [MBProgressHUD wb_showInfo:@"密码长度为8~20个字符，且内容仅限字母和数字"];
        return;
    }
    if (_sureBlock) {
        _sureBlock(self.PWTextField.text);
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
