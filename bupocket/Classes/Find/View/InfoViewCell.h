//
//  InfoViewCell.h
//  bupocket
//
//  Created by bupocket on 2019/7/22.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InfoViewCell : UITableViewCell

typedef NS_ENUM(NSInteger, CellType) {
    CellTypeDefault,
    CellTypeNormal // 卡牌
};

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(CellType)cellType;

@property (nonatomic, strong) UIButton * info;
@property (nonatomic, strong) InfoModel * infoModel;

@end

NS_ASSUME_NONNULL_END
