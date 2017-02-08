//
//  GATCDViewControleller.m
//  GAToastCategoryDemo
//
//  Created by GikkiAres on 2017/2/7.
//  Copyright © 2017年 GikkiAres. All rights reserved.
//

#import "GATCDViewControleller.h"
#import "UIView+GAToast.h"


@interface GATCDViewControleller ()
@property (nonatomic,strong) NSArray *arrTitle;

@end

@implementation GATCDViewControleller

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Toast";
        _arrTitle = @[@"Show message",@"Show message on top for 3 seconds",@"Make toast with a completion block",@"Show default activity View"];
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Events

- (void)handleTapToDismissToggled:(UISwitch *)sender {
    [GAToastStyle updateDefaultShouldDismissWhenTapped:sender.isOn];
}

- (void)handleQueueToggled:(UISwitch *)sender {
    [GAToastStyle updateDefaultShouldShowMessageInQueue:sender.isOn];
}

#pragma mark - UITableViewDelegate & Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return _arrTitle.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"SETTINGS";
    } else {
        return @"DEMOS";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                UISwitch *tapToDismissSwitch = [[UISwitch alloc] init];
                tapToDismissSwitch.onTintColor = [UIColor orangeColor];
                [tapToDismissSwitch addTarget:self action:@selector(handleTapToDismissToggled:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = tapToDismissSwitch;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            }
            cell.textLabel.text = @"Tap to Dismiss";
            [(UISwitch *)cell.accessoryView setOn:YES];
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                UISwitch *queueSwitch = [[UISwitch alloc] init];
                queueSwitch.onTintColor = [UIColor orangeColor];
                [queueSwitch addTarget:self action:@selector(handleQueueToggled:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = queueSwitch;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            }
            cell.textLabel.text = @"Queue Toast";
            [(UISwitch *)cell.accessoryView setOn:YES];
            return cell;
        }
    } else {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _arrTitle[indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self.navigationController.view gaShowMessage:@"Show message at default position with default duration"];
    }
    else if (indexPath.row == 1) {
        GAToastStyle *style = [GAToastStyle defaultStyle];
        style.position = GAToastPositionTop;
        style.showDuration = 3;
        [self.navigationController.view gaShowMessage:@"Show message at top with 3 secondes" style:style completion:nil];
        
    }
    else if (indexPath.row == 2) {
        //     Make toast with a title
        [self.navigationController.view gaShowMessage:@"Show message with completion show" completion:^(BOOL isFromTap) {
            [self.navigationController.view gaShowMessage:@"Completion"];
        }];
        
    }
    else if (indexPath.row == 3) {
    [self.navigationController.view gaShowActivity];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController.view gaHideActivity];
        });
    }
}

@end
