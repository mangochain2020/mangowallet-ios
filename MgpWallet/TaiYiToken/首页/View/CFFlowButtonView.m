
#import "CFFlowButtonView.h"
#import "UIView+Extension.h"
@implementation CFFlowButtonView

- (instancetype)initWithButtonList:(NSMutableDictionary *)buttonDic {
   
    if (self = [super init]) {
        _buttonDic = buttonDic;
        self.buttonList = [NSMutableArray new];
        [buttonDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self addSubview:(UIButton*)obj];
            [self.buttonList addObject:(UIButton *)obj];
        }];

    }
    return self;
}

- (void)layoutSubviews {
   
    //更新时先移除之前的旧button,不然会覆盖
   [self removeAllSubviews];
   if (_buttonList == nil||_buttonList.count == 0) {
        return;
    }
    //已经加上view的button
    NSMutableArray *oldButtons = [NSMutableArray array];
    // 对第一个Button进行设置
    UIButton *button0 = self.buttonList[0];
    button0.frame = CGRectMake(10, 10, button0.titleLabel.text.length*15, 23);
    [self addSubview:button0];

    [oldButtons addObject:button0];
    
    
    CGFloat currentHeight = 10;
    for (int i = 1; i < self.buttonList.count; i++) {
        UIButton *button = self.buttonList[i];
        UIButton *lastButton = self.buttonList[i - 1];
        CGFloat sumWidth = lastButton.x+lastButton.width+10+button.width+10;
        CGRect rect = lastButton.frame;
        if (sumWidth > self.frame.size.width) {//换行
            currentHeight += 33;//+23+10
            button.frame = CGRectMake(10, currentHeight, button.titleLabel.text.length*15, 23);
            [self addSubview:button];

            
        }else{
            button.frame = CGRectMake(rect.origin.x +rect.size.width + 10, currentHeight, button.titleLabel.text.length*15, 23);
            [self addSubview:button];
        }
      
    }
}


@end
