//
//  XDMultTableView.m
//  XDMultTableView
//
//  Created by 蔡欣东 on 2016/7/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "XDMultTableView.h"

static const CGFloat CELLHEIGHT = 44.0f;

#define DEFAULTHEADVIEWCOLOR [UIColor colorWithRed:229/255.f green:229/255.f blue:229/255.f alpha:1]

@interface XDMultTableView()

@property (nonatomic, strong, readwrite) NSMutableArray *multopenSectionArray;

@end

@implementation XDMultTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _multopenSectionArray = [NSMutableArray arrayWithCapacity:10];
        _autoAdjustOpenAndClose = YES;
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor  = [UIColor clearColor];
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [self addSubview:_tableView];
        
    }
    return self;
}

- (XDMultTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    
    return [self.tableView dequeueReusableCellWithIdentifier:identifier];
}

- (XDMultTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (void)reloadData{
    [_tableView reloadData];
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier{
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier{
    [self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(XDMultTableViewRowAnimation)animation{
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![_multopenSectionArray containsObject:[NSNumber numberWithInteger:section]]) {
        return 0;
    }
    return [self invoke_numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self invoke_cellForRowAtIndexPath:indexPath];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self invoke_numberOfSections];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self invode_canEditRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self invode_commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self invoke_heightForRowAtIndexPath:indexPath];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.datasource && [self.datasource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        return [self invoke_heightForHeaderInSection:section];
        
    }else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [self invoke_viewForHeaderInSection:section];
    CGFloat height = [self invoke_heightForHeaderInSection:section];
    CGFloat width = self.tableView.bounds.size.width;
    CGRect frame = CGRectMake(0, 0, width, height);
    if (view) {
        view.frame = frame;
    }else{
        view = [[UIView alloc] init];
        view.backgroundColor = DEFAULTHEADVIEWCOLOR;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.borderWidth = 0.5;
        NSString *title = [self invoke_titleForHeaderInSection:section];
        view.frame = frame;
        CGFloat labelW = 200;
        CGFloat labelH = 20;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (height-labelH)/2, labelW, labelH)];
        label.text = title;
        [view addSubview:label];
    }
    view.tag = section;
    CGFloat imgH = height-20;
    CGFloat imgW = imgH;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width-imgW-10, (height-imgH)/2, imgW, imgH)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"down_blue"];
    NSNumber *sectionObj = [NSNumber numberWithInteger:section];
    if ([_multopenSectionArray containsObject:sectionObj]) {
        imageView.transform = CGAffineTransformMakeRotation(0);
    }else{
        imageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    }
    imageView.tag = 100;
    [view addSubview:imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
    [view addGestureRecognizer:tap];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self invoke_didSelectRowAtIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self invoke_editingStyleForRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self invoke_titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
}

#pragma mark - add or delete NSIndexPaths

