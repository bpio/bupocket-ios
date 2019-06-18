//
//  MyListViewCell.h
//  bupocket
//
//  Created by bupocket on 2018/10/17.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CellType) {
    CellTypeDefault, // 图片，文字，文字/箭头
    CellTypeDetail, // 图片，文字，文字，箭头
    CellTypeNormal, // 图片，文字，箭头 圆角
    CellTypeChoice, // 文字，图片
    CellTypeWalletDetail // 文字，图片/文字，箭头 圆角
};

NS_ASSUME_NONNULL_BEGIN

@interface ListTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(CellType)cellType;

@property (nonatomic, strong) UIView * listBg;
@property (nonatomic, strong) UIImageView * listImage;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * detailTitle;
@property (nonatomic, strong) UIImageView * detailImage;
@property (nonatomic, strong) UIView * lineView;

@end

NS_ASSUME_NONNULL_END
