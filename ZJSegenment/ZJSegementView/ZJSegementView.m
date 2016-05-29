 
#define NavBarColor [UIColor colorWithRed:234/255.0f green:114/255.0f blue:60/255.0f alpha:1]
#import "ZJSegementView.h"

@implementation ZJSegementView

#pragma mark getter方法
-(CGFloat)ItemHeight{
    if (!_ItemHeight) {
        _ItemHeight = 50;
    }
    return _ItemHeight;
}
-(CGFloat)ItemWidth{
    if (!_ItemWidth) {
        _ItemWidth =100;
    }
    return _ItemWidth;
}
- (UIColor *)titleColor{
    if (!_titleColor) {
        _titleColor = [UIColor blackColor];
    }
    return _titleColor;
}

- (CGFloat)titleFont{
    if (!_titleFont) {
        _titleFont = 16.0;
    }
    return _titleFont;
}

- (UIColor *)titleSelectedColor{
    if (!_titleSelectedColor) {
        _titleSelectedColor = NavBarColor;
    }
    return _titleSelectedColor;
}

- (UIColor *)separateColor{
    if (!_separateColor) {
        _separateColor = [UIColor colorWithRed:1 green:0 blue:0.8 alpha:1];
    }
    return _separateColor;
}

- (UIColor *)scrollLineColor{
    if (!_scrollLineColor) {
        _scrollLineColor = [UIColor blackColor];
    }
    return _scrollLineColor;
}

- (float)scrollLineHeight{
    if (!_scrollLineHeight) {
        _scrollLineHeight = 10.0;
    }
    return _scrollLineHeight;
}

- (float)separateHeight{
    if (!_separateHeight) {
        _separateHeight = 10;
    }
    return _separateHeight;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addPropertyObserver];
        [self configSubLabel];
       
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

//- (BOOL)haveNoRightLine{
//    if (!_haveRightLine) {
//        _haveRightLine = YES;
//    }
//    return _haveRightLine;
//}

- (void)addPropertyObserver{
    [self addObserver:self forKeyPath:@"titleColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"titleSelectedColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"titleFont" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"scrollLineColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"separateColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"scrollLineHeight" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"separateHeight" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"titleArray" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"haveRightLine" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"titleColor"];
    [self removeObserver:self forKeyPath:@"titleSelectedColor"];
    [self removeObserver:self forKeyPath:@"titleFont"];
    [self removeObserver:self forKeyPath:@"separateColor"];
    [self removeObserver:self forKeyPath:@"scrollLineColor"];
    [self removeObserver:self forKeyPath:@"scrollLineHeight"];
    [self removeObserver:self forKeyPath:@"separateHeight"];
    [self removeObserver:self forKeyPath:@"titleArray"];
    [self removeObserver:self forKeyPath:@"haveRightLine"];
}

//根据titleArray配置label
- (void)configSubLabel{
    //移除所有子视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   // UILabel *titleLabel =nil;
    for (int i = 0;  i < self.titleArray.count; i++) {
    UILabel*  titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(i * self.ItemWidth, 0, self.ItemWidth,self.ItemHeight)];
        titleLabel.text = [self.titleArray objectAtIndex:i];
        titleLabel.textColor =  self.titleColor;
        titleLabel.font = [UIFont systemFontOfSize:self.titleFont];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if (_haveRightLine) {
            if (i < self.titleArray.count - 1) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(self.ItemWidth - 0.5, self.ItemHeight/7*2, 1, self.ItemHeight/7*3)];
                [line setBackgroundColor:[UIColor lightGrayColor]];
                [titleLabel addSubview:line];
            }
        }
        self.contentSize = CGSizeMake(self.titleArray.count*self.ItemWidth, self.ItemHeight);
        titleLabel.tag = 100+i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLabelWithGesture:)];
        tap.numberOfTapsRequired = 1;
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer:tap];
        
        [self addSubview:titleLabel];
           }
    
    [self selectLabelWithIndex:0];

    //分割线
    _separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.ItemHeight - _separateHeight, self.contentSize.width, self.separateHeight)];
    [_separateLine setBackgroundColor:self.separateColor];
    
    //滚动条
    _scrollLine = [[UIView alloc]initWithFrame:CGRectMake(0,self.ItemHeight - self.scrollLineHeight, self.ItemWidth, self.scrollLineHeight)];
    [_scrollLine setBackgroundColor:self.scrollLineColor];
    
    [self addSubview:_separateLine];
    [self addSubview:_scrollLine];
  
}

//点击第几个label触发回调
- (void)touchLabelWithGesture:(UITapGestureRecognizer *)tap{
    
    UILabel *label = (UILabel *)tap.view;
    NSInteger index = label.tag - 100;
    
    [self selectLabelWithIndex:index];

}

