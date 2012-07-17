//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Yoel Zumbado on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
    @property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self descriptionOfTopOfStack:stack];
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable
{
    [self.programStack addObject: variable];
}


- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *resultDescription = @"";
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        resultDescription = [resultDescription stringByAppendingFormat:@"%@", [topOfStack stringValue]];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([self isSingleOperandOperation:operation]) {
                resultDescription = [resultDescription stringByAppendingFormat: @"%@(%@)", operation,[self descriptionOfTopOfStack:stack]];
        }else if ([self isTwoOperandOperation:operation]) {
            NSString *firstNextToOperation = @"";
            if (([self isLowestPrecedenceOperation:operation] && [self isHighestPrecedenceOperation: [stack lastObject]]) ||
                ([self isLowestPrecedenceOperation:operation] && ![self isOperation:[stack lastObject]]) ||
                (![self isOperation: [stack lastObject]] && stack.count == 2)) { // This is the las operation.
                //No Parentesis
                firstNextToOperation = [self descriptionOfTopOfStack:stack];
                resultDescription = [resultDescription stringByAppendingFormat: @"%@ %@ %@",[self descriptionOfTopOfStack:stack],operation,firstNextToOperation];
            }else{
                firstNextToOperation = [self descriptionOfTopOfStack:stack];
                resultDescription = [resultDescription stringByAppendingFormat: @"(%@ %@ %@)",[self descriptionOfTopOfStack:stack],operation,firstNextToOperation];
            }
        }else {
            resultDescription = [resultDescription stringByAppendingFormat: @"%@", operation];
        }
    }
    return resultDescription;
}


+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack ] + [self popOperandOffProgramStack:stack ];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack ] * [self popOperandOffProgramStack:stack ];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack ];
            result = [self popOperandOffProgramStack:stack ] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack ];
            if (divisor) result = [self popOperandOffProgramStack:stack ] / divisor;
        }else if ([@"sin" isEqualToString: operation]) {
            result = sin([self popOperandOffProgramStack:stack ]);
        }else if ([@"cos" isEqualToString: operation]) {
            result = cos([self popOperandOffProgramStack:stack ]);
        }else if ([@"sqrt" isEqualToString: operation]) {
            result = sqrt([self popOperandOffProgramStack:stack ]);
        }else if ([@"π" isEqualToString: operation]) {
            result = 3.14159265;
        }else if ([@"+ / -" isEqualToString: operation]) {
            result = [self popOperandOffProgramStack:stack ] * -1;
        }
    }
    return result;
}


+ (NSMutableArray *)replaceVariablesWithValues:(NSDictionary *)variableValues program:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        
        for (int i = 0; i < stack.count; i++) {
            if ([[stack objectAtIndex: i] isKindOfClass: [NSString class]]) {
                NSString *operation = [stack objectAtIndex: i];
                
                if (![self isOperation: operation]) {
                    if ([variableValues objectForKey:operation]) {
                        [stack replaceObjectAtIndex: i withObject:[variableValues valueForKey: operation]];
                    }else {
                        [stack replaceObjectAtIndex: i withObject:[NSNumber numberWithDouble: 0.0]];
                    }
                }
            }     
        }
    }
    return stack;
}

+ (double)runProgram:(id)program
{
    return [self runProgram:program usingVariablesValues:Nil];
}

+ (double)runProgram:(id)program
usingVariablesValues:(NSDictionary *) variableValues
{   
    NSMutableArray *stack = [self replaceVariablesWithValues:variableValues program:program];
  
    return [self popOperandOffProgramStack:stack];
}
    

+ (NSSet *)variablesUsedInProgram:(id)program{
    NSSet *variablesInProgram;
    
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        
        for (int i = 0; i < stack.count; i++) {
            if ([[stack objectAtIndex: i] isKindOfClass: [NSString class]]) {
                NSString *operation = [stack objectAtIndex: i];
                
                if (![self isOperation: operation]) {
                    if (!variablesInProgram) {
                        variablesInProgram = [[NSSet alloc]init];
                    }
                    variablesInProgram = [variablesInProgram setByAddingObject:operation];                 
                }
            }     
        }
    }
    return variablesInProgram;
}

-(void)clearBrain{
    [self.programStack removeAllObjects];
}

- (NSString *) description{
    return [NSString stringWithFormat:@"stack = %@", self.programStack];
}
                         
// Private Methods
+ (BOOL) isNoOperandOperation:(NSString *) operation{
    NSSet *singleOperandOperations;
    singleOperandOperations = [NSSet setWithObjects:@"π", nil];
    return [singleOperandOperations containsObject: operation];
}

+ (BOOL) isSingleOperandOperation:(NSString *) operation{
    NSSet *singleOperandOperations;
    singleOperandOperations = [NSSet setWithObjects:@"sin",@"cos",@"sqrt",@"+ / -", nil];
    return [singleOperandOperations containsObject: operation];
}

+ (BOOL) isTwoOperandOperation:(NSString *) operation{
    NSSet *twoOperandOperations;
    twoOperandOperations = [NSSet setWithObjects:@"+",@"-",@"/",@"*", nil];
    return [twoOperandOperations containsObject: operation];
}

+ (BOOL) isLowestPrecedenceOperation:(NSString *) operation{
    NSSet *twoOperandOperations;
    twoOperandOperations = [NSSet setWithObjects:@"+",@"-", nil];
    return [twoOperandOperations containsObject: operation];
}

+ (BOOL) isHighestPrecedenceOperation:(NSString *) operation{
    NSSet *twoOperandOperations;
    twoOperandOperations = [NSSet setWithObjects:@"*",@"/", nil];
    return [twoOperandOperations containsObject: operation];
}


+ (BOOL) isOperation: (NSString *) posibleOperation{
    return [self isNoOperandOperation:posibleOperation] || [self isSingleOperandOperation: posibleOperation] || [self isTwoOperandOperation: posibleOperation];
}




















@end
