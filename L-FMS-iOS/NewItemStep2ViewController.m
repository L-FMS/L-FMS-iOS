//
//  NewItemStep2ViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/12.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "NewItemStep2ViewController.h"

#import "LFCommon.h"
#import "LFTapGestureRecognizer.h"

@interface NewItemStep2ViewController ()<UIAlertViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *addTagButton;

@property (nonatomic,strong) NSMutableArray *tags;
@property (nonatomic,strong) NSMutableArray *tagViews;
@property (weak, nonatomic) IBOutlet UIView *tagContainerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ensureButton;

@end

@implementation NewItemStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.addTagButton removeFromSuperview];
    [self.tagContainerView addSubview:self.addTagButton];
    [self.addTagButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        //10,15,56,30
        make.left.equalTo(self.tagContainerView.mas_left).with.offset(10.0f);
        make.top.equalTo(self.tagContainerView.mas_top).with.offset(15.0f);
        make.height.mas_equalTo(30.0f);
        make.width.mas_equalTo(56.0f);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.ensureButton.enabled = textView.text.length > 0;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *addedTag = textField.text;
        if (addedTag.length != 0) {
            [self addItemTag:addedTag];
        } else {
            [LFUtils alert:@"字数不能超过20字哦～"];
        }
    }
}


#pragma mark - actions 

- (IBAction)addTagButtonClicked:(id)sender {
    if (self.nameTextField.isFirstResponder) {
        [self.nameTextField resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addTagButtonClicked:sender];
        });
        return;
    }
    
    //弹出alertView
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"输入标签～不超过20字哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (IBAction)ensureButtonClicked:(id)sender {
    assert(self.item);
    self.item.name = self.nameTextField.text;
    self.item.tags = self.tags;
    self.item.user = [LFUser currentUser];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    //发通知，在上传
    [LFUtils showNetworkIndicator];
    [self.item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [LFUtils hideNetworkIndicator];
        if (succeeded) {
            QYDebugLog(@"发布物品成功");
            //发通知，上传完毕
        } else {
            QYDebugLog(@"发布物品失败 Error:[%@]",error);
            //发通知，上传失败
        }
    }];
    
}

- (void)addItemTag:(NSString *)itemTag {
    if (!itemTag || itemTag.length == 0) return;
    [self.tags addObject:itemTag];
    [self reloadTagViewData];
}

- (void)reloadTagViewData {
    
    [self.tagViews enumerateObjectsUsingBlock:^(UILabel *tagLabel, NSUInteger idx, BOOL *stop) {
        [tagLabel removeFromSuperview];
    }];
    self.tagViews = nil;
    
    NSMutableArray *m = [NSMutableArray array];
    NSMutableArray *cm = [NSMutableArray array];
    [m addObject:cm];
    
    //分组，一行少于20个字
    NSInteger len = 0;
    for (int i = 0; i < self.tags.count; i++) {
        NSString *tag = self.tags[i];
        if (len + tag.length <= 20) {
            [cm addObject:tag];
            len+=tag.length;
        } else {
            cm = [NSMutableArray array];
            [cm addObject:tag];
            [m addObject:cm];
            len = tag.length;
            
        }
    }
    
    //添加add按钮
    BOOL addAtLastLine;
    if (len + 8 <= 20)
        addAtLastLine = YES;
    else
        addAtLastLine = FALSE;
    
    
    //开始生成View
    NSMutableArray *labelsRect = [NSMutableArray array];
    
    NSUInteger lastLineLen;
    NSUInteger  lastLineTopDistance = 0;
    for (int i = 0; i < m.count; i++) {
        NSArray *cm = m[i];
        //计算字长度
        NSUInteger len = 0;
        for (int j = 0; j < cm.count; j++) {
            NSString *tag = cm[j];
            len += tag.length;
            lastLineLen = len;
        }
        
        if (i == m.count - 1 ) {
            //最后一行，
            if (addAtLastLine) {
                //算上8个字的长度
                len += 8;
            }
        }
        
        //生成一行
        NSMutableArray *labels = [NSMutableArray array];
        
        for (int j = 0; j < cm.count; j++) {
            NSString *tag = cm[j];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = tag;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12.0f];
            [label sizeToFit];
            [label.layer setCornerRadius:5.0f];
            [label.layer setBorderWidth:1.0f];
            [label.layer setBorderColor:[UIColor blackColor].CGColor];
            label.tag = self.tagViews.count;
            label.userInteractionEnabled = YES;
            LFTapGestureRecognizer *tapGes = [[LFTapGestureRecognizer alloc] init];
            [tapGes addTarget:self action:@selector(tagClicked:)];
            tapGes.tag = label.tag;
            [label addGestureRecognizer:tapGes];
            
            [self.tagContainerView addSubview:label];
            [self.tagViews addObject:label];
            [labels addObject:label];
        }
        
        //添加约束
        NSInteger topDistance = (i * (30 + 15)) + 15;
        lastLineTopDistance = topDistance;
        NSInteger lineTagsCount = labels.count;
        if (i == m.count - 1 && addAtLastLine) {
            lineTagsCount += 1;
        }
        
        [labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                //第一个约束是self.View
                
                [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.tagContainerView.mas_left).with.offset(10.0f);
                    make.height.mas_equalTo(30.0f);
                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                    double t = label.text.length / (double)len;
                    make.width.mas_equalTo((screenWidth - 10 * (lineTagsCount + 1)) * t); //.multipliedBy(t); //label.text.length/(CGFloat)len
                    make.top.equalTo(self.tagContainerView.mas_top).with.offset(topDistance);
                }];
                
            } else {
                //其他的是前一个View
                UILabel *left = labels[ idx - 1 ];
                [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(left.mas_right).with.offset(10.0f);
                    make.height.mas_equalTo(30.0f);
                    
                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                    double t = label.text.length / (double)len;
                    make.width.mas_equalTo((screenWidth - 10 * (lineTagsCount + 1)) * t);//.multipliedBy(t); //label.text.length/(CGFloat)len
                    make.top.equalTo(self.tagContainerView.mas_top).with.offset(topDistance);
                }];
            }
        }];
        
        [labelsRect addObject:labels];
    }
    //Labels添加完毕，添加AddButton
    if (addAtLastLine) {
        //添加在最后一行
        UILabel *left = [[labelsRect lastObject] lastObject];
        
        [self.addTagButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(left.mas_right).with.offset(10.0f);
            make.height.mas_equalTo(30.0f);
//            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//            make.width.mas_equalTo(screenWidth - 10*2).multipliedBy(8/lastLineLen);
            make.width.mas_equalTo(56.0f);
            make.top.equalTo(self.tagContainerView.mas_top).with.offset(lastLineTopDistance);
        }];
        
    } else {
        //新开一行
        lastLineTopDistance += 30 + 15;
        
        [self.addTagButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagContainerView.mas_left).with.offset(10.0f);
            make.height.mas_equalTo(30.0f);
            make.width.mas_equalTo(56.0f);
            make.top.equalTo(self.tagContainerView.mas_top).with.offset(lastLineTopDistance);
        }];
    }
}

- (void)tagClicked:(LFTapGestureRecognizer *)tapGes {
    [self.tags removeObjectAtIndex:tapGes.tag];
    [self reloadTagViewData];
}

#pragma mark - getter && setter 

- (NSMutableArray *)tags {
    return _tags ? : (_tags = [NSMutableArray array]);
}

- (NSMutableArray *)tagViews {
    return _tagViews ? : (_tagViews = [NSMutableArray array]);
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nameTextField resignFirstResponder];
}

@end
