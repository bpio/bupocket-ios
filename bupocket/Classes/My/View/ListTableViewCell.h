//
//  MyListViewCell.h
//  bupocket
//
//  Created by bupocket on 2018/10/17.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface ListTableViewCell : UITableViewCell

typedef NS_ENUM(NSInteger, CellType) {
    CellTypeDefault, // 图片，文字，文字/箭头
    CellTypeDetail, // 图片，文字，文字，箭头
    CellTypeNormal, // 图片，文字，箭头 圆角
    CellTypeChoice, // 文字，图片
    CellTypeWalletDetail, // 文字，图片/文字，箭头 圆角
    CellTypeID, // 文字，图片 文字 圆角
    CellTypeVoucher // 文字 图片 文字 箭头
};

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(CellType)cellType;

@property (nonatomic, strong) UIView * listBg;
@property (nonatomic, strong) UIImageView * listImage;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * detailTitle;
@property (nonatomic, strong) UIButton * detail;
@property (nonatomic, strong) UIView * lineView;

@end

NS_ASSUME_NONNULL_END
