//
//  Book.m
//  RealmTest
//
//  Created by 高 on 16/7/7.
//  Copyright © 2016年 高. All rights reserved.
//

#import "Book.h"

@implementation Book

+ (NSArray *)indexedProperties {
    return @[@"title"];
}

+ (NSString *)primaryKey {
  return @"id";
}

@end
