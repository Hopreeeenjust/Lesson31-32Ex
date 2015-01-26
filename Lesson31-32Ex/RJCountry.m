//
//  RJCountry.m
//  Lesson31-32Ex
//
//  Created by Hopreeeeenjust on 23.01.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJCountry.h"

@implementation RJCountry

+(RJCountry *)randomCountryFromArray:(NSArray *)array {
//    NSArray *countryNamesArray = @[@"USA", @"China", @"Japan", @"Germany", @"France", @"United Kingdom", @"Brazil", @"Russia", @"Italy", @"India", @"Canada", @"Australia", @"Spain", @"South Korea", @"Mexico", @"Indonesia", @"Netherlands", @"Turkey", @"Saudi Arabia", @"Switzerland", @"Argentina", @"Sweden", @"Nigeria", @"Poland", @"Norway", @"Belarus", @"Ukraine", @"Kazakhstan", @"Costa Rica", @"Slovenia", @"Ghana", @"Tunisia", @"Lithuania", @"Ethiopia", @"Lebanon", @"Serbia", @"Turkmenistan", @"Panama", @"Yemen", @"Tanzania", @"Bahrain", @"Latvia", @"Bolivia", @"Cameroon", @"Paraguay", @"Zambia", @"Estonia", @"Gabon", @"Honduras", @"Brunei"];
    
    NSArray *countryRanksArray = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16, @17, @18, @19, @20, @21, @22, @23, @24, @25, @67, @55, @45, @80, @81, @82, @83, @84, @85, @86, @87, @88, @89, @90, @92, @93, @95, @96, @98, @99, @101, @102, @107, @108, @110];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
    
    RJCountry *country = [RJCountry new];
    NSInteger randomIndex = arc4random_uniform((int)[tempArray count]);
    country.countryName = [tempArray objectAtIndex:randomIndex];
    country.rank = [[countryRanksArray objectAtIndex:randomIndex] integerValue];
    [tempArray removeObjectAtIndex:randomIndex];

    return country;
}

@end
