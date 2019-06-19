//
//  SubtitleListViewCell.m
//  bupocket
//
//  Created by huoss on 2019/6/19.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "SubtitleListViewCell.h"

@interface SubtitleListViewCell()

@property (nonatomic, assign) CGFloat walletImageWH;

@end

static NSString * const DefaultSubtitleCellID = @"DefaultSubtitleCellID";
static NSString * const ManageSubtitleCellID = @"ManageSubtitleCellID";
static NSString * const NormalSubtitleCellID = @"NormalSubtitleCellID";

@implementation SubtitleListViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(SubtitleCellType)cellType;
{
    NSString * identifier;
    if (cellType == SubtitleCellDefault) {
        identifier = DefaultSubtitleCellID;
    } else if (cellType == SubtitleCellManage) {
        identifier = ManageSubtitleCellID;
    } else if (cellType == SubtitleCellNormal) {
        identifier = NormalSubtitleCellID;
    }
    SubtitleListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SubtitleListViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.listBg];
        
        CGFloat borderRadius;
        NSString * walletImageName;
        if ([reuseIdentifier isEqualToString:NormalSubtitleCellID]) {
            self.walletImageWH = ScreenScale(70);
            borderRadius = self.walletImageWH * 0.5;
            walletImageName = @"user_icon_placeholder";
        } else {
            self.walletImageWH = Margin_30;
            borderRadius = MAIN_CORNER;
            walletImageName = @"wallet_list_placeholder";
            [self.listBg setViewSize:CGSizeMake(DEVICE_WIDTH - Margin_20, ScreenScale(85)) borderRadius:BG_CORNER corners:UIRectCornerAllCorners];
        }
        [self.listBg addSubview:self.walletImage];
        [self.listBg addSubview:self.walletName];
        [self.listBg addSubview:self.walletAddress];
        [self.listBg addSubview:self.currentUse];
        [self.listBg addSubview:self.manage];
        [self.listBg addSubview:self.detailImage];
        [_walletImage setViewSize:CGSizeMake(self.walletImageWH, self.walletImageWH) borderWidth:0 borderColor:nil borderRadius:borderRadius];
        _walletImage.image = [UIImage imageNamed:walletImageName];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat walletNameOffsetX = Margin_10;
    CGFloat walletNameOffsetY = 0;
    
    if ([self.reuseIdentifier isEqualToString:NormalSubtitleCellID]) {
        [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        walletNameOffsetX = Margin_20;
        walletNameOffsetY = Margin_10;
    } else {
        [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
            make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
            make.top.bottom.equalTo(self.contentView);
        }];
        self.contentView.backgroundColor = VIEWBG_COLOR;
    }
    
    [self.walletImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listBg.mas_top).offset(Margin_20);
        make.left.equalTo(self.listBg.mas_left).offset(Margin_15);
        make.size.mas_equalTo(CGSizeMake(self.walletImageWH, self.walletImageWH));
    }];
    [self.walletName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.walletImage.mas_top).offset(walletNameOffsetY);
        make.left.equalTo(self.walletImage.mas_right).offset(walletNameOffsetX);
        make.height.mas_equalTo(ScreenScale(18));
    }];
    if ([self.reuseIdentifier isEqualToString:DefaultSubtitleCellID]) {
        [self.manage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.listBg.mas_right).offset(-Margin_15);
            make.centerY.equalTo(self.listBg);
            make.height.mas_equalTo(Margin_25);
        }];
        if (self.currentUse.hidden == NO) {
            [self.currentUse mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.walletName.mas_right).offset(Margin_10);
                make.centerY.equalTo(self.walletName);
                make.height.mas_equalTo(Margin_20);
                make.right.mas_lessThanOrEqualTo(self.manage.mas_left).offset(-Margin_10);
            }];
            [self.currentUse setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        } else {
            [self.walletName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_lessThanOrEqualTo(self.manage.mas_left).offset(-Margin_10);
            }];
        }
        [self.manage setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.walletAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_lessThanOrEqualTo(self.manage.mas_left).offset(-Margin_10);
        }];
        
    } else {
        [self.detailImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.listBg.mas_right).offset(-Margin_20);
            make.centerY.equalTo(self.listBg);
        }];
//        if ([self.reuseIdentifier isEqualToString:ManageSubtitleCellID]) {
//            [self.detailImage mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            }];
//        } else if ([self.reuseIdentifier isEqualToString:NormalSubtitleCellID]) {
//            [self.detailImage mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(self.listBg);
//            }];
//        }
        [self.walletName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_lessThanOrEqualTo(self.detailImage.mas_left).offset(-Margin_10);
        }];
        [self.detailImage setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.walletAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_lessThanOrEqualTo(self.detailImage.mas_left).offset(-Margin_10);
        }];
    }
    
    [self.walletAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.walletName);
        make.top.equalTo(self.walletName.mas_bottom).offset(Margin_10);
//        make.bottom.equalTo(self.listBg.mas_bottom).offset(-Margin_20);
        make.height.mas_equalTo(ScreenScale(18));
    }];
//    [self setViewSize:CGSizeMake(DEVICE_WIDTH - Margin_20, ScreenScale(90)) borderWidth:0 borderColor:nil borderRadius:BG_CORNER];
}
- (UIView *)listBg
{
    if (!_listBg) {
        _listBg = [[UIView alloc] init];
        _listBg.backgroundColor = [UIColor whiteColor];
    }
    return _listBg;
}
- (UIImageView *)walletImage
{
    if (!_walletImage) {
        _walletImage = [[UIImageView alloc] init];
    }
    return _walletImage;
}
- (UILabel *)walletName
{
    if (!_walletName) {
        _walletName = [[UILabel alloc] init];
        _walletName.font = FONT_Bold(16);
        _walletName.textColor = TITLE_COLOR;
    }
    return _walletName;
}
- (UILabel *)walletAddress
{
    if (!_walletAddress) {
        _walletAddress = [[UILabel alloc] init];
        _walletAddress.font = FONT_TITLE;
        _walletAddress.textColor = COLOR_9;
        _walletAddress.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _walletAddress;
}
- (UIButton *)currentUse
{
    if (!_currentUse) {
        _currentUse = [UIButton createButtonWithTitle:Localized(@"CurrentUse") TextFont:FONT_13 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:nil Selector:nil];
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
        _manage = [UIButton createButtonWithTitle:Localized(@"Manage") TextFont:FONT_15 TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(manageAction)];
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
    self.walletAddress.text = [NSString stringEllipsisWithStr:walletModel.walletAddress subIndex:SubIndex_Address];
    if ([self.reuseIdentifier isEqualToString:DefaultSubtitleCellID]) {
        self.currentUse.hidden = ![walletModel.walletAddress isEqualToString:CurrentWalletAddress];
    }
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
