# XDMultTableView
多级展开列表
#effect diagram
![image](https://github.com/caixindong/XDMultTableView/blob/master/gif2.gif)

#How To Use

##Init XDMultTableView
```ObjC
#import "XDMultTableView.h"
...
@property(nonatomic, readwrite, strong)XDMultTableView *tableView;

 _tableView = [[XDMultTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _tableView.openSectionArray = [NSArray arrayWithObjects:@1,@2, nil];
    _tableView.delegate = self;
    _tableView.datasource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];

```

##Datasource Impletement

```ObjC

- (NSInteger)mTableView:(XDMultTableView *)mTableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (XDMultTableViewCell *)mTableView:(XDMultTableView *)mTableView
              cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UIView *view = [[UIView alloc] initWithFrame:cell.bounds] ;
    view.layer.backgroundColor  = [UIColor whiteColor].CGColor;
    view.layer.masksToBounds    = YES;
    view.layer.borderWidth      = 0.3;
    view.layer.borderColor      = [UIColor lightGrayColor].CGColor;
    
    cell.backgroundView = view;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(XDMultTableView *)mTableView{
    return 6;
}

-(NSString *)mTableView:(XDMultTableView *)mTableView titleForHeaderInSection:(NSInteger)section{
    return @"我是头部";
}

```

##Delegate Impletement

```ObjC

- (CGFloat)mTableView:(XDMultTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)mTableView:(XDMultTableView *)mTableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}


- (void)mTableView:(XDMultTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section{
    NSLog(@"即将展开");
}


- (void)mTableView:(XDMultTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section{
    NSLog(@"即将关闭");
}

- (void)mTableView:(XDMultTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell");
}

```

##Easy Extension

```
/**
 *  ...易拓展出你想要的tableview的功能，写法可以参照上面的定义
 */
```


