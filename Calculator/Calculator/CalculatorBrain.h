//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Yoel Zumbado on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (nonatomic, readonly) id program;


- (void)pushOperand:(double)operand;
- (void)pushVariable:(NSString *)variable;
- (double)performOperation:(NSString *)operation;
- (void)clearBrain;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
usingVariablesValues:(NSDictionary *) variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;
@end
