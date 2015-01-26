//
//  RJCountry.h
//  Lesson31-32Ex
//
//  Created by Hopreeeeenjust on 23.01.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJCountry : NSObject
@property (strong, nonatomic) NSString *countryName;
@property (assign, nonatomic) NSInteger rank;

+(RJCountry *)randomCountryFromArray:(NSArray *)array;
@end
