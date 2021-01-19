//
//  GridViewControl.m
//  WeatherInZhuhai
//
//  Created by tb on 14-9-5.
//  Copyright (c) 2014年 tb. All rights reserved.
//

#import "GQGridViewControl.h"

@interface GQGridViewControl ()

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIButton *btnDelete;

@property (nonatomic, assign) id<__GQGridControlDelegate> delegate;

@end

@implementation GQGridViewControl

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image atIndex:(NSInteger)index withDelegate:(id<__GQGridControlDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.delegate = delegate;
        self.isEditing = NO;
        self.index = index;
        
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        
        [_button addTarget:self action:@selector(buttonTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_button setImage:image forState:UIControlStateNormal];
        [_button setImage:image forState:UIControlStateHighlighted];
        [_button setImage:image forState:UIControlStateSelected];
        [_button setImage:image forState:UIControlStateDisabled];
        _button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_button];
        
        _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDelete setHidden:YES];
        [_btnDelete setFrame:CGRectMake(self.frame.size.width - 22.0f, 0, 22.0f, 22.0f)];
        [_btnDelete setImage:[UIImage imageNamed:@"gridcontrol_delete"] forState:UIControlStateNormal];
        [_btnDelete addTarget:self action:@selector(buttonRemoveAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnDelete];
        //长按
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:longPressRecognizer];
    }
    return self;
}

//---------------------------------------------------------------------------------

/**单机Item*/
- (void)buttonTouchedAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(gridItemDidClicked:atIndex:)]) {
        [self.delegate gridItemDidClicked:self atIndex:self.index];
    }
}

/**删除Item*/
- (void)buttonRemoveAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(gridItemDidDeleted:atIndex:)]) {
        [self.delegate gridItemDidDeleted:self atIndex:self.index];
    }
}

/**长按*/
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer
{
    if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(gridItemDidLongPressed:atIndex:)]) {
            [self.delegate gridItemDidLongPressed:self atIndex:self.index];
        }
    }
}

//---------------------------------------------------------------------------------

#pragma mark - Public Method

- (void)enableEditing
{
    if (self.isEditing == YES)
        return;
    
    self.isEditing = YES;
    
    [_btnDelete setHidden:NO];
    [_button setEnabled:NO];
}

- (void)disableEditing
{
    self.isEditing = NO;
    
    [_btnDelete setHidden:YES];
    [_button setEnabled:YES];
}

//---------------------------------------------------------------------------------

@end
