//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Yoel Zumbado on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) BOOL isCurrentNumberNegative;

@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize isCurrentNumberNegative = _isCurrentNumberNegative;  

- (CalculatorBrain *) brain{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle; //[sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingFormat:digit];
    }else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand: [self.display.text doubleValue]];
    self.history.text = [NSString stringWithFormat:@"%@ %@", self.history.text, self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.isCurrentNumberNegative = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    NSString *operation = sender.currentTitle;
    double result = [self.brain performOperation: operation];
    self.display.text = [NSString stringWithFormat: @"%g", result];
    // Clean History var, remove previous =.
    NSString *cleanHistory = [self.history.text stringByReplacingOccurrencesOfString:@"=" withString:@""];
    if ([@"+ / -" isEqualToString:operation]) {
        NSString *numberSign;
        if (!self.isCurrentNumberNegative) {
            numberSign = @"-";
        }
        self.history.text = [NSString stringWithFormat:@"%@%@ =", numberSign, cleanHistory];
    }else {
        self.history.text = [NSString stringWithFormat:@"%@ %@ =", cleanHistory, operation];
    }
    
}

- (IBAction)decimalPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
            self.display.text = [self.display.text stringByAppendingFormat:@"."];
        }
    }else {
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}
- (IBAction)clearPressed {
    [self.brain clearBrain];
    self.history.text = @"";
    self.display.text = @"0";
    self.isCurrentNumberNegative = NO;
}
- (IBAction)backPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if (self.display.text.length > 1) {
            self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
        }else {
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
}

- (IBAction)signChangePressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if (self.isCurrentNumberNegative) {
            self.display.text = [self.display.text substringFromIndex:1]; 
            self.isCurrentNumberNegative = NO;
        }
        else {
            self.display.text = [NSString stringWithFormat:@"-%@",self.display.text];
            self.isCurrentNumberNegative = YES;
        }
    }else {
        [self operationPressed:sender];
    }
}
@end
