//
//  AddAssetsViewCell.m
//  bupocket
//
//  Created by bupocket on 2018/10/25.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AddAssetsViewCell.h"

@interface AddAssetsViewCell()

@property (nonatomic, strong) NSMutableArray * addAssetsArray;
@property (nonatomic, strong) NSString * addAssetsKey;

@end

@implementation AddAssetsViewCell

static NSString * const AddAssetsCellID = @"AddAssetsCellID";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    AddAssetsViewCell * cell = [tableView dequeueReusableCellWithIdentifier:AddAssetsCellID];
    if (cell == nil) {
        cell = [[AddAssetsViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AddAssetsCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:If_Switch_TestNetwork]) {
            self.addAssetsKey = Add_Assets_Test;
        } else {
            self.addAssetsKey = Add_Assets;
        }
        [self.contentView addSubview:self.listImageBg];
        [self.contentView addSubview:self.listImage];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.detailTitle];
        [self.contentView addSubview:self.infoTitle];
        [self.contentView addSubview:self.switchControl];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}
- (NSMutableArray *)addAssetsArray
{
    if (!_addAssetsArray) {
        _addAssetsArray = [NSMutableArray array];
    }
    return _addAssetsArray;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_20);
        make.top.equalTo(self.contentView.mas_top).offset(Margin_20);
        make.width.height.mas_equalTo(Margin_50);
    }];
    [self.listImageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.listImage);
        make.width.height.mas_equalTo(ScreenScale(68));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listImage);
        make.left.equalTo(self.listImage.mas_right).offset(Margin_15);
        make.right.mas_lessThanOrEqualTo(self.switchControl.mas_left).offset(-Margin_10);
    }];
    [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(Margin_10);
        make.left.equalTo(self.title);
        make.right.mas_lessThanOrEqualTo(self.switchControl.mas_left).offset(-Margin_10);
    }];
    [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailTitle.mas_bottom).offset(Margin_10);
        make.left.equalTo(self.title);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listImage);
        make.top.equalTo(self.infoTitle.mas_bottom).offset(Margin_15);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_40, LINE_WIDTH));
    }];
    [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.listImage);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_20);
        make.left.mas_greaterThanOrEqualTo(self.detailTitle.mas_right).offset(Margin_10);
    }];
}
- (void)setSearchAssetsModel:(SearchAssetsModel *)searchAssetsModel
{
    _searchAssetsModel = searchAssetsModel;
    [_listImage sd_setImageWithURL:[NSURL URLWithString:searchAssetsModel.icon] placeholderImage:[UIImage imageNamed:@"placeholder_list"]];
    _title.text = searchAssetsModel.assetCode;
    _detailTitle.text = searchAssetsModel.assetName;
    _infoTitle.text = searchAssetsModel.issuer;
    // 0-Recommendation (Hide) 1-Non-Recommendation (Display)
    self.switchControl.hidden = !searchAssetsModel.recommend;
    if (searchAssetsModel.recommend) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        self.addAssetsArray = [NSMutableArray arrayWithArray:[defaults objectForKey:self.addAssetsKey]];
        for (NSDictionary * dic in self.addAssetsArray) {
            if ([searchAssetsModel.assetCode isEqualToString:dic[@"assetCode"]] && [searchAssetsModel.issuer isEqualToString:dic[@"issuer"]]) {
                [self.switchControl setOn:YES];
            } else {
                [self.switchControl setOn:NO];
            }
        }
    }
    [self layoutIfNeeded];
    CGFloat lineViewY = CGRectGetMaxY(self.lineView.frame);
    searchAssetsModel.cellHeight = lineViewY;
//    CGFloat titleW = DEVICE_WIDTH - (ScreenScale(53) + Margin_30 + ScreenScale(85));
//    CGFloat infoW = DEVICE_WIDTH - (Margin_20 + ScreenScale(85));
//    searchAssetsModel.cellHeight = Margin_20 + [Encapsulation rectWithText:_title.text font:_title.font textWidth:titleW].size.height + Margin_10 + [Encapsulation rectWithText:_detailTitle.text font:_detailTitle.font textWidth:titleW].size.height + Margin_10 + [Encapsulation rectWithText:_infoTitle.text font:_infoTitle.font textWidth:infoW].size.height + Margin_15;
}
- (UIImageView *)listImageBg
{
    if (!_listImageBg) {
        _listImageBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_bg_list"]];
    }
    return _listImageBg;
}
- (UIImageView *)listImage
{
    if (!_listImage) {
        _listImage = [[UIImageView alloc] init];
        [_listImage setViewSize:CGSizeMake(Margin_50, Margin_50) borderWidth:0 borderColor:nil borderRadius:Margin_25];
    }
    return _listImage;
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT(18);
        _title.textColor = TITLE_COLOR;
    }
    return _title;
}
- (UILabel *)detailTitle
{
    if (!_detailTitle) {
        _detailTitle = [[UILabel alloc] init];
        _detailTitle.font = FONT(16);
        _detailTitle.textColor = TITLE_COLOR;
        _detailTitle.numberOfLines = 0;
    }
    return _detailTitle;
}
- (UILabel *)infoTitle
{
    if (!_infoTitle) {
        _infoTitle = [[UILabel alloc] init];
        _infoTitle.font = TITLE_FONT;
        _infoTitle.textColor = COLOR_9;
        _infoTitle.numberOfLines = 0;
    }
    return _infoTitle;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LINE_COLOR;
    }
    return _lineView;
}
- (UISwitch *)switchControl
{
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc] init];
        [_switchControl addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
//        [_switchControl setOn:[[NSUserDefaults standardUserDefaults] boolForKey:If_Switch_TestNetwork] animated:YES];
    }
    return _switchControl;
}
- (void)switchChange:(UISwitch *)sender
{
    sender.on = !sender.on;
    NSDictionary * assetsDic = @{
                                 @"assetCode" : _searchAssetsModel.assetCode,
                                 @"issuer" : _searchAssetsModel.issuer
                                 };
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.addAssetsArray = [NSMutableArray arrayWithArray:[defaults objectForKey:self.addAssetsKey]];
    if (sender.isOn == YES) {
        [self.addAssetsArray addObject:assetsDic];
    } else {
        [self.addAssetsArray removeObject:assetsDic];
    }
    [defaults setObject:self.addAssetsArray forKey:self.addAssetsKey];
    [defaults synchronize];
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
