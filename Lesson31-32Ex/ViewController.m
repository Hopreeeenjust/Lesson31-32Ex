//
//  ViewController.m
//  Lesson31-32Ex
//
//  Created by Hopreeeeenjust on 23.01.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *countryNamesArray;
@property (strong, nonatomic) NSArray *countryRanksArray;
@property (strong, nonatomic) NSMutableArray *alliances;
@end

BOOL isEditing;
BOOL breakFlag;
BOOL maxItems;
BOOL countryInAlliance;

@implementation ViewController

#pragma mark - View

- (void)loadView {
    [super loadView];
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    self.tableView.editing = NO;
    isEditing = NO;
    breakFlag = NO;
    maxItems = NO;
    countryInAlliance = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.countryNamesArray = @[@"USA", @"China", @"Japan", @"Germany", @"France", @"United Kingdom", @"Brazil", @"Russia", @"Italy", @"India", @"Canada", @"Australia", @"Spain", @"South Korea", @"Mexico", @"Indonesia", @"Netherlands", @"Turkey", @"Saudi Arabia", @"Switzerland", @"Argentina", @"Sweden", @"Nigeria", @"Poland", @"Norway", @"Belarus", @"Ukraine", @"Kazakhstan", @"Costa Rica", @"Slovenia", @"Ghana", @"Tunisia", @"Lithuania", @"Ethiopia", @"Lebanon", @"Serbia", @"Turkmenistan", @"Panama", @"Yemen", @"Tanzania", @"Bahrain", @"Latvia", @"Bolivia", @"Cameroon", @"Paraguay", @"Zambia", @"Estonia", @"Gabon", @"Honduras", @"Brunei"];
    
    self.countryRanksArray = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16, @17, @18, @19, @20, @21, @22, @23, @24, @25, @67, @55, @45, @80, @81, @82, @83, @84, @85, @86, @87, @88, @89, @90, @92, @93, @95, @96, @98, @99, @101, @102, @107, @108, @110];
    
    self.alliances = [NSMutableArray array];
//    for (NSInteger i = 0; i < (arc4random_uniform(6) + 5); i++) {
//        RJAlliance *alliance = [RJAlliance new];
//        [self addNewCountriesToAlliance:alliance inQuantity:(arc4random_uniform(10) + 3)];
//        [self.alliances addObject:alliance];
//    }
    [self.tableView reloadData];
    
    self.navigationItem.title =@"World alliances";
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit:)];
    self.navigationItem.rightBarButtonItem = editButton;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    self.navigationItem.leftBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)actionEdit:(UIBarButtonItem *)sender {
    isEditing = self.tableView.editing;
    [self.tableView setEditing:!isEditing animated:YES];
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    if (self.tableView.editing) {
        isEditing = YES;
        item = UIBarButtonSystemItemDone;
        for (int i = 0; i < [self.alliances count]; i++) {
            RJAlliance *alliance = [self.alliances objectAtIndex:i];
            NSInteger newRowIndex = 0;
            [alliance.countries insertObject:[RJCountry new] atIndex:newRowIndex];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:newRowIndex inSection:i];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            [self.tableView endUpdates];
            [self performSelector:@selector(reloadCells) withObject:nil afterDelay:0.25f];
        }
    } else {
        isEditing = NO;
        for (int i = 0; i < [self.alliances count]; i++) {
            RJAlliance *alliance = [self.alliances objectAtIndex:i];
            NSInteger deleteRowIndex = 0;
            [alliance.countries removeObjectAtIndex:deleteRowIndex];
            [self.tableView beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:deleteRowIndex inSection:i];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            if ([alliance.countries count] == 0) {
                [self.alliances removeObject:alliance];
                [self.tableView beginUpdates];
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:i];
                [self.tableView deleteSections:set withRowAnimation:UITableViewRowAnimationBottom];
                [self.tableView endUpdates];
                i--;
            }
        }
    }
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(actionEdit:)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
}

