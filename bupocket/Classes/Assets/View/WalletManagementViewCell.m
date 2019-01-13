//
//  WalletManagementViewCell.m
//  bupocket
//
//  Created by huoss on 2019/1/7.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "WalletManagementViewCell.h"

static NSString * const WalletManagementCellID = @"WalletManagementCellID";
static NSString * const WalletCellID = @"WalletCellID";

@implementation WalletManagementViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    WalletManagementViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WalletManagementViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.walletName];
        [self.contentView addSubview:self.walletAddress];
        if ([reuseIdentifier isEqualToString:WalletManagementCellID]) {
            [self.contentView addSubview:self.currentUse];
            [self.contentView addSubview:self.manage];
        } else if ([reuseIdentifier isEqualToString:WalletCellID]) {
            [self.contentView addSubview:self.detailImage];
            self.walletName.font = FONT(18);
        }
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.walletName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(Margin_20);
        make.left.equalTo(self.contentView.mas_left).offset(Margin_15);
        make.height.mas_equalTo(ScreenScale(18));
    }];
    if ([self.reuseIdentifier isEqualToString:WalletManagementCellID]) {
        [self.manage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-Margin_15);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(Margin_25);
        }];
        [self.currentUse mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.walletName.mas_right).offset(Margin_10);
            make.centerY.equalTo(self.walletName);
            make.height.mas_equalTo(Margin_20);
            make.right.mas_lessThanOrEqualTo(self.manage.mas_left).offset(-Margin_10);
        }];
        [self.currentUse setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    } else if ([self.reuseIdentifier isEqualToString:WalletCellID]) {
        [self.detailImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-Margin_20);
            make.centerY.equalTo(self.walletName);
        }];
        [self.walletName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_lessThanOrEqualTo(self.detailImage.mas_left).offset(-Margin_10);
        }];
        [self.detailImage setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    [self.walletAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.walletName);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_20);
        make.height.mas_equalTo(Margin_15);
    }];
    [self setViewSize:CGSizeMake(DEVICE_WIDTH - Margin_20, ScreenScale(85)) borderWidth:0 borderColor:nil borderRadius:BG_CORNER];
}
- (UILabel *)walletName
{
    if (!_walletName) {
        _walletName = [[UILabel alloc] init];
        _walletName.font = FONT(16);
        _walletName.textColor = TITLE_COLOR;
    }
    return _walletName;
}
- (UILabel *)walletAddress
{
    if (!_walletAddress) {
        _walletAddress = [[UILabel alloc] init];
        _walletAddress.font = FONT(15);
        _walletAddress.textColor = COLOR_9;
        _walletAddress.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _walletAddress;
}
- (UIButton *)currentUse
{
    if (!_currentUse) {
        _currentUse = [UIButton createButtonWithTitle:Localized(@"CurrentUse") TextFont:13 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:nil Selector:nil];
        _currentUse.layer.masksToBounds = YES;
        _currentUse.clipsToBounds = YES;
        _currentUse.layer.cornerRadius = MAIN_CORNER;
        _currentUse.contentEdgeInsets = UIEdgeInsetsMake(0, ScreenScale(4), 0, ScreenScale(4));
        _currentUse.backgroundColor = MAIN_COLOR;
    }
    return _currentUse;
}
- (UIButton *)manage
{
    if (!_manage) {
        _manage = [UIButton createButtonWithTitle:Localized(@"Manage") TextFont:15 TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(manageAction)];
        _manage.layer.masksToBounds = YES;
        _manage.clipsToBounds = YES;
        _manage.layer.cornerRadius = MAIN_CORNER;
        _manage.layer.borderColor = MAIN_COLOR.CGColor;
        _manage.layer.borderWidth = LINE_WIDTH;
        _manage.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_10, 0, Margin_10);
    }
    return _manage;
}
- (UIImageView *)detailImage
{
    if (!_detailImage) {
        _detailImage = [[UIImageView alloc] init];
        _detailImage.image = [UIImage imageNamed:@"list_arrow"];
    }
    return _detailImage;
}
- (void)manageAction
{
    if (self.manageClick) {
        self.manageClick();
    }
}
- (void)setWalletModel:(WalletModel *)walletModel
{
    _walletModel = walletModel;
    self.walletName.text = walletModel.walletName;
    self.walletAddress.text = [NSString stringEllipsisWithStr:walletModel.walletAddress];
    if ([self.reuseIdentifier isEqualToString:WalletManagementCellID]) {
        self.currentUse.hidden = ![walletModel.walletAddress isEqualToString:CurrentWalletAddress];
    }
}
- (void)setFrame:(CGRect)frame
{
    frame.origin.x = Margin_10;
    frame.size.width -= Margin_20;
    frame.origin.y += Margin_5;
    frame.size.height -= Margin_10;
    [super setFrame:frame];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end