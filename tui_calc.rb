#!/usr/bin/env ruby
#tui_calc.rb
# Author: Kyle Nielsen
# Date created: 7/10/21
# Last update: 9/7/21
# Purpose: A TUI calculator that can be used as a backend for a GUI calculator
# Credit: Nested bracket checking taken from UOregon Intermediate Data Structures
#         assignment tought by Professor Andrzej Proskurowski
# Future improvements: Don't require spaces between elements. e.g. (44+55)*66 should work
#                      Allow implicit multiplication with parens
#                      Get verbose output to work with parens
#                      Add more operations, such as %
#                      Adjust some things for efficiency. Theres a lot of looping
#                        through things, and some can probably be cut down.
#                        This is not a priority as anyone needing a hyper-efficient
#                        calculator will go for one written in C by an efficiency pro


# Valid operations, grouped based on order of operations
# This array is also used to determine order of operations
# carrot is a common symbol for power outside of coding, so it is included
# note: any operation added here should have a function
#       and an entry in ops_hash in calc()
OPS = [['^', '**'], ['*', '/'], ['+', '-']]

# Hash matching open brackets to the appropriate closing bracket
PAIRS = {'(' => ')', '[' => ']', '{' => '}', '<' => '>'}


# Functions for the different operations
# These are converted to symbols, then used as the values in ops_hash in clac()

# returns x + y
def add(x, y)
  x + y
end

# returns x - y
# note 't' at end to differentiate from sub method for strings
def subt(x, y)
  x - y
end

# returns x * y
def mult(x, y)
  x * y
end

# returns x / y
def div(x, y)
  x / y
end

# returns x ** y
def pow(x, y)
  x ** y
end

# check for properly nested parens
# returns an array of the form [[bracket, index in nest, index in expr_arr, match index], ...]
# if valid or nil if invalid nesting
# This version of nest checking is a bit more complex because I need to track
# match indexes for my calculator implementation
def check_parens(expr_arr)
  # set up
  nest = []  # Will hold the brackets from expr_arr. Form [[bracket, i, j, match j]]
              # where i is index in nest, j is index in expr_arr
  stack = []  # array used like stack
  nest_index = 0 # used to track our position in nest. I would use nest.shift,
                  # but I need to preserve nest because it has the info I want to return
  count = 0  # used to set i from above

  # put brackets from expression into nest
  expr_arr.each_index do |j|
    if PAIRS.key?(expr_arr[j]) or PAIRS.value?(expr_arr[j])
      nest.push([expr_arr[j], count, j, nil])
      count += 1
    end
  end

  # if there are no brackets, return
  if nest.length == 0
    return nest
  end

  # initialize stack
  stack.push(nest[nest_index])
  nest_index += 1

  # This loop checks if current bracket in nest matches top of stack. deletes them
  # if yes, adds bracket from nest to stack if no
  until nest_index == nest.length do
    # If stack is empty, init again
    if stack.empty?
      stack.push(nest[nest_index])
      nest_index += 1
    end

    # if match found, save index and pop stack
    # remember: [0] is bracket, [1] is index in nest, [2] is index in expr_arr
    #           and [3] is index of match in expr_arr
    if PAIRS[stack.last[0]] == nest[nest_index][0]
      nest[stack.last[1]][3] = nest[nest_index][2]
      nest[nest_index][3] = stack.last[2]
      nest_index += 1
      stack.pop
    else
      stack.push(nest[nest_index])
      nest_index += 1
    end
  end

  # if stack empty after getting to end of nest, nest is valid
  if stack.empty?
    return nest
  else
    return nil
  end
end

