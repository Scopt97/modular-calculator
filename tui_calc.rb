#!/usr/bin/env ruby
#tui_calc.rb
# Author: Kyle Nielsen
# Date created: 7/10/21
# Last update: 7/10/21
# Purpose: A practice project with the intent to create a GUI version later
# Credit:
# Future improvements:

# Valid operations, grouped based on order of operations
# This array is also used to determine order of operations
# carrot is a common symbol for power outside of coding, so it is included
# note: any operation added here should have a function
#       and an entry in ops_hash in calc()
OPS = [['^', '**'], ['*', '/'], ['+', '-']]  #TODO may need to use double quotes

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

# return x / y
def div(x, y)
  x / y  #TODO make sure int / int doesn't round
end

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
def calc(expr)
  # hash of str: func for operations
  ops_hash = {'+': method(:add), '-': method(:subt), '*': method(:mult), '/': method(:div), '**': method(:pow), '^': method(:pow)}

  # parse expr
  expr.strip!
  expr_arr = expr.split

  unless check_expr(expr_arr)
    return nil
  end

  # get op and values from expression
  op = expr_arr[1]
  x = expr_arr[0]
  y = expr_arr[2]

  result = ops_hash[op.to_sym].(x.to_f, y.to_f)  # call appropriate operation function

  # for more operstions:
  # once proper format is verified, can assume expr_arr[1] is op, [0] and [2] are x and y
  # temp_result = ops[op.to_sym].(x.to_num, y.to_num)
  # remove expr_arr[0] and [1]
  # expr_arr[0] = temp_result  # used to be [2] before removals
  # repeat until expr_arr has only one element (the final result)

  # for order of operations:
  # search for * or /, then + or -
  # op = [i], x = [i-1], y = [i+1]
  # call op
  # [i] = result, remove [i-1] and [i+1]
  # for parens: find open at [i], close at [j]
  # create sub-array from [i+1..j]. treat like expr_arr to solve
  # remove [i..j]
  # [i] = result


  return result
end

if __FILE__ == $0
  # get input
  puts "Instructions: enter a mathematical expression using +, -, *, /, or ** (^)"
  puts "e.g. 5 + 4"  #TODO extend example after more that one operation is supported
  puts "At this stage of development, only one operation is supported at a time"  #TODO remove when changed
  print "Enter an expression: "
  expr = gets  # no chomp or strip because it is handled in calc()

  # send to calc() and print result
  result = calc(expr)

  if result == nil
    puts "Please enter a valid expression"
    puts "Hint: all elements should be separated by spaces"
  elsif result.to_s[-1] == "0"  # print int if result is integer
    puts result.to_i
  else
    puts result
  end

  # continue until user enters "q" or "quit"
end