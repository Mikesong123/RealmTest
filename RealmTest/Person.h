//
//  Person.h
//  RealmTest
//
//  Created by 高 on 16/7/7.
//  Copyright © 2016年 高. All rights reserved.
//

#import <Realm/Realm.h>
#import "Dog.h"

RLM_ARRAY_TYPE(Dog)
@interface Person : RLMObject

@property NSString             *name; //修改属性类型会崩溃
@property RLMArray<Dog *><Dog> *dogs;

@property (readonly) NSString *newname; // 只读属性将被自动忽略
@property NSString *firstName;
@property NSString *lastName;

@property NSInteger             index;
@property NSInteger             age;
@property NSString             *sex;

@property NSString *birthday; //由于 Realm 在自己的引擎内部有很好的语义解释系统，所以Objective‑C的许多属性特性将被忽略，如nonatomic, atomic, strong, copy和weak等。 因此为了避免误解，我们推荐您在编写数据模型的时候不要使用任何的属性特性。 当然，如果您已经设置了，在有RLMObject对象被写入 Realm 数据库前，这些特性会一直生效。 无论是否有RLMObject对象受到 Realm 管理，您为 getter 和 setter 自定义的命名都能正常工作。


//由于 Realm 对不同类型的数字采取了不同的存储格式，因此设置可空的数字属性必须是 RLMInt、RLMFloat、RLMDouble 或者 RLMBool 其中一个类型  内部转化
@end