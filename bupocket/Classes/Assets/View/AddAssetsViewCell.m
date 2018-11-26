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
        [self.contentView addSubview:self.listImage];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.detailTitle];
        [self.contentView addSubview:self.infoTitle];
        [self.contentView addSubview:self.addBtn];
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
        make.top.equalTo(self.contentView.mas_top).offset(Margin_15);
        make.width.height.mas_equalTo(Margin_40);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listImage);
        make.left.equalTo(self.listImage.mas_right).offset(Margin_15);
    }];
    [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(Margin_10);
        make.left.equalTo(self.title);
    }];
    [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailTitle.mas_bottom).offset(Margin_10);
        make.left.equalTo(self.title);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listImage);
        make.bottom.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_40, LINE_WIDTH));
    }];
    CGSize size = CGSizeMake(ScreenScale(53), Margin_25);
    [self.addBtn setViewSize:size borderWidth:0 borderColor:nil borderRadius:ScreenScale(2)];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detailTitle);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_20);
        make.size.mas_equalTo(size);
    }];
}
- (void)setSearchAssetsModel:(SearchAssetsModel *)searchAssetsModel
{
    _searchAssetsModel = searchAssetsModel;
    [_listImage sd_setImageWithURL:[NSURL URLWithString:searchAssetsModel.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _title.text = searchAssetsModel.assetCode;
    _detailTitle.text = searchAssetsModel.assetName;
    _infoTitle.text = searchAssetsModel.issuer;
    _addBtn.hidden = !searchAssetsModel.recommend;
    if (searchAssetsModel.recommend) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        self.addAssetsArray = [NSMutableArray arrayWithArray:[defaults objectForKey:self.addAssetsKey]];
        for (NSDictionary * dic in self.addAssetsArray) {
            if ([searchAssetsModel.assetCode isEqualToString:dic[@"assetCode"]] && [searchAssetsModel.issuer isEqualToString:dic[@"issuer"]]) {
                _addBtn.selected = YES;
                _addBtn.backgroundColor = WARNING_COLOR;
            } else {
                _addBtn.selected = NO;
                _addBtn.backgroundColor = MAIN_COLOR;
            }
        }
    }
}
- (UIImageView *)listImage
{
    if (!_listImage) {
        _listImage = [[UIImageView alloc] init];
        _listImage.image = [UIImage imageNamed:@"placeholder"];
        [_listImage setViewSize:CGSizeMake(Margin_40, Margin_40) borderWidth:LINE_WIDTH borderColor:LINE_COLOR borderRadius:Margin_20];
    }
    return _listImage;
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT(18);
        _title.textColor = TITLE_COLOR;
        _title.preferredMaxLayoutWidth = DEVICE_WIDTH - ScreenScale(95);
    }
    return _title;
}
- (UILabel *)detailTitle
{
    if (!_detailTitle) {
        _detailTitle = [[UILabel alloc] init];
        _detailTitle.font = FONT(16);
        _detailTitle.textColor = TITLE_COLOR;
        _detailTitle.preferredMaxLayoutWidth = DEVICE_WIDTH - ScreenScale(160);
    }
    return _detailTitle;
}
- (UILabel *)infoTitle
{
    if (!_infoTitle) {
        _infoTitle = [[UILabel alloc] init];
        _infoTitle.font = TITLE_FONT;
        _infoTitle.textColor = COLOR_9;
        _infoTitle.preferredMaxLayoutWidth = DEVICE_WIDTH - ScreenScale(95);
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
- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton createButtonWithTitle:Localized(@"Add") TextFont:14 TextColor:[UIColor whiteColor] Target:self Selector:@selector(addAction:)];
        [_addBtn setTitle:Localized(@"Delete") forState:UIControlStateSelected];
        _addBtn.backgroundColor = MAIN_COLOR;
    }
    return _addBtn;
}
- (void)addAction:(UIButton *)button
{
    button.selected = !button.selected;
    NSDictionary * assetsDic = @{
                                 @"assetCode" : _searchAssetsModel.assetCode,
                                 @"issuer" : _searchAssetsModel.issuer
                                 };
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.addAssetsArray = [NSMutableArray arrayWithArray:[defaults objectForKey:self.addAssetsKey]];
    if (button.selected == YES) {
        button.backgroundColor = WARNING_COLOR;
        [self.addAssetsArray addObject:assetsDic];
    } else {
        button.backgroundColor = MAIN_COLOR;
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
