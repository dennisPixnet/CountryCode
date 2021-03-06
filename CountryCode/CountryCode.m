//
//  CountryCode.m
//  CountryCode
//
//  Created by dennis on 2015/9/22.
//  Copyright © 2015年 dennis. All rights reserved.
//

#import "CountryCode.h"

@implementation CountryCode
@synthesize resultArray;
@synthesize countryDictionary;

+ (CountryCode *)sharedInstance
{
    static CountryCode *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[CountryCode alloc] init];
    });
    return _sharedInstance;
}
- (id)init{
    self = [super init];
    if (self) {
        resultArray = [[NSMutableArray alloc] initWithCapacity:0];
        countryDictionary = [[NSDictionary alloc] initWithDictionary:[self loadJsonFile]];
    }
    return self;
}
-(NSDictionary *) loadJsonFile{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"country_codes" ofType:@"json"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:nil];
    return jsonDic;
}
-(NSMutableArray *)searchCountryCodeWithKeyword:(NSString *)keyword{
    [resultArray removeAllObjects];
    NSDictionary *allCountry = [countryDictionary objectForKey:@"country_code"];
    
    for (NSString *key in allCountry) {
        NSString *countryName = [allCountry objectForKey:key];
        NSRange range =[countryName rangeOfString:keyword];
        if (range.length) {
            NSLog(@"has keyword :%@",countryName);
            NSDictionary *tmpDic = [[NSDictionary alloc] initWithObjectsAndKeys:[[countryDictionary objectForKey:@"id_to_countrycode"] objectForKey:key], @"code", countryName, @"countryName", nil];
            [resultArray addObject:tmpDic];
        }
    }
    return resultArray;
}

@end
