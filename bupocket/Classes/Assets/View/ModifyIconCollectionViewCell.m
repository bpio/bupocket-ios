//
//  ModifyIconCollectionViewCell.m
//  bupocket
//
//  Created by huoss on 2019/6/25.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "ModifyIconCollectionViewCell.h"

@implementation ModifyIconCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _icon = [[UIImageView alloc] init];
        [self.contentView addSubview:_icon];
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_selectBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize iconSize = CGSizeMake(Margin_50, Margin_50);
    [self.icon setViewSize:iconSize borderRadius:MAIN_CORNER corners:UIRectCornerAllCorners];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(Margin_5);
//        make.left.equalTo(self.contentView.mas_left).offset(Margin_5);
        make.centerX.bottom.equalTo(self.contentView);
        make.size.mas_equalTo(iconSize);
    }];
    [_selectBtn setImage:[UIImage imageNamed:@"wallet_icon_s"] forState:UIControlStateNormal];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
//        make.size.mas_equalTo
    }];
    //    CGFloat width = self.tz_width / 3.0;
    //    _videoImageView.frame = CGRectMake(width, width, width, width);
}

@end
