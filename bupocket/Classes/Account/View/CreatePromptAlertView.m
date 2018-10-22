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
    self.layer.cornerRadius = ScreenScale(5);
    CustomButton * promptBtn = [[CustomButton alloc] init];
    promptBtn.layoutMode = VerticalNormal;
    promptBtn.titleLabel.font = FONT(21);
    [promptBtn setTitle:Localized(@"CreatePWPrompt") forState:UIControlStateNormal];
    [promptBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [promptBtn setImage:[UIImage imageNamed:@"CreatePrompt"] forState:UIControlStateNormal];
    [self addSubview:promptBtn];
    [promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(ScreenScale(10));
        make.centerX.equalTo(self);
        make.height.mas_equalTo(ScreenScale(120));
    }];
    
    NSString * warnStr = Localized(@"CreatePWWarn");
    NSString * infoStr = Localized(@"CreatePWInfo");
    NSString * titleStr = [NSString stringWithFormat:@"%@\n%@", warnStr, infoStr];
    UILabel * title = [UILabel new];
//    title.adjustsLetterSpacingToFitWidth = YES;
    title.numberOfLines = 0;
    title.attributedText = [Encapsulation attrWithString:titleStr preFont:FONT(15) preColor:COLOR(@"FF7272") index:warnStr.length sufFont:FONT(15) sufColor:TITLE_COLOR lineSpacing:ScreenScale(5)];
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptBtn.mas_bottom);
        make.left.equalTo(self).offset(ScreenScale(25));
        make.right.equalTo(self).offset(-ScreenScale(25));
    }];
    
    UIButton * sureBtn = [UIButton createButtonWithTitle:Localized(@"Confirm") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(sureBtnClick)];
    [self addSubview:sureBtn];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = ScreenScale(4);
    sureBtn.backgroundColor = MAIN_COLOR;
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-ScreenScale(22));
        make.left.right.equalTo(title);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    CGFloat height = [Encapsulation getSizeSpaceLabelWithStr:titleStr font:FONT(15) width:(DEVICE_WIDTH - ScreenScale(110)) height:CGFLOAT_MAX lineSpacing:ScreenScale(5)].height + ScreenScale(230);
    self.bounds = CGRectMake(0, 0, DEVICE_WIDTH - ScreenScale(60), height);
}

- (void)sureBtnClick {
    [self hideView];
}

@end
