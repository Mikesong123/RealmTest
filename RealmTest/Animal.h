//
//  Animal.h
//  RealmTest
//
//  Created by 高 on 16/7/7.
//  Copyright © 2016年 高. All rights reserved.
//

//模型继承

#import <Realm/Realm.h>

@interface Animal : RLMObject

@property NSInteger age;

@end
// 包含有 Animal 的模型
@interface Duck : RLMObject

@property Animal *animal;
@property NSString *name;

@end


@interface Frog : RLMObject

@property Animal *animal;
@property NSDate *dateProp;

@end
