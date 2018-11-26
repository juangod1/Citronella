# Citronella Code Definition
Citronella is a simple typed language developed with LEX and YACC.

## Compiling and executing
In this github you will find all the necessary files to compile a Citronella code. In order to do this, you will first need to build the compiler by executing:
```
$> ./build_compiler.sh   
      /* This creates "Citronella" */
$> ./Citronella_compile.sh filename.Cit filename
$> ./filename
```

## Code entry point
The code's entry point is defined as:
```
begin
  /* your code goes here */
end
```

## Variables types
There are 3 variable types:

| Type  | Declaration and initialization |
| ------------- | ------------- |
| num  | num varName = 1  |
| text  | text varName = "text"  |
| bool | bool varName = true |

## Arithmetic Operators
The following table shows all the arithmetic operators supported by the Citronella language. Assume variable **A** holds 10 and variable **B** holds 20, then:

| Operator | Description | Example|
| ------------- | ------------- | ------ |
| +  | Adds two operands. | A + B = 30 |
| −  | Subtracts second operand from the first. | A − B = −10 |
| . | Multiplies both operands. | A . B = 200 |
| / | Divides numerator by de-numerator. | B / A = 2 |

## Relational Operators
The following table shows all the relational operators supported by Citronella. Assume variable **A** holds 10 and variable B holds **20**, then:

| Operator | Description | Example|
| ------------- | ------------- | ------ |
| ==  | Checks if the values of two operands are equal or not. If yes, then the condition becomes true. | (A == B) is not true.  |
| not(A==B) | Checks if the values of two operands are equal or not. If the values are not equal, then the condition becomes true. | not(A == B) is true. |
| > | Checks if the value of left operand is greater than the value of right operand. If yes, then the condition becomes true. | (A > B) is not true. |
| < | Checks if the value of left operand is less than the value of right operand. If yes, then the condition becomes true. | (A < B) is true. |
| >= | Checks if the value of left operand is greater than or equal to the value of right operand. If yes, then the condition becomes true. | (A >= B) is not true. |
| <= | Checks if the value of left operand is less than or equal to the value of right operand. If yes, then the condition becomes true. | (A <= B) is true. |

## Logical Operators
Following table shows all the logical operators supported by Citronella language. Assume variable **A** holds true and variable **B** holds false, then:

| Operator | Description | Example|
| ------------- | ------------- | ------ |
| and  | Called Logical AND operator. If both the operands are non-zero, then the condition becomes true. | (A and B) is false. |
| or  | Called Logical OR Operator. If any of the two operands is non-zero, then the condition becomes true. | (A or B) is true. |
| not | Called Logical NOT Operator. It is used to reverse the logical state of its operand. If a condition is true, then Logical NOT operator will make it false. | not(A and B) is true. |

## Conditional blocks
Conditional blocks allow a program to take different paths depending on some condition(s).
```
boolean expression
? statement 1
  statement 2
  ...
  statement n
  
! statement 1 bis
  statement 2 bis
  ...
  statement n bis
```
*statement i* executes only if the boolean expression associated with it is true.

*statement i bis* executes if the boolean expression is false.

## Do while loop
Do while loop is a control flow statement that executes a block of code depending on a given boolean condition
```
repeat statement 1
   statement 2
   ...
   statement n
 while boolean expression
 ```
 ## STDOUT
 Statements to write output in the user's screen:
 ```
 show varName
 show "text"
 show boolean expression
 show numeric expression
 ```
 
 ## STDIN
 In order to read input from stdin and then write it in stdout:
 ```
 read
 ```
 
