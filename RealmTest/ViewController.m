//
//  ViewController.m
//  RealmTest
//
//  Created by 高 on 16/7/6.
//  Copyright © 2016年 高. All rights reserved.
//

#import "ViewController.h"
#import "Realm.h"
#import "Dog.h"
#import "Person.h"
#import "Animal.h"
#import "Book.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self saveLocalData];//存数据
    [self readLocalData];//读本地数据
    [self modificationData];//修改数据
    [self deleteLocalData];//删除数据
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)creatRealmfile {
    NSString *ti = @"XXX";//自己创建名称
    NSString *title = [NSString stringWithFormat:@"%@.realm",ti];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingPathComponent:title];
    return dbPath;
}

- (void)readLocalData {
    // 获取当前事务 realm
    RLMRealm *realm1 = [RLMRealm defaultRealm];//设置读取自带默认文件
    RLMRealm *realm = [RLMRealm realmWithPath:[self creatRealmfile]];//设置读取自己指定文件，这个方法会新建，但是如果存在就不会新建。
    // 读取
    // 1
    RLMResults *results = [Dog allObjects];
    RLMResults *results2 = [Person allObjectsInRealm:realm];//读取指定文件
    RLMResults *results1 = [Dog allObjectsInRealm:realm];//读取指定文件
    
    if (results1.count != 0) {
        Person *person = results1[0];//通过循环取出所有数据
        //    NSLog(@"数量：%lu",(unsigned long)results1.count);
    }
    // 2
//    RLMResults<Dog *> *puppies = [Dog objectsWhere:@"age < 2"]; //
    RLMResults<Dog *> *puppies = [Dog objectsInRealm:realm where:@"age < 2"];
    
    // 3
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"age = %d AND name BEGINSWITH %@",
                         1, @"大"];
//    RLMResults *tanDogs = [Dog objectsWithPredicate:pred];
    RLMResults *tanDogs = [Dog objectsInRealm:realm withPredicate:pred];
    //4 排序 ascending 
    // 排序名字以“大”开头的棕黄色狗狗
    RLMResults<Dog *> *sortedDogs = [[Dog objectsWhere:@"age = 1 AND name BEGINSWITH '大'"]
                                     sortedResultsUsingProperty:@"name" ascending:YES]; //需要设定realm
    
    // 5 链式查询
    RLMResults<Dog *> *tanDogs1 = [Dog objectsWhere:@"age = 1"];
    RLMResults<Dog *> *tanDogsWithBNames = [tanDogs1 objectsWhere:@"name BEGINSWITH '大'"];
    //
    // 可以在任何一个线程中执行检索操作
    dispatch_async(dispatch_queue_create("background", 0), ^{
        Dog *theDog = [[Dog objectsWhere:@"age == 1"] firstObject];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        theDog.age = 3;
        [realm commitWriteTransaction];
    });
    
}

