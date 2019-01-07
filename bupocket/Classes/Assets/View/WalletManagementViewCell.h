//
//  WalletManagementViewCell.h
//  bupocket
//
//  Created by huoss on 2019/1/7.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletManagementViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UILabel * walletName;
@property (nonatomic, strong) UILabel * walletAddress;
@property (nonatomic, strong) UIButton * currentUse;
@property (nonatomic, strong) UIButton * manage;

@property (nonatomic, copy) void (^manageClick)();

@property (nonatomic, strong) NSDictionary * walletDic;

@end

NS_ASSUME_NONNULL_END
