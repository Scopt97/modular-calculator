# Modular Calculator

## What?

A calculator app with seperate GUI and back end. Backend has a TUI if executed directly. Or it can be used like an API/module/library that takes a string that is a valid mathematical expression and returns the result. This will allow others to create their own calculator GUIs without having to implement logic for parsing, order of operations, etc.

## Requirements

Ruby. This was made with ruby 3.0.1, but should work with earlier versions of ruby.

## Usage

### TUI

Either execute using ruby: `ruby tui_calc.rb` or make the file executable and execute directly: `./tui_calc.rb`

The program accepts one command line argument ("true" or "false", default false). If true, the program will print verbose output. This means printing intermediary expressions during calculation.  
e.g. `4 + 5 * 6` will print `4 + 30` before printing the final result.

The program will prompt for a methematical expresion. Valid operations are displayed. Separate different elements using spaces. e.g. `4 + 5` is right, but `4+5` is wrong.

The program will continue prompting for new expressions until the user enters `(q)uit`

### GUI

Not yet implemented

### As a module/library

#### valid operations

+: addition  
-: subtraction  
*: multiplication  
/: division  
** or ^: exponent

#### calc(expr, verbose=false)

Takes an expresion as a string. Elements should be separated by spaces. Calls `check_expr` to check whether the expresion is valid (see section below for details). If the expresion is valid, this function calculates the result, following order of operations, and returns the result as a float. If the expresion is invalid, returns `nil`. To create a custom GUI, simply send the expresion string to this function, and receive the result.

If verbose, the function will print intermediary expressions (see TUI usage above). This is primarily intended for TUI use. Default is false.

#### check_expr(expr_arr)

Takes an expresion as an array of strings. e.g. "4 + 5" should be ["4", "+", "5"]. Valid expresions have at least 3 elements, start and end with a number, and alternate between numbers and operations. Returns true if the expression is valid, false otherwise.

Parentheses are not yet supported.

## more readme content coming as program gets implemented