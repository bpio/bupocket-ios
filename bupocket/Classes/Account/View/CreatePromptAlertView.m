//
//  CreatePromptAlertView.m
//  bupocket
//
//  Created by bupocket on 2018/10/18.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "CreatePromptAlertView.h"

@interface CreatePromptAlertView()

@end

@implementation CreatePromptAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = MAIN_CORNER;
    CustomButton * promptBtn = [[CustomButton alloc] init];
    promptBtn.layoutMode = VerticalNormal;
    promptBtn.titleLabel.font = FONT(21);
    [promptBtn setTitle:Localized(@"CreatePWPrompt") forState:UIControlStateNormal];
    [promptBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [promptBtn setImage:[UIImage imageNamed:@"CreatePrompt"] forState:UIControlStateNormal];
    [self addSubview:promptBtn];
    [promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(Margin_10);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(ScreenScale(120));
    }];
    
    NSString * warnStr = Localized(@"CreatePWWarn");
    NSString * infoStr = Localized(@"CreatePWInfo");
    NSString * titleStr = [NSString stringWithFormat:@"%@\n%@", warnStr, infoStr];
    UILabel * title = [UILabel new];
    title.numberOfLines = 0;
    title.attributedText = [Encapsulation attrWithString:titleStr preFont:FONT(15) preColor:WARNING_COLOR index:warnStr.length sufFont:FONT(15) sufColor:TITLE_COLOR lineSpacing:5];
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptBtn.mas_bottom);
        make.left.equalTo(self).offset(Margin_20);
        make.right.equalTo(self).offset(-Margin_20);
    }];
    
    UIButton * sureBtn = [UIButton createButtonWithTitle:Localized(@"Confirm") isEnabled:YES Target:self Selector:@selector(sureBtnClick)];
    [self addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-Margin_20);
        make.left.right.equalTo(title);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    CGFloat height = [Encapsulation getSizeSpaceLabelWithStr:titleStr font:FONT(15) width:(DEVICE_WIDTH - ScreenScale(90)) height:CGFLOAT_MAX lineSpacing:Margin_5].height + ScreenScale(230);
    self.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_40, height);
}

- (void)sureBtnClick {
    [self hideView];
}

@end
