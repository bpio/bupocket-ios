//
//  ModifyIconCollectionViewCell.m
//  bupocket
//
//  Created by bupocket on 2019/6/25.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "ModifyIconCollectionViewCell.h"

@implementation ModifyIconCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_icon];
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_selectBtn];
        _selectBtn.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat iconW = (DEVICE_WIDTH - ScreenScale(130)) / 5 - Margin_5;
    CGSize iconSize = CGSizeMake(iconW, iconW);
    [self.icon setViewSize:iconSize borderRadius:MAIN_CORNER corners:UIRectCornerAllCorners];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.size.mas_equalTo(iconSize);
    }];
    [_selectBtn setImage:[UIImage imageNamed:@"wallet_icon_s"] forState:UIControlStateNormal];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
    }];
    //    CGFloat width = self.tz_width / 3.0;
    //    _videoImageView.frame = CGRectMake(width, width, width, width);
}

@end
