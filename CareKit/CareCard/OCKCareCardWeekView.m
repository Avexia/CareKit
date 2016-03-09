//
//  OCKHeartWeekView.m
//  CareKit
//
//  Created by Umer Khan on 1/29/16.
//  Copyright © 2016 carekit.org. All rights reserved.
//


#import "OCKCareCardWeekView.h"
#import "OCKWeekView.h"
#import "OCKHeartView.h"
#import "OCKHeartButton.h"


const static CGFloat HeartButtonSize = 20.0;

@implementation OCKCareCardWeekView {
    OCKWeekView *_weekView;
    NSMutableArray <OCKHeartButton *> *_heartButtons;
    NSMutableArray *_constraints;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareView];
    }
    return self;
}

- (void)prepareView {
    if (!_weekView) {
        _weekView = [[OCKWeekView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 25.0)];
        [self addSubview:_weekView];
    }
    
    if (!_heartButtons) {
        _heartButtons = [NSMutableArray new];
        for (int i = 0; i < 7; i++) {
            OCKHeartButton *heartButton = [[OCKHeartButton alloc] initWithFrame:CGRectMake(0, 0, HeartButtonSize, HeartButtonSize)];
            heartButton.translatesAutoresizingMaskIntoConstraints = NO;
            
            OCKHeartView *heartView = [[OCKHeartView alloc] initWithFrame:CGRectMake(0, 0, HeartButtonSize + 10, HeartButtonSize + 10)];
            heartView.userInteractionEnabled = NO;
            heartButton.heartView = heartView;
            
            [heartButton addTarget:self
                            action:@selector(updateDayOfWeek:)
                  forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:heartButton];
            [_heartButtons addObject:heartButton];
        }
    }
    
    [self setUpConstraints];
}

- (void)setUpConstraints {
    [NSLayoutConstraint deactivateConstraints:_constraints];
    
    _constraints = [NSMutableArray new];
    
    _weekView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_constraints addObjectsFromArray:@[
                                        [NSLayoutConstraint constraintWithItem:_weekView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:-5.0],
                                        [NSLayoutConstraint constraintWithItem:_weekView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0.0]
                                        ]];
    
    for (int i = 0; i < _heartButtons.count; i++) {
        UILabel *dayLabel = (UILabel *)_weekView.weekLabels[i];
        [_constraints addObjectsFromArray:@[
                                            [NSLayoutConstraint constraintWithItem:dayLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_heartButtons[i]
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0
                                                                          constant:-3.0],
                                            [NSLayoutConstraint constraintWithItem:dayLabel
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_heartButtons[i]
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.0]
                                            ]];
    }
    
    
    [NSLayoutConstraint activateConstraints:_constraints];
}

- (void)setAdherenceValues:(NSArray *)adherenceValues {
    _adherenceValues = adherenceValues;
    
    for (int i = 0; i < _adherenceValues.count; i++) {
        _heartButtons[i].heartView.adherence = [_adherenceValues[i] floatValue];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [_weekView highlightDay:selectedIndex];
}

- (void)updateDayOfWeek:(id)sender {
    OCKHeartButton *button = (OCKHeartButton *)sender;
    NSInteger dayOfWeek = [_heartButtons indexOfObject:button];
    _selectedIndex = dayOfWeek;
    
    if (_delegate &&
        [_delegate respondsToSelector:@selector(careCardWeekViewSelectionDidChange:)]) {
        [_delegate careCardWeekViewSelectionDidChange:self];
    }
}

@end