//
//  PlaceholderTextView.h
//  tiantianhuigou
//
//  Created by bupocket on 17/3/6.
//  Copyright © 2017年 hyck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, strong) UIColor * placeholderColor;
+ (PlaceholderTextView *)createPlaceholderTextView:(UIView *)superView Target:(id)target placeholder:(NSString *)placeholder;

@end
