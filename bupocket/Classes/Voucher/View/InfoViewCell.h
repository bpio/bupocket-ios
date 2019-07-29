//
//  InfoViewCell.h
//  bupocket
//
//  Created by huoss on 2019/7/22.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoViewCell : UITableViewCell

typedef NS_ENUM(NSInteger, CellType) {
    CellTypeDefault,
    CellTypeNormal // 卡牌
};

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(CellType)cellType;

@property (nonatomic, strong) UIButton * info;
@property (nonatomic, strong) NSString * infoStr;

@end

NS_ASSUME_NONNULL_END
