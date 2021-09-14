# Modular Calculator

## What?

A calculator app with seperate GUI and back end. Backend has a TUI if executed directly. Or it can be used like an API/module/library that takes a string that is a valid mathematical expression and returns the result. This will allow others to create their own calculator GUIs without having to implement logic for parsing, order of operations, etc.

## Requirements

Ruby. This was made with Ruby 3.0.1, but should work with earlier versions of Ruby.  
The GUI requires the 'libui' rubygem

## Usage

### TUI

Either execute using ruby: `ruby tui_calc.rb` or make the file executable and execute directly: `./tui_calc.rb`

The program accepts one optional command line argument -v. If given, the program will print verbose output. This means printing intermediary expressions during calculation. Only works without parentheses.  
e.g. `4 + 5 * 6` will print `4 + 30.0` before printing `34`.

The program will prompt for a methematical expresion. Valid operations are displayed. Separate different elements using spaces. e.g. `4 + 5` is right, but `4+5` is wrong.

The program will continue prompting for new expressions until the user enters `(q)uit`

### GUI

#### Basic GUI

Run with `ruby gui_calc_basic.rb` or make executable and do `./gui_calc_basic.rb`

This GUI is text entry only, with no buttons. Like the TUI, this still requires spaces between all elements.  
The GUI consists of an expression entry field, an equals button, and a label that displays the result. Simply type the expression (with spaces) into the entry field, then click '='.

#### Full GUI

Run the same way as basic GUI, but the file is called `gui_calc.rb`

This is a full calculator GUI, with buttons and the ability to edit the expression manually. Like the other interfaces, manual entry still requires spaces. The buttons put a space after the character when pressed, and remove when needed (i.e. decimals can't be surrounded by spaces), so button entry requires no special thought.  
The interface should be intuitive and work as expected. The 'del' key deletes the last character (unaffected by spaces), and 'C' deletes the entire expression. When the result is displayed, it already includes a space at the end, so users can easily do further calculations with the result.

### As a module/library

#### valid operations

+: addition  
-: subtraction  
*: multiplication  
/: division  
** or ^: exponent

#### adding new operations

Users may modify tui_calc.rb to add more operations. Doing so requires three steps.  
First, add an entry in OPS global array. This is an array of arrays. Order of operations is determined by the order of the top-level array. Operations in each sub-array are excetuted on a first-seen first-executed basis, so order doesn't matter, and the sub-arrays can be thought of like sets. Either add your new operation to a sub-array, or create a new sub-array, depending on when your new operation should be executed.  
Second, create a function for your operation. In theory, this function could be anything as long as it takes two floats as input and returns one as output.  
Finally, add an entry to ops_hash in calc(). This hash maps the string for an operation to its function. The existing entries can be used as an example of proper syntax.

New brackets can also be added. Simply add an entry to the global PAIRS hash.

#### calc(expr, verbose=false)

Takes an expresion as a string. Elements (including parentheses) should be separated by spaces. Calls `check_expr` to check whether the expresion is valid (see section below for details). If the expresion is valid, this function calculates the result, following order of operations, and returns the result as a float. If the expresion is invalid, returns `nil`. To create a custom GUI, simply send the expresion string to this function, and receive the result.

Implicit multiplication is not supported. e.g. 4 ( 5 - 6 ) is invalid. 4 * ( 5 - 6 ) should be used instead.

If verbose, the function will print intermediary expressions (see TUI usage above). This is primarily intended for TUI use. Default is false. Doesn't work properly for expressions with parentheses.

#### check_expr(expr_arr, need_check_parens=true)

Takes an expresion as an array of strings. e.g. "4 + 5" should be ["4", "+", "5"]. Valid expresions have at least 3 elements, start and end with a number, and alternate between numbers and operations (not counting parentheses). Valid expressions do not contain operations immediately inside parentheses (e.g. 4 ( + 5) and ( 4 + ) 5 are wrong). Implicit multiplication is not supported. Returns true if the expression is valid, false otherwise.

need_check_parens determines whether or not to call check_parens(). If you need information on matching paren indices, it is recommended that you send false and call check_parens yourself.

#### check_parens(expr_arr)
Takes an array and determines whether it has properly nested parentheses. Works with these bracket types: (), {}, [], <>. The function finds the brackets, so the array can contain any elements, not just brackets. Returns nil if the nesting is invalid, returns an array with index info if the nesting is valid.

The array is of the form [[paren, i, j, match j], ...]  
Where paren is the bracket as a string, i is its index in the returned array, j is its index in expr_arr, and match j is the index of the bracket's match in expr_arr. The array contains one such entry for every bracket in expr_arr.

This method could even be used outside of a calculator context if someone needed matching bracket information for another reason. For this purpose, check_parens() works with the <> bracket type, despite it not traditionally being used as brackets in math.

## Known Bugs

Verbose output does not work for expressions containing parentheses. This is likely due to the recursion done in calc() when an expression contains parentheses.

## more readme content coming as program gets implemented