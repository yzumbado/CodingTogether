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
@property (nonatomic) BOOL userEnteredAVariable;

@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize history = _history;
@synthesize debugScreen = _debugScreen;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize isCurrentNumberNegative = _isCurrentNumberNegative;  
@synthesize userEnteredAVariable = _userEnteredAVariable;

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

- (IBAction)variablePressed:(UIButton *)sender {
    self.display.text = sender.currentTitle;
    self.userEnteredAVariable = YES;
    [self enterPressed];
    
}

- (IBAction)enterPressed {
    if (self.userEnteredAVariable) {
        [self.brain pushVariable: self.display.text];
    }
    else {
        [self.brain pushOperand: [self.display.text doubleValue]];
    }   
    
    self.history.text = [NSString stringWithFormat:@"%@ %@", self.history.text, self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.isCurrentNumberNegative = NO;
    self.userEnteredAVariable = NO;
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
    self.userIsInTheMiddleOfEnteringANumber = NO;
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

- (IBAction)debugPressed:(UIButton *)sender {
//    NSSet *variablesUsedOnProgram = [CalculatorBrain variablesUsedInProgram: self.brain.program];
//    for (NSString *variable in variablesUsedOnProgram) {
//        self.debugScreen.text = [self.debugScreen.text stringByAppendingFormat:variable];
//    }
    NSString *descriptionOfProgram = [CalculatorBrain descriptionOfProgram: self.brain.program];
    self.debugScreen.text = descriptionOfProgram;
    
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
- (void)viewDidUnload {
    [self setDebugScreen:nil];
    [super viewDidUnload];
}
@end