- (NSMutableArray *)buildInsertRowWithSection:(NSInteger)section
{
    NSInteger insert = [self invoke_numberOfRowsInSection:section];
    
    if (insert != 0)
    {
        [self invoke_willOpenHeaderAtSection:section];
    }
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < insert; i++)
    {
        [indexPaths addObject: [NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    return indexPaths;
}

- (NSMutableArray *)buildDeleteRowWithSection:(NSInteger)section
{
    NSInteger delete = [self invoke_numberOfRowsInSection:section];;
    if (delete != 0)
    {
        [self invoke_willCloseHeaderAtSection:section];
    }
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < delete; i++)
    {
        [indexPaths addObject: [NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    return indexPaths;
}

#pragma mark - UITapGestureRecognizer response
- (void)tapHeader:(UITapGestureRecognizer *) tap {
    NSInteger section = tap.view.tag;
    NSNumber *sectionObj = [NSNumber numberWithInteger:section];
    UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:100];
    if ([_multopenSectionArray containsObject:sectionObj]) {
        NSArray *deleteArray = [self buildDeleteRowWithSection:section];
        [_multopenSectionArray removeObject:sectionObj];
        [_tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        }];
    }else{
        if (_autoAdjustOpenAndClose) {
            [[_multopenSectionArray copy] enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"%ld",[obj integerValue]);
                NSArray *otherDeleteArray = [self buildDeleteRowWithSection:[obj integerValue]];
                [_multopenSectionArray removeObject:obj];
                [_tableView deleteRowsAtIndexPaths:otherDeleteArray withRowAnimation:UITableViewRowAnimationFade];
                UIView *otherView = [self.tableView viewWithTag:[obj integerValue]];
                UIImageView *imageView = (UIImageView *)[otherView viewWithTag:100];
                [UIView animateWithDuration:0.3 animations:^{
                    imageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
                }];
            }];
        }

        [_multopenSectionArray addObject:sectionObj];
        NSArray *insertArray = [self buildInsertRowWithSection:section];
        [_tableView insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationFade];
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}

#pragma mark - invoke_datasource
- (NSInteger)invoke_numberOfRowsInSection:(NSInteger)section{
    if (self.datasource&&[self.datasource respondsToSelector:@selector(mTableView:numberOfRowsInSection:)]){
        return [self.datasource mTableView:self numberOfRowsInSection:section];
    }
    return 0;
}

- (NSInteger)invoke_numberOfSections{
    if (self.datasource&&[self.datasource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.datasource numberOfSectionsInTableView:self];
    }
    return 1;
}

- (UITableViewCell *)invoke_cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (self.datasource&&[self.datasource respondsToSelector:@selector(mTableView:cellForRowAtIndexPath:)]) {
        cell =  [self.datasource mTableView:self cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (NSString *)invoke_titleForHeaderInSection:(NSInteger)section {
    if (self.datasource&&[self.datasource respondsToSelector:@selector(mTableView:titleForHeaderInSection:)]) {
        return [self.datasource mTableView:self titleForHeaderInSection:section];
    }
    return @"";
}

- (BOOL)invode_canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.datasource&&[self.datasource respondsToSelector:@selector(mTableView:canEditRowAtIndexPath:)]){
        return [self.datasource mTableView:self canEditRowAtIndexPath:indexPath];
    }
    return false;
}

- (void)invode_commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.datasource&&[self.datasource respondsToSelector:@selector(mTableView:commitEditingStyle:forRowAtIndexPath:)]) {
        XDMultTableViewCellEditingStyle style = (XDMultTableViewCellEditingStyle)editingStyle;
        [self.datasource mTableView:self commitEditingStyle:style forRowAtIndexPath:indexPath];
    }
}

#pragma mark - invoke_delegate
- (CGFloat)invoke_heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = CELLHEIGHT;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mTableView:heightForRowAtIndexPath:)]) {
        height =  [self.delegate mTableView:self heightForRowAtIndexPath:indexPath];
    }
    return height;
}

- (CGFloat)invoke_heightForHeaderInSection:(NSInteger)section{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mTableView:heightForHeaderInSection:)]) {
        return [self.delegate mTableView:self heightForHeaderInSection:section];
    }
    return 0;
}

- (UIView*)invoke_viewForHeaderInSection:(NSInteger)section;{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mTableView:viewForHeaderInSection:)]) {
        return [self.delegate mTableView:self viewForHeaderInSection:section];
    }
    return nil;
}

- (void)invoke_didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mTableView:didSelectRowAtIndexPath:)]) {
        [self.delegate mTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (void)invoke_willOpenHeaderAtSection:(NSInteger)section {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mTableView:willOpenHeaderAtSection:)]) {
        [self.delegate mTableView:self willOpenHeaderAtSection:section];
    }
}

- (void)invoke_willCloseHeaderAtSection:(NSInteger)section {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mTableView:willCloseHeaderAtSection:)]) {
        [self.delegate mTableView:self willCloseHeaderAtSection:section];
    }
}

- (UITableViewCellEditingStyle)invoke_editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mTableView:editingStyleForRowAtIndexPath:)]) {
        return (UITableViewCellEditingStyle)[self.delegate mTableView:self editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}

- (NSString *)invoke_titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mTableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [self.delegate mTableView:self titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return @"Delete";
}

#pragma mark - setter and getter
- (void)setOpenSectionArray:(NSArray *)openSectionArray {
    _multopenSectionArray = [NSMutableArray arrayWithArray:openSectionArray];
}

- (void)setTableViewHeader:(UIView *)tableViewHeader {
    self.tableView.tableHeaderView = tableViewHeader;
}


@end
