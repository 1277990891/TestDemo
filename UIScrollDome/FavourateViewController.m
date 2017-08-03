//
//  FavourateViewController.m
//  UIScrollDome
//
//  Created by lee on 15/11/18.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "FavourateViewController.h"

#import <CoreData/CoreData.h>
#import "MJRefresh.h"
#import "HealthRecordCell.h"
#import "GroupModel.h"
#import "DetailModel.h"
#import "HealthHeaderView.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface FavourateViewController ()<UITableViewDataSource,UITableViewDelegate,HeaderViewDelegate>
{
    UISearchDisplayController *_searchController;
    NSArray *searchArr;
    NSArray *array;
}
@property(nonatomic,strong)NSArray *groups;
@end

@implementation FavourateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    searchArr = [NSArray array];
    array = [NSArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSearchView];
    [self addGesture];
    
    [self readCoreData];
    // 添加下拉刷新控件
    [self setupRefresh];
    // 添MJRefresh的上拉刷新控件
    [self setupLoadMoreData];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"];
//    array =[NSArray arrayWithContentsOfFile:path];
    
    array = [NSArray arrayWithObjects:@"1",@"2",@"12",@"22",@"3",@"10", nil];
}


-(void)addGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [self.tableView addGestureRecognizer:tapGesture];
}

-(void)click
{
    [self.tableView endEditing:YES];
}
#warning ---测试数据
-(NSArray *)groups
{
    if (_groups == nil)
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"HealthRecord.plist" ofType:nil];
        NSArray  *arr = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dict1 in arr)
        {
            GroupModel *group = [GroupModel groupWithDict:dict1];
            [arrayM addObject:group];
        }
        _groups = arrayM;
    }
    return _groups;
}
-(void)addSearchView
{
 
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 44)];
    
    search.placeholder = @"搜索";
    UIView *searchView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 44)];
    [searchView addSubview:search];
    self.tableView.tableHeaderView = searchView;
    self.tableView.rowHeight = 100;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:search contentsController:self];
    _searchController.searchResultsDelegate = self;
    _searchController.searchResultsDataSource = self;
    [_searchController setActive:NO animated:YES];
}

-(void)setupRefresh{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}
-(void)setupLoadMoreData{
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

//下拉刷新
-(void)loadData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header endRefreshing];
    });
    [self.tableView reloadData];
}
// 上拉刷新
-(void)loadMoreData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.footer endRefreshing];
    });
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView== self.tableView) {
        return self.groups.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    GroupModel *group = self.groups[section];

    if (tableView == self.tableView) {
        if (group.isShow){
            return  group.detailArray.count;
        }else{
            return 0;//返回原状态;
        }
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains %@", _searchController.searchBar.text];
        searchArr = [[NSArray alloc] initWithArray:[array filteredArrayUsingPredicate:predicate]];
        return searchArr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView== self.tableView) {
        //创建数据模型
        GroupModel *group = self.groups[indexPath.section];
        DetailModel *friend =group.detailArray[indexPath.row];
        
        HealthRecordCell *cell = [HealthRecordCell recordCellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = friend;
        return cell;
    }
    else{
        NSString *cellId = [NSString stringWithFormat:@"cell %ld %ld",indexPath.section,indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.text = [searchArr objectAtIndex:indexPath.row];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  [self readData];
}

// 设置分组标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView== self.tableView) {
        GroupModel *group = self.groups[section];
        HealthHeaderView *headerView = [HealthHeaderView friendHeaderViewWithTableView:tableView];
        headerView.group = group;
        headerView.delegate = self;
        return headerView;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;//section头部高度
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark---HeaderView的代理
-(void)HeaderViewClick:(HealthHeaderView *)friendHeaderView;
{
    [self.tableView reloadData];
}


-(void)readData
{
    // 初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要查询的实体
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    // 设置排序（按照age降序）
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    // 设置条件过滤(搜索name中包含字符串"h"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*Itcast-1*)
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"h"];
    request.predicate = predicate;
    // 执行请求
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    // 遍历数据
    for (NSManagedObject *obj in objs) {
        NSLog(@"name=%@", [obj valueForKey:@"name"]);
        
    }
}


#pragma mark -创建 coreData
-(void)readCoreData
{
    // 从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    // 传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model] ;
    // 构建SQLite数据库文件的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Favourite.sqlite"]];
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = psc;
    
    
    //添加数据
    // 传入上下文，创建一个Person实体对象
    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    // 设置Person的简单属性
    [person setValue:@"haha" forKey:@"name"];
    [person setValue:[NSNumber numberWithInt:27] forKey:@"age"];

    // 利用上下文对象，将数据同步到持久化存储库
    BOOL success = [context save:&error];
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
    }
}

@end