- (void)actionAdd:(UIBarButtonItem *)sender {
    RJAlliance *alliance = [RJAlliance new];
    NSInteger minQuantity = 3;
    if (isEditing) {
        minQuantity = 4;
    }
    [self addNewCountriesToAlliance:alliance inQuantity:minQuantity];
    NSInteger sectionIndex = 0;
    [self.alliances insertObject:alliance atIndex:sectionIndex];
    [self.tableView beginUpdates];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:sectionIndex];
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.alliances count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *newName = [NSString stringWithFormat:@"Alliance #%ld", [self.alliances count] - section];
    return newName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.alliances objectAtIndex:section] countries] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isEditing && indexPath.row == 0) {
        static NSString *newCelldentifier = @"addNewCell";
        UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:newCelldentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newCelldentifier];
        }
        cell.textLabel.text = @"Add new country";
        cell.textLabel.textColor = [UIColor blueColor];
        return cell;
    } else {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        RJAlliance *alliance = [self.alliances objectAtIndex:indexPath.section];
        RJCountry *country = [alliance.countries objectAtIndex:indexPath.row];
        cell.textLabel.text = country.countryName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Rank: %ld", country.rank];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-Flag.ico", country.countryName]];
        cell.imageView.image = image;
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row > 0;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    RJAlliance *fromAlliance = [self.alliances objectAtIndex:sourceIndexPath.section];
    RJAlliance *toAlliance = [self.alliances objectAtIndex:destinationIndexPath.section];
    RJCountry *country = [fromAlliance.countries objectAtIndex:sourceIndexPath.row];
    if (sourceIndexPath.section == destinationIndexPath.section) {
        [fromAlliance.countries removeObjectAtIndex:sourceIndexPath.row];
        [fromAlliance.countries insertObject:country atIndex:destinationIndexPath.row];
    } else {
        NSMutableArray *tempArray = fromAlliance.countries;
        [tempArray removeObjectAtIndex:sourceIndexPath.row];
        [toAlliance.countries insertObject:country atIndex:destinationIndexPath.row];
        fromAlliance.countries = tempArray;
    }
    if (countryInAlliance) {
        [self showWarning];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RJAlliance *alliance = [self.alliances objectAtIndex:indexPath.section];
        NSInteger deleteRowIndex = indexPath.row;
        [alliance.countries removeObjectAtIndex:deleteRowIndex];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
        maxItems = NO;
    } else {
        RJAlliance *alliance = [self.alliances objectAtIndex:indexPath.section];
        [self addNewCountriesToAlliance:alliance inQuantity:1];
        [self.tableView beginUpdates];
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        if (!maxItems) {
            [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        }
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
        [self.tableView endUpdates];
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == 0) ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    countryInAlliance = NO;
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    } else if (proposedDestinationIndexPath.section == sourceIndexPath.section) {
        return proposedDestinationIndexPath;
    } else {
        RJAlliance *fromAlliance = [self.alliances objectAtIndex:sourceIndexPath.section];
        RJAlliance *toAlliance = [self.alliances objectAtIndex:proposedDestinationIndexPath.section];
        RJCountry *country = [fromAlliance.countries objectAtIndex:sourceIndexPath.row];
        for (int i = 1; i < [toAlliance.countries count]; i++) {
            RJCountry *countryInDestinationSection = [toAlliance.countries objectAtIndex:i];
            if ([countryInDestinationSection.countryName isEqualToString:country.countryName]) {
                countryInAlliance = YES;
                break;
            }
        }
        if (!countryInAlliance) {
            return proposedDestinationIndexPath;
        } else {
            return sourceIndexPath;
        }
    }
}

#pragma mark - Help methods

- (void)addNewCountriesToAlliance:(RJAlliance *)alliance inQuantity:(NSInteger)quantity {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.countryNamesArray];
    if ([alliance.countries count] == 0) {
        NSMutableArray *tempCountriesArray = [NSMutableArray array];
        for (NSInteger i = 0; i < quantity; i++) {
            RJCountry *country = [RJCountry new];
            NSInteger randomIndex = arc4random_uniform((int)[tempArray count]);
            NSString *name = [tempArray objectAtIndex:randomIndex];
            country.countryName = name;
            NSInteger realIndex = [self.countryNamesArray indexOfObject:name];
            country.rank = [[self.countryRanksArray objectAtIndex:realIndex] integerValue];
            [tempArray removeObjectAtIndex:randomIndex];
            [tempCountriesArray addObject:country];
        }
        alliance.countries = tempCountriesArray;
    } else {
        NSMutableArray *tempCountriesArray = [NSMutableArray arrayWithArray:alliance.countries];
        for (int i = 1; i < [alliance.countries count]; i++) {
            NSString *countryName = [[alliance.countries objectAtIndex:i] countryName];
            [tempArray removeObject:countryName];
        }
        for (NSInteger i = 0; i < quantity; i++) {
            RJCountry *country = [RJCountry new];
            NSInteger randomIndex = arc4random_uniform((int)[tempArray count]);
            [self checkAvailableItemsInArray:tempArray];
            if (breakFlag) {
                breakFlag = NO;
                break;
            }
            NSString *name = [tempArray objectAtIndex:randomIndex];
            country.countryName = name;
            NSInteger realIndex = [self.countryNamesArray indexOfObject:name];
            country.rank = [[self.countryRanksArray objectAtIndex:realIndex] integerValue];
            [tempArray removeObjectAtIndex:randomIndex];
            [tempCountriesArray insertObject:country atIndex:1];
        }
        alliance.countries = tempCountriesArray;
    }
}

- (void)checkAvailableItemsInArray:(NSArray *)array {
    maxItems = NO;
    if ([array count] == 0) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.tableView.bounds) - 300) / 2, (CGRectGetHeight(self.tableView.bounds) - 200 )/ 2, 300, 200)];
        textField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85f];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:textField];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(textField.bounds) - 220) / 2, (CGRectGetHeight(textField.bounds) - 160 )/ 2, 220, 160)];
        label.text = @"Sorry, but new members can not be taken into alliance";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85f];
        label.font = [UIFont fontWithName:@"Georgia-Italic" size:20.f];
        label.numberOfLines = 3;
        [textField addSubview:label];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [textField removeFromSuperview];
        });
        maxItems = YES;
        breakFlag = YES;
    }
}

- (void)showWarning {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.tableView.bounds) - 300) / 2, (CGRectGetHeight(self.tableView.bounds) - 200 )/ 2, 300, 200)];
    textField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85f];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(textField.bounds) - 220) / 2, (CGRectGetHeight(textField.bounds) - 160 )/ 2, 220, 160)];
    label.text = @"Sorry, but this alliance already contains selected country";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85f];
    label.font = [UIFont fontWithName:@"Georgia-Italic" size:20.f];
    label.numberOfLines = 3;
    [textField addSubview:label];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    [textField removeFromSuperview];
                });

}

- (void)reloadCells {
    for (int i = 0; i < [self.alliances count]; i++) {
        NSIndexSet *set2 = [NSIndexSet indexSetWithIndex:i];
        [self.tableView reloadSections:set2 withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