//选中指定位置label
- (void)selectLabelWithIndex:(NSInteger)index{
    UILabel *selectedLabel = [self viewWithTag:index+100];
    for (int i = 0; i < self.titleArray.count; i++) {
        UILabel *label = [self viewWithTag:100+i];
        if ([label isEqual:selectedLabel]) {
            label.textColor = self.titleSelectedColor;
        }else{
            label.textColor = self.titleColor;
        }
    }
    CGRect scrollLineFrame = _scrollLine.frame;
    scrollLineFrame.origin.x = self.ItemWidth*index;
    [UIView animateWithDuration:0.5 animations:^{
        [_scrollLine setFrame:scrollLineFrame];
    }];
    if ([self.touchDelegate respondsToSelector:@selector(touchLabelWithIndex:)]) {
        [self.touchDelegate touchLabelWithIndex:index];
    }
//    NSLog(@"我是第%ld个label",index);
//    NSLog(@"%@",segementView.subviews[index]);
//    UILabel * label =(UILabel *)segementView.subviews[index];
    //    label.userInteractionEnabled = NO;
    //    for (UILabel * lb in segementView.subviews) {
    //        if (lb!=label) {
    //            lb.userInteractionEnabled = YES;
    //        }
    //    }
    //    if ((label.frame.origin.x+CGRectGetWidth(label.frame))>CGRectGetWidth(self.view.frame)){
    //        srollView.contentOffset = CGPointMake(srollView.contentOffset.x+50,0);
    //
    //    }else if(label.frame.origin.x<0){
    //
    //            srollView.contentOffset = CGPointMake(srollView.contentOffset.x+50,0);
    //
    //    }
//    if (selectedLabel.frame.origin.x+selectedLabel.frame.size.width>self.bounds.size.width) {
//        self.contentOffset = CGPointMake(selectedLabel.frame.origin.x+selectedLabel.frame.size.width - [UIScreen mainScreen].bounds.size.width, 0);
    //}else
    
    if (index==0) {
        self.contentOffset = selectedLabel.frame.origin;
    }else if( (self.titleArray.count-index)*self.ItemWidth> self.frame.size.width){
        if (selectedLabel.frame.origin.x<self.contentOffset.x+self.frame.size.width&&selectedLabel.frame.origin.x+selectedLabel.frame.size.width>self.contentOffset.x+self.frame.size.width) {
            self.contentOffset =CGPointMake(selectedLabel.frame.origin.x+selectedLabel.frame.size.width-self.frame.size.width, 0);
        }else{
        self.contentOffset = CGPointMake(selectedLabel.frame.origin.x-selectedLabel.frame.size.width, 0);
        }
        
    }else{
        self.contentOffset = CGPointMake(self.ItemWidth*self.titleArray.count- self.frame.size.width, 0);
    }//    NSLog(@"srollView.contentOffset:%@",NSStringFromCGPoint(srollView.contentOffset));
//    NSLog(@"segementView.frame%@",NSStringFromCGPoint(segementView.frame.origin));
//    NSLog(@"%@",NSStringFromCGPoint(label.frame.origin));
    [self setNeedsDisplay];

}

- (void)changeTitleColorWithColor:(UIColor *)color{
    for (int i = 0; i < _titleArray.count; i ++) {
        UILabel *label = [self viewWithTag:100+i];
        label.textColor = color;
    }
}

- (void)changeTitleLabelFontWithFont:(CGFloat)font{
    for (int i = 0; i < _titleArray.count; i ++) {
        UILabel *label = [self viewWithTag:100+i];
        label.font = [UIFont systemFontOfSize:font];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"titleColor"]) {
        
        [self changeTitleColorWithColor:_titleColor];
        
    }else if ([keyPath isEqualToString:@"titleSelectedColor"]){
        
        NSInteger index = _scrollLine.frame.origin.x/self.ItemWidth;
        UILabel *label = [self viewWithTag:index + 100];
        label.textColor = _titleSelectedColor;
        
    }else if ([keyPath isEqualToString:@"titleFont"]){
        
        [self changeTitleLabelFontWithFont:_titleFont];
        
    }else if ([keyPath isEqualToString:@"scrollLineColor"]){
        
        [_scrollLine setBackgroundColor:_scrollLineColor];
        
    }else if ([keyPath isEqualToString:@"separateColor"]){
        
        [_separateLine setBackgroundColor:_separateColor];
        
    }else if ([keyPath isEqualToString:@"scrollLineHeight"]){
        
        CGRect scrollLineFrame = _scrollLine.frame;
        scrollLineFrame.origin.y =self.ItemHeight - _scrollLineHeight;
        scrollLineFrame.size.height = _scrollLineHeight;
        [_scrollLine setFrame:scrollLineFrame];
        
    }else if ([keyPath isEqualToString:@"separateHeight"]){
        
        CGRect separateLineFrame = _separateLine.frame;
        separateLineFrame.size.height = _separateHeight;
        separateLineFrame.origin.y = self.ItemHeight - _separateHeight;
        [_separateLine setFrame:separateLineFrame];
        
    }else if ([keyPath isEqualToString:@"titleArray"]){
        
        [self configSubLabel];
        
    }else if ([keyPath isEqualToString:@"haveRightLine"]){
        
        [self configSubLabel];
        
    }
}

@end
 