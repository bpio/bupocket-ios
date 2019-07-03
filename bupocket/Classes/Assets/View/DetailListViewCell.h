//
//  DetailListViewCell.h
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DetailCellType) {
    DetailCellDefault, // DefaultDetailCellID 资产详情 左右
    DetailCellNormal, // NormalDetailCellID 资产详情 上下
    DetailCellResult, // ResultDetailCellID 登记、发行结果
    DetailCellSubtitle, // SubtitleDetailCellID 上下
    DetailCellVersionLog // VersionLogCellID
};

@interface DetailListViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(DetailCellType)cellType;

@property (nonatomic, strong) UIView * detailBg;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * infoTitle;

@end

NS_ASSUME_NONNULL_END
