//
//  SearchViewController.m
//  集成高德地图-DEMO
//
//  Created by MARLONXLJ on 16/3/26.
//  Copyright © 2016年 XLJLIU. All rights reserved.
//

#import "SearchViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AMapSearchDelegate
>
{
    UITableView *_tableView;
    AMapSearchAPI *_search;
    NSString *_sesarKey;
}
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SearchViewController

#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
}

- (void)searchPOI
{
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapPOIAroundSearchRequest
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:30.662221 longitude:104.041367];
    request.keywords = _sesarKey;
    
    
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
//    request.types = @"餐饮服务|生活服务";
    
    
    //发起周边搜索
    [_search AMapPOIAroundSearch:request];
}

#pragma mark - AMAPOI回调方法
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0) {
        return;
    }
    
    //通过AMapPOISearchResponese对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",(long)response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggest:%@",response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI:%@",strPoi,p.description];
        
        [self.dataArray addObject:p];
        
    }
    
    [_tableView reloadData];
    NSString *result = [NSString stringWithFormat:@"%@\n%@\n%@",strCount, strSuggestion,strPoi];
//    NSLog(@"Place:%@",result);
}

- (void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark - DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.dataArray.count =%lu", (unsigned long)self.dataArray.count);
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    AMapPOI *poi = self.dataArray[indexPath.row];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - 自定义搜索的head
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 66)];
    
    search.placeholder = @"请输入地址";
    
    search.delegate = self;
    return search;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //当按下搜索时进行POI查询
    NSLog(@"++++++%@",searchBar.text);
    _sesarKey = searchBar.text;
    //创建搜索
    [self searchPOI];
    //收起键盘
    [searchBar resignFirstResponder];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapPOI *poi = self.dataArray[indexPath.row];
    
    self.block(poi);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
