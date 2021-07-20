# Modular Calculator

## What?

A calculator app with seperate GUI and back end. Backend has a TUI if executed directly. Or it can be used like an API/module/library that takes a string that is a valid mathematical expression and returns the result. This will allow others to create their own calculator GUIs without having to implement logic for parsing, order of operations, etc.

## Requirements

Ruby. This was made with ruby 3.0.1, but should work with earlier versions of ruby.

## Usage

### TUI

Either execute using ruby: `ruby tui_calc.rb` or make the file executable and execute directly: `./tui_calc.rb`

The program accepts one optional command line argument -v. If given, the program will print verbose output. This means printing intermediary expressions during calculation.  
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

#### check_expr(expr_arr, need_check_parens=true)

Takes an expresion as an array of strings. e.g. "4 + 5" should be ["4", "+", "5"]. Valid expresions have at least 3 elements, start and end with a number, and alternate between numbers and operations. Returns true if the expression is valid, false otherwise.

need_check_parens determines whether or not to call check_parens(). If you need info on matching paren indices, it is recommended that you send false and call check_parens yourself

#### check_parens(expr_arr)
Takes an array and determines whether it has properly nested parentheses. Works with these bracket types: (), {}, [], <>. The function finds the brackets, so the array can contain any elements, not just brackets. Returns nil if the nesting is invalid, returns an array with index info if the nesting is valid.

The array is of the form [[paren, i, j, match j], ...]]  
Where paren is the bracket as a string, i is its index in the returned array, j is its index in expr_arr, and match j is the index of the bracket's match in expr_arr. The array contains one such entry for every bracket in expr_arr.

Although this function has been implemented, the program still does not yet support parentheses.

## more readme content coming as program gets implemented