//
//  SubtitleListViewCell.h
//  bupocket
//
//  Created by bupocket on 2019/6/19.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SubtitleListViewCell : UITableViewCell

typedef NS_ENUM(NSInteger, SubtitleCellType) {
    SubtitleCellDefault,
    SubtitleCellManage,
    SubtitleCellNormal,
    SubtitleCellDetail,
};

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(SubtitleCellType)cellType;

@property (nonatomic, strong) UIView * listBg;
@property (nonatomic, strong) UIImageView * walletImage;
@property (nonatomic, strong) UILabel * walletName;
@property (nonatomic, strong) UILabel * walletAddress;
@property (nonatomic, strong) UIButton * currentUse;
@property (nonatomic, strong) UIButton * manage;
@property (nonatomic, strong) UIImageView * detailImage;

@property (nonatomic, copy) void (^manageClick)(void);

@property (nonatomic, strong) WalletModel * walletModel;

@end

NS_ASSUME_NONNULL_END