- (void)saveLocalData {
    RLMRealm *realm1 = [RLMRealm defaultRealm];
    RLMRealm *realm = [RLMRealm realmWithPath:[self creatRealmfile]];
    //
    // 使用的方法和常规 Objective‑C 对象的使用方法类似
    Dog *mydog = [[Dog alloc] init];
    mydog.name = @"大黄";
    mydog.age = 1;
    mydog.picture = @"111"; // 属性的值可以为空
    NSLog(@"狗狗的名字： %@", mydog.name);
    // 2 通过字典创建狗狗对象
    Dog *myOtherDog = [[Dog alloc] initWithValue:@{@"name" : @"豆豆", @"age" : @3}];
    
    // 3 通过数组创建狗狗对象           //如果属性不匹配会崩溃
    Dog *myThirdDog = [[Dog alloc] initWithValue:@[@"豆豆", @"" ,@3]];
    //
    // 一对多
    // 1
    Person *person = [[Person alloc] init];
    person.name = @"jim";
    [person.dogs addObject:mydog];
    // 2
    RLMResults<Dog *> *someDogs = [Dog objectsWhere:@"name contains '大黄'"];
    [person.dogs addObjects:someDogs];
    /*，虽然可以给 RLMArray 属性赋值为 nil，但是这仅用于“清空”数组，而不是用以移除数组。这意味着您总是可以向一个 RLMArray 属性中添加对象，即使其被置为了 nil。
     //
     RLMArray 属性将确保其当中的插入次序不会被扰乱。
     */
    // 这里我们就可以使用已存在的狗狗对象来完成初始化    属性不对应崩溃
//    Person *person1 = [[Person alloc] initWithValue:@[@"李四", @30, @[myOtherDog, myThirdDog]]];
//    
//    // 还可以使用多重嵌套   属性不对应崩溃
//    Person *person2 = [[Person alloc] initWithValue:@[@"李四", @30, @[@[@"小黑",@"" , @5],
//                                                                    @[@"旺财", @"", @6]]]];
    
    RLMArray *perary = [[RLMArray alloc] initWithObjectClassName:@"Person"];
    [perary addObject:person];
    
    
    //模型继承
    Duck *duck =  [[Duck alloc] initWithValue:@{@"animal" : @{@"age" : @(3)}, @"name" : @"Gustav" }];
   
    // 存
    // 1
//    [realm1 transactionWithBlock:^{
//        [realm1 addObject:myOtherDog];//一个数据只能保存一个realm
//    }];
    // 2
    [realm beginWriteTransaction];
    [realm addObjects:perary];//只能存一个类
//    [realm addObject:mydog];
    [realm commitWriteTransaction];
    // 3  指针参数 因此你可以处理和恢复诸如硬盘空间溢出之类的错误。此外，其他的错误都无法进行恢复。
//    NSError *err;
//    [realm commitWriteTransaction:err];
//    [realm addObject:mydog];
//    [realm commitWriteTransaction:(NSError * _Nullable __autoreleasing * _Nullable)err];
    
}

- (void)modificationData {
    RLMRealm *realm = [RLMRealm realmWithPath:[self creatRealmfile]];
    //
    Dog *myDog = [[Dog alloc] init];
    myDog.name = @"小白";
    myDog.age = 1;
    
    [realm transactionWithBlock:^{
        [realm addObject:myDog];
    }];
    
    Dog *myPuppy = [[Dog objectsWhere:@"age == 1"] firstObject];  //如果不是defalut需要舍得realm
    [realm transactionWithBlock:^{
        myPuppy.age = 2;
    }];
    //
    //更新数据
    // 创建对象
    Person *author = [[Person alloc] init];
    author.name    = @"大卫·福斯特·华莱士";
    // 获取默认的 Realm 实例
    // 每个线程只需要使用一次即可
    
    // 通过事务将数据添加到 Realm 中
    [realm beginWriteTransaction];
    [realm addObject:author];
    [realm commitWriteTransaction];
    //修改
    // 1 在一个事务中更新对象
    [realm beginWriteTransaction];
    author.name = @"托马斯·品钦";//1
    // [realm addOrUpdateObject:<#(nonnull RLMObject *)#>]
    [realm commitWriteTransaction];
    
    //
    // 创建一个带有主键的“书籍”对象，作为事先存储的书籍
    Book *cheeseBook = [[Book alloc] init];
    cheeseBook.title = @"奶酪食谱";
    cheeseBook.price = 9000;
    cheeseBook.id = @"1";
    
    // 2 通过 id = 1 更新该书籍
    [realm beginWriteTransaction];
    [Book createOrUpdateInRealm:realm withValue:cheeseBook];
    [realm commitWriteTransaction];

}

//删除某条评论
- (void)deleteLocalData {
   RLMRealm *realm = [RLMRealm realmWithPath:[self creatRealmfile]];
    //
    [realm beginWriteTransaction];
    [realm deleteAllObjects];// 1
//    [realm deleteObject:cheeseBook]; // 2
    [realm commitWriteTransaction];
}


@end
