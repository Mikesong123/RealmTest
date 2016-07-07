//
//  Dog.h
//  RealmTest
//
//  Created by 高 on 16/7/7.
//  Copyright © 2016年 高. All rights reserved.
//

#import <Realm/Realm.h>

@interface Dog : RLMObject

@property NSString *name;
@property NSString   *picture;
@property NSInteger age;

//@property (readonly) RLMLinkingObjects *owners;

@end
