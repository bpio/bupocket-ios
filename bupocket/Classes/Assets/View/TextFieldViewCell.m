//
//  TextFieldViewCell.m
//  bupocket
//
//  Created by bupocket on 2019/1/10.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "TextFieldViewCell.h"

@implementation TextFieldViewCell

static NSString * const TextFieldCellID = @"TextFieldCellID";
static NSString * const TextFieldPWCellID = @"TextFieldPWCellID";

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    TextFieldViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TextFieldViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.line];
        if ([reuseIdentifier isEqualToString:TextFieldPWCellID]) {
            self.textField.secureTextEntry = YES;
            UIButton * ifSecure = [UIButton createButtonWithNormalImage:@"password_ciphertext" SelectedImage:@"password_visual" Target:self Selector:@selector(secureAction:)];
            ifSecure.frame = CGRectMake(0, 0, Margin_20, TEXTFIELD_HEIGHT);
            self.textField.rightView = ifSecure;
        }
        if (@available(iOS 11.0, *)) {
            self.textField.textContentType = UITextContentTypeName;
        }
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_15);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_15);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.line);
        make.bottom.equalTo(self.line.mas_top);
        make.height.mas_equalTo(ScreenScale(40));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.line);
        make.bottom.equalTo(self.textField.mas_top);
    }];
    
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT(15);
        _title.textColor = COLOR_6;
        _title.numberOfLines = 0;
    }
    return _title;
}
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = TITLE_COLOR;
        _textField.font = FONT(13);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.rightViewMode = UITextFieldViewModeAlways;
        [_textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
- (void)secureAction:(UIButton *)button
{
    button.selected = !button.selected;
    UITextField * textField = (UITextField *)button.superview;
    textField.secureTextEntry = !textField.secureTextEntry;
}
- (void)textChange:(UITextField *)textField
{
    if (self.textChange) {
        self.textChange(textField);
    }
}
- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
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
