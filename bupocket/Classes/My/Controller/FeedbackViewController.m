//
//  FeedbackViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "FeedbackViewController.h"
#import "PlaceholderTextView.h"
#import "TextFieldViewCell.h"

@interface FeedbackViewController ()<UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) PlaceholderTextView * feedbackText;
@property (nonatomic, strong) UITextField * contactField;

@property (nonatomic, strong) UIButton * submit;
@property (nonatomic, strong) NSString * feedback;
@property (nonatomic, strong) NSString * contact;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"Feedback");
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, Margin_50 + TextViewH)];
    
    UILabel * feedbackTitle = [UILabel createTitleLabel];
    feedbackTitle.text = Localized(@"QuestionsOrSuggestions");
    [headerView addSubview:feedbackTitle];
    
    self.feedbackText = [PlaceholderTextView createPlaceholderTextView:headerView Target:self placeholder:Localized(@"PleaseEnterQOrS")];
    
    [feedbackTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(Margin_Main);
        make.left.equalTo(headerView.mas_left).offset(Margin_Main);
        make.right.equalTo(headerView.mas_right).offset(-Margin_Main);
    }];
    [self.feedbackText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedbackTitle.mas_bottom).offset(Margin_Main);
    }];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    self.submit = [UIButton createFooterViewWithTitle:Localized(@"Submission") isEnabled:NO Target:self Selector:@selector(submitAction)];
    /*
    NSArray * array = @[Localized(@"QuestionsOrSuggestions"), Localized(@"YourContact")];
    for (NSInteger i = 0; i < array.count; i++) {
        UIView * titleView = [self setViewWithTitle:array[i]];
        [self.view addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(Margin_15 + (ScreenScale(170) * i));
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(MAIN_HEIGHT);
        }];
    }
    [self.view addSubview:self.feedbackText];
    [self.feedbackText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Margin_15 + MAIN_HEIGHT);
        make.left.equalTo(self.view.mas_left).offset(Margin_10);
        make.right.equalTo(self.view.mas_right).offset(-Margin_10);
        make.height.mas_equalTo(ScreenScale(120));
    }];
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINE_COLOR;
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedbackText.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(Margin_20);
        make.right.equalTo(self.view.mas_right).offset(-Margin_20);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    
    UITextField * textField = [[UITextField alloc] init];
    textField.textColor = TITLE_COLOR;
    textField.font = FONT(16);
    textField.placeholder = Localized(@"PleaseEnterContact");
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.delegate = self;
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(ScreenScale(55));
        make.left.right.equalTo(lineView);
        make.height.mas_equalTo(Margin_40);
    }];
    self.contactField = textField;
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LINE_COLOR;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom);
        make.left.right.equalTo(lineView);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    UIButton * submit = [UIButton createButtonWithTitle:Localized(@"Submission") isEnabled:NO Target:self Selector:@selector(submitAction)];
    [self.view addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-Margin_30 - SafeAreaBottomH);
        make.left.right.equalTo(lineView);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    self.submit = submit;
     */
}

- (void)submitAction
{
    if (self.feedback.length > SuggestionsContent_MAX) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"SuggestionsContentOverlength")];
        return;
    }
    if (self.contact.length > MAX_LENGTH) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"ContactOverlength")];
        return;
    }
    [[HTTPManager shareManager] getFeedbackDataWithContent:self.feedback contact:self.contact success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"SubmissionOfSuccess")];
            self.feedbackText.text = @"";
            self.contactField.text = @"";
            [self judgeHasText];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
    } failure:^(NSError *error) {
        
    }];
}
/*
- (PlaceholderTextView *)feedbackText
{
    if (!_feedbackText) {
        _feedbackText = [[PlaceholderTextView alloc] init];
        _feedbackText.placeholder = Localized(@"PleaseEnterQOrS");
        _feedbackText.delegate = self;
    }
    return _feedbackText;
}
 */
- (void)textViewDidChange:(UITextView *)textView
{
    [self judgeHasText];
    NSString * content = textView.text;
    if (content.length > SuggestionsContent_MAX) {
        NSString * contentText = [content substringToIndex:SuggestionsContent_MAX];
        [textView setText:contentText];
    }
}
//- (void)textChange:(UITextField *)textField
//{
//    [self judgeHasText];
//}
- (void)judgeHasText
{
    [self updateText];
    if (self.feedback.length > 0 && self.contact.length > 0) {
        self.submit.enabled = YES;
        self.submit.backgroundColor = MAIN_COLOR;
    } else {
        self.submit.enabled = NO;
        self.submit.backgroundColor = DISABLED_COLOR;
    }
}
- (void)updateText
{
    self.feedback = TrimmingCharacters(self.feedbackText.text);
    self.feedback = [self.feedback stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.contact = TrimmingCharacters(self.contactField.text);
}
//- (UIView *)setViewWithTitle:(NSString *)title
//{
//    UIView * viewBg = [[UIView alloc] init];
//    UILabel * header = [[UILabel alloc] init];
//    [viewBg addSubview:header];
//    header.attributedText = [Encapsulation attrTitle:title ifRequired:NO];
//    [header mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(viewBg);
//        make.left.equalTo(viewBg.mas_left).offset(Margin_20);
//        make.right.equalTo(viewBg.mas_right).offset(-Margin_20);
//    }];
//    return viewBg;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(90);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ContentInset_Bottom + NavBarH;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldViewCell * cell = [TextFieldViewCell cellWithTableView:tableView cellType: TextFieldCellDefault];
    cell.title.text = Localized(@"YourContact");
    cell.textField.placeholder = Localized(@"PleaseEnterContact");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contactField = cell.textField;
    cell.textChange = ^(UITextField * _Nonnull textField) {
        [self judgeHasText];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (string.length == 0) {
        return YES;
    }
    if (textField == _contactField) {
        if (str.length > MAX_LENGTH) {
            textField.text = [str substringToIndex:MAX_LENGTH];
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
