//
//  FeedsRNViewController.m
//  ShopeeSG
//
//  Created by man on 11/26/20.
//  Copyright © 2020 garena. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"

#import "FeedsRNViewController.h"
#import "SHPRNConfigurator.h"
#import "SHPRNEventEmitterModule.h"

static NSString *const kCocoaDebugRNEventName = @"SSZFDebugCommandEvent";

@interface FeedsRNViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *clearButton;

@end

@implementation FeedsRNViewController

#pragma mark - tool
- (BOOL)isEmptyString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (((NSNull *) string == [NSNull null]) || (string == nil) ) {
        return YES;
    }
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[[SHPRNConfigurator sharedInstance] supportedEvents] containsObject:kCocoaDebugRNEventName]) {
        [[SHPRNConfigurator sharedInstance] addSupportedEvent:kCocoaDebugRNEventName];
    }
    
    self.title = @"RN通知";
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)]];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 200)];
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearButton.frame = CGRectMake(0, 200, UIScreen.mainScreen.bounds.size.width/2 - 0.5, 40);
    [self.clearButton setTitle:@"清空" forState:UIControlStateNormal];
    [self.clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(didClickClearButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearButton];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width/2 + 0.5, 200, UIScreen.mainScreen.bounds.size.width/2 - 0.5, 40);
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(didClickSendButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendButton];
    
    self.textView.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"CocoaDebug_RN_Search_Word"];
    [self textViewDidChange:self.textView];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if ([self isEmptyString:textView.text]) {
        self.sendButton.userInteractionEnabled = NO;
        self.sendButton.backgroundColor = [UIColor systemGrayColor];
    } else {
        self.sendButton.userInteractionEnabled = YES;
        self.sendButton.backgroundColor = [UIColor systemOrangeColor];
    }
    
    if ([textView.text length] > 0) {
        self.clearButton.userInteractionEnabled = YES;
        self.clearButton.backgroundColor = [UIColor systemOrangeColor];
    } else {
        self.clearButton.userInteractionEnabled = NO;
        self.clearButton.backgroundColor = [UIColor systemGrayColor];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.textView resignFirstResponder];
}

#pragma mark - target action
- (void)tapSelf {
    [self.textView resignFirstResponder];
}

- (void)didClickClearButton {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CocoaDebug_RN_Search_Word"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.textView.text = nil;
    [self textViewDidChange:self.textView];
}

- (void)didClickSendButton {
    NSString *string = self.textView.text;
    if ([self isEmptyString:string]) {
        return;
    }
    
    
    
    [[SHPRNEventEmitterModule sharedInstance] sendEventName:kCocoaDebugRNEventName parameters:@{@"name": string}];
    
    
    
    [self.textView resignFirstResponder];

    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"CocoaDebug_RN_Search_Word"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
//    [CocoaDebugSettings shared].logSelectIndex = 1;
//    [CocoaDebugSettings shared].tabBarSelectItem = 1;
//
//    CocoaDebugNavigationController *navi = (CocoaDebugNavigationController *)[self.tabBarController.viewControllers objectAtIndex:1];
//
//    for (UIViewController *vc in navi.viewControllers) {
//        if ([vc isKindOfClass:[LogViewController class]]) {
//            ((LogViewController *)vc).segmentedControl.selectedSegmentIndex = 1;
//            [(LogViewController *)vc segmentedControlAction:nil];
//            [(LogViewController *)vc didTapDown:nil];
//        }
//    }
//
//    self.tabBarController.selectedViewController = navi;
}

@end

#pragma clang diagnostic pop
