#!/usr/bin/env ruby
#tui_calc.rb
# Author: Kyle Nielsen
# Date created: 7/10/21
# Last update: 7/12/21
# Purpose: A practice project with the intent to create a GUI version later
# Credit:
# Future improvements:

# Valid operations, grouped based on order of operations
# This array is also used to determine order of operations
# carrot is a common symbol for power outside of coding, so it is included
# note: any operation added here should have a function
#       and an entry in ops_hash in calc()
OPS = [['^', '**'], ['*', '/'], ['+', '-']]

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
def mult(x,  y)
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

# takes an array and checks whether it is a valid mathematical expression
# i.e. start and end with num, alternate num and op
#TODO doesn't work with parentheses
def check_expr(expr_arr)
  if expr_arr.length < 3  # valid expression is at least 2 numbers and an operation
    return false

  elsif expr_arr[0].respond_to?(:to_f) and expr_arr[-1].respond_to?(:to_f)  # check first and last
    valid = true
    expr_arr.each_index do |i|
      if i % 2 == 0  # if i even
        unless expr_arr[i].respond_to?(:to_f)  # even elements must be numbers
          valid = false
        end
      else  # if i odd
        unless OPS.flatten.include?(expr_arr[i])  # odd elements must be expressions
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
  ops_hash = {'+': method(:add), '-': method(:subt), '*': method(:mult), '/': method(:div), '**': method(:pow), '^': method(:pow)}

  # parse expr
  expr.strip!
  expr_arr = expr.split

  unless check_expr(expr_arr)
    return nil
  end

  #TODO delete when not needed
  # # get op and values from expression
  # op = expr_arr[1]
  # x = expr_arr[0]
  # y = expr_arr[2]

  # # call appropriate operation function
  # result = ops_hash[op.to_sym].(x.to_f, y.to_f)

  # # delete first two elements, set third to result
  # # this will allow execution of further operations (4 + 5 + 6 becomes 9 + 6)
  # expr_arr.shift(2)
  # expr_arr[0] = result

  # # recurse until all operations are complete
  # if expr_arr.length == 1
  #   return result
  # else
  #   return calc(expr_arr.join(" "))
  # end
  #TODO end delete

  # for order of operations:
  # search for * or /, then + or -
  # op = [i], x = [i-1], y = [i+1]
  # call op
  # [i] = result, remove [i-1] and [i+1]
  # for parens: find open at [i], close at [j]
  # create sub-array from [i+1..j]. treat like expr_arr to solve
  # remove [i..j]
  # [i] = result
  result = 0  # initialize result variable so the return statement can find it
  OPS.each do |op_set|
    i = 0
    while i < (expr_arr.length - 1) do
      if op_set.include?(expr_arr[i])
        # find and assign operation and values
        op = expr_arr[i]
        x = expr_arr[i-1]
        y = expr_arr[i+1]

        # call appropriate op function
        result = ops_hash[op.to_sym].(x.to_f, y.to_f)

        # replace the 3 used elements with the result
        expr_arr.delete_at(i-1)
        expr_arr.delete_at(i-1)
        expr_arr[i-1] = result
        i = 0
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
# accepts an optional bool argument (default false) for verbose output
if __FILE__ == $0
  # determine whether to use verbose outpuut
  verbose = false
  if ARGV[0] != nil and ARGV[0].downcase == "true"
    verbose = true
  end

  # get input
  puts "Instructions: enter a mathematical expression using +, -, *, /, **, or (q)uit"
  puts "Calculator follows order of operations, but doesn't support parantheses"
  puts "e.g. 4 + 5 * 6"  #TODO extend example after more tparantheses are supported
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