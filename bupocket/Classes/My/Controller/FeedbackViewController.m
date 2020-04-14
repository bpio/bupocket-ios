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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = LIST_BG_COLOR;
    self.tableView.tableHeaderView = headerView;
    
    self.submit = [UIButton createFooterViewWithTitle:Localized(@"Submission") isEnabled:NO Target:self Selector:@selector(submitAction)];
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
- (void)textViewDidChange:(UITextView *)textView
{
    [self judgeHasText];
    NSString * content = textView.text;
    if (content.length > SuggestionsContent_MAX) {
        NSString * contentText = [content substringToIndex:SuggestionsContent_MAX];
        [textView setText:contentText];
    }
}
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
