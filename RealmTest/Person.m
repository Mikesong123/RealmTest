//
//  Person.m
//  RealmTest
//
//  Created by 高 on 16/7/7.
//  Copyright © 2016年 高. All rights reserved.
//

#import "Person.h"

//实现方法内所有方法可不重写，重写后修改不正确，会破坏数据结构，闪退

@implementation Person

//设置必须属性，实例设置nil讲抛出异常
+ (NSArray *)requiredProperties {
    return @[@"name"];
}
//索引属性   Realm 支持字符串、整数、布尔值以及 NSDate 属性作为索引。
+ (NSArray *)indexedProperties {
    return @[@"title"];
}
// 属性默认值
+ (NSDictionary *)defaultPropertyValues {
    return @{@"age" : @0, @"sex": @""};
}

//设置主键会提高搜索效率，但是不能修改，否则会破坏数据结构，闪退。 1，设置主键后，相同主键的数据会被后面的数据覆盖。2，如果主键设置错误，需要重新写类，替换掉现有的类 3,卸载重装

//+ (NSString *)primaryKey {
//    return @"index";
//}

//忽略属性
+ (NSArray *)ignoredProperties {
    return @[@"tmpID"];
}

- (NSString *)newname {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