# takes an array and checks whether it is a valid mathematical expression
# i.e. start and end with num, alternate num and op
# need_check_parens determines whether to call check_parens or not
#   calc will send false because it calls check_parens itself since it needs
#   the match index info
def check_expr(expr_arr, need_check_parens=true) #TODO disallow "4 ( + 5 )". Not an issue for calc() because calc() recurses, but important for users calling this sepatately
  expr_arr = expr_arr.clone  # need to change expr_arr later w/o changing source

  if expr_arr.length < 3  # valid expression is at least 2 numbers and an operation
    return false
  end

  if need_check_parens
    unless check_parens(expr_arr)
      return false
    end
  end

  # brackets are valid, so remove them to test the expression
  # this method means implied multiplication like 5(4+3) doesn't work
  # this is okay because calc() can't handle implicit mult anyway
  brackets = ['(', ')', '{', '}', '[', ']', '<', '>']  #TODO get brackets from pairs hash so users may add custom brackets
  brackets.each do |brack| #TODO prob fix bug here. check for ops right of open or left of close. prob need to completely change this loop
    expr_arr.delete(brack)
  end

  # first and last must be numbers (if not parentheses)
  if expr_arr[0].respond_to?(:to_f) and expr_arr[-1].respond_to?(:to_f)
    valid = true
    expr_arr.each_index do |i|
      if i % 2 == 0  # if i even
        unless expr_arr[i].respond_to?(:to_f)  # even elements must be numbers
          valid = false
        end
      else  # if i odd
        unless OPS.flatten.include?(expr_arr[i])  # odd elements must be operations
          valid = false
        end
      end
    end

    return valid

  else
    return false
  end
end

# Takes a valid math expresion (string) and returns the result as a float
# or nil if expression is invalid
# The elements of the expresion should be seperated by spaces
# If verbose, prints the new expression after each intermediary calculation
def calc(expr, verbose=false)
  # hash of str: func for operations
  ops_hash = {'+': method(:add), '-': method(:subt),
              '*': method(:mult), '/': method(:div),
              '**': method(:pow), '^': method(:pow)}

  # parse expr
  expr.strip!
  expr_arr = expr.split

  # check expression validity
  unless check_expr(expr_arr, false)
    return nil
  end

  j = 0  # used to track index while handling parens

  # find matching parens, then replace parens and contents with result of contents
  while j < (expr_arr.length - 1) do
    # check parens and get nest info. needs to be done inside this loop
    # if not, info fails to match as expression changes
    nest = check_parens(expr_arr)
    unless nest
      return nil
    end

    match_j = nil  # Initialize match_j so later code can find it
    # find open paren
    if PAIRS.key?(expr_arr[j])
      # find matching close paren
      nest.each do |info_arr|
        if info_arr[2] == j
        match_j = info_arr[3]
        end
      end

      # join contents and send to calc
      temp_expr = expr_arr[j+1...match_j].join(' ')
      temp_result = calc(temp_expr)

      # return if internal expression was invalid
      unless temp_result
        return nil
      end

      # replace parens and contents with temp result
      expr_arr[j..match_j] = temp_result
      j = 0  # indices got moved and removed, so start from beginning
    else
      j += 1
    end
  end

  result = 0  # initialize result variable so the return statement can find it

  # search for operations in order
  OPS.each do |op_set|
    i = 0

    # search expression for current operations
    # if found: calculate, replace, and search from begining of expression
    # else: move to next element in expression
    while i < (expr_arr.length - 1) do
      if op_set.include?(expr_arr[i])
        # find and assign operation and values
        op = expr_arr[i]
        x = expr_arr[i-1]
        y = expr_arr[i+1]

        # call appropriate op function
        result = ops_hash[op.to_sym].(x.to_f, y.to_f)

        # replace the 3 used elements with the result
        expr_arr[i-1..i+1] = result
        i = 0  # indices got moved and removed, so start from beginning

        # print verbose output
        if verbose and not expr_arr.length == 1
          puts expr_arr.join(" ")
        end
      else
        i += 1
      end
    end
  end
  return result
end


# TUI for when calculator is run from command line
# accepts an optional command line argument -v for verbose output
if __FILE__ == $0
  # determine whether to use verbose outpuut
  verbose = false
  if ARGV[0] != nil and ARGV[0].downcase == "-v"
    verbose = true
  end

  # get input
  puts "Instructions: enter a mathematical expression using +, -, *, /, **, or (q)uit"
  puts "Calculator follows order of operations"
  puts "All elements must be separated by spaces"
  puts "e.g. ( 4 + 5 ) * 6"
  print "Enter an expression: "
  expr = STDIN.gets.strip

  # continue calculating expressions until user quits
  until expr.downcase.start_with?("q")
    # send to calc() and print result
    result = calc(expr, verbose)

    if result == nil
      puts "Please enter a valid expression"
      puts "Hint: all elements should be separated by spaces"
    elsif result % 1 == 0  # print int if result is integer
      puts result.to_i
    else
      puts result
    end

   print "enter another expression, or (q)uit: "
   expr = STDIN.gets.strip
  end
end