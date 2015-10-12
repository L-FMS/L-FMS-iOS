//
//  LFWriteCommentViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFWriteCommentViewController.h"

@interface LFWriteCommentViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView ;
@property (weak, nonatomic) IBOutlet UITextField *placeHolderTextField ;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *enSureButton;

@end

@implementation LFWriteCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.textView.delegate = self ;
    self.placeHolderTextField.userInteractionEnabled = NO ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.placeHolderTextField.hidden = self.textView.text.length > 0 ;
    self.enSureButton.enabled = self.textView.text.length > 0 ;
    
}


#pragma mark - actions

- (IBAction)cancelButtonClicked:(id)sender {
    [self.textView resignFirstResponder] ;
    if ( [self.delegate respondsToSelector:@selector(viewControllerDidCancel:)]) {
        [self.delegate viewControllerDidCancel:self] ;
    }
}

- (IBAction)sendButtonClicked:(id)sender {
    [self.textView resignFirstResponder] ;
    if ( [self.delegate respondsToSelector:@selector(viewController:shouldSendComent:)]) {
        [self.delegate viewController:self shouldSendComent:self.textView.text] ;
    }
}

@end
