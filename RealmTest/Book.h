//
//  Book.h
//  RealmTest
//
//  Created by 高 on 16/7/7.
//  Copyright © 2016年 高. All rights reserved.
//

#import <Realm/Realm.h>

@interface Book : RLMObject

@property float price;
@property NSString *title;

@property NSString *id;

@end
