#!/usr/bin/env ruby
#gui_calc.rb
# Author: Kyle Nielsen
# Date created: 9/8/21
# Last update: 9/10/21
# Purpose: A GUI to complement tui_calc. Not menat to be pretty, just meant to work.
# Credit: https://github.com/kojix2/LibUI for the ruby version of libui, as well
#           as examples used to help put my GUI together.
# Future improvements: When tui_calc stops requiring spaces, manual expression
#                        entry will be more user-friendly.
#                      Make a normal executable. Users using a GUI may not be
#                        familiar with the terminal

require 'libui'
require_relative 'tui_calc'

UI = LibUI
UI.init

should_quit = proc do
  UI.control_destroy(MAIN_WINDOW)
  UI.quit
  0
end

# Main Window
MAIN_WINDOW = UI.new_window('Calculator', 400, 500, 1)
UI.window_set_margined(MAIN_WINDOW, 1)
UI.window_on_closing(MAIN_WINDOW, should_quit)


# Vertical Box
vbox = UI.new_vertical_box
UI.window_set_child(MAIN_WINDOW, vbox)
UI.box_set_padded(vbox, 1)

# Horizontal Boxes
# rows are organized bottom to top, like nums on a calculator

row5 = UI.new_horizontal_box
UI.box_set_padded(row5, 1)
UI.box_append(vbox, row5, 1)

row4 = UI.new_horizontal_box
UI.box_set_padded(row4, 1)
UI.box_append(vbox, row4, 1)

row3 = UI.new_horizontal_box
UI.box_set_padded(row3, 1)
UI.box_append(vbox, row3, 1)

row2 = UI.new_horizontal_box
UI.box_set_padded(row2, 1)
UI.box_append(vbox, row2, 1)

row1 = UI.new_horizontal_box
UI.box_set_padded(row1, 1)
UI.box_append(vbox, row1, 1)

row0 = UI.new_horizontal_box
UI.box_set_padded(row0, 1)
UI.box_append(vbox, row0, 1)

# Entry
calc_entry = UI.new_entry
UI.entry_set_text calc_entry, ""
UI.box_append(row5, calc_entry, 1)

# Buttons #TODO Allow multi-digit numbers. if prev char is num, don't add space

# Row 0
button_dot = UI.new_button('.')
UI.button_on_clicked(button_dot) do
  curr_expr = UI.entry_text(calc_entry).to_s
  new_expr = curr_expr.rstrip + "."
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row0, button_dot, 1)

button0 = UI.new_button('0')
UI.button_on_clicked(button0) do
  curr_expr = UI.entry_text(calc_entry).to_s

  # if last char is num, remove trailing space
  # allows for multi-digit numbers
  if curr_expr.strip != "" and curr_expr.rstrip[-1].numeric?
    curr_expr = curr_expr.rstrip
  end
  new_expr = curr_expr + "0 "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row0, button0, 1)

button_eq = UI.new_button('=')
UI.button_on_clicked(button_eq) do
  expr = UI.entry_text(calc_entry).to_s
  result = calc(expr)

  # handle special cases
  if result == nil  # result is nil
    result = "Invalid expression"
  elsif result % 1 == 0  # result is int
    result = result.to_i.to_s + " "
  else
    result = result.to_s + " "
  end

  UI.entry_set_text(calc_entry, result)
end
UI.box_append(row0, button_eq, 1)

button_add = UI.new_button('+')
UI.button_on_clicked(button_add) do
  curr_expr = UI.entry_text(calc_entry).to_s
  new_expr = curr_expr + "+ "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row0, button_add, 1)

# Row 1
button1 = UI.new_button('1')
UI.button_on_clicked(button1) do
  curr_expr = UI.entry_text(calc_entry).to_s
  if curr_expr.strip != "" and curr_expr.rstrip[-1].numeric?
    curr_expr = curr_expr.rstrip
  end
  new_expr = curr_expr + "1 "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row1, button1, 1)

button2 = UI.new_button('2')
UI.button_on_clicked(button2) do
  curr_expr = UI.entry_text(calc_entry).to_s
  if curr_expr.strip != "" and curr_expr.rstrip[-1].numeric?
    curr_expr = curr_expr.rstrip
  end
  new_expr = curr_expr + "2 "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row1, button2, 1)

button3 = UI.new_button('3')
UI.button_on_clicked(button3) do
  curr_expr = UI.entry_text(calc_entry).to_s
  if curr_expr.strip != "" and curr_expr.rstrip[-1].numeric?
    curr_expr = curr_expr.rstrip
  end
  new_expr = curr_expr + "3 "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row1, button3, 1)

button_sub = UI.new_button('-')
UI.button_on_clicked(button_sub) do
  curr_expr = UI.entry_text(calc_entry).to_s
  new_expr = curr_expr + "- "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row1, button_sub, 1)

# Row 2
button4 = UI.new_button('4')
UI.button_on_clicked(button4) do
  curr_expr = UI.entry_text(calc_entry).to_s
  if curr_expr.strip != "" and curr_expr.rstrip[-1].numeric?
    curr_expr = curr_expr.rstrip
  end
  new_expr = curr_expr + "4 "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row2, button4, 1)

button5 = UI.new_button('5')
UI.button_on_clicked(button5) do
  curr_expr = UI.entry_text(calc_entry).to_s
  if curr_expr.strip != "" and curr_expr.rstrip[-1].numeric?
    curr_expr = curr_expr.rstrip
  end
  new_expr = curr_expr + "5 "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row2, button5, 1)

button6 = UI.new_button('6')
UI.button_on_clicked(button6) do
  curr_expr = UI.entry_text(calc_entry).to_s
  if curr_expr.strip != "" and curr_expr.rstrip[-1].numeric?
    curr_expr = curr_expr.rstrip
  end
  new_expr = curr_expr + "6 "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row2, button6, 1)

button_mul = UI.new_button('*')
UI.button_on_clicked(button_mul) do
  curr_expr = UI.entry_text(calc_entry).to_s
  new_expr = curr_expr + "* "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row2, button_mul, 1)

# Row 3
button7 = UI.new_button('7')
UI.button_on_clicked(button7) do
  curr_expr = UI.entry_text(calc_entry).to_s
  if curr_expr.strip != "" and curr_expr.rstrip[-1].numeric?
    curr_expr = curr_expr.rstrip
  end
  new_expr = curr_expr + "7 "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row3, button7, 1)

button8 = UI.new_button('8')
UI.button_on_clicked(button8) do
  curr_expr = UI.entry_text(calc_entry).to_s
  if curr_expr.strip != "" and curr_expr.rstrip[-1].numeric?
    curr_expr = curr_expr.rstrip
  end
  new_expr = curr_expr + "8 "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row3, button8, 1)

button9 = UI.new_button('9')
UI.button_on_clicked(button9) do
  curr_expr = UI.entry_text(calc_entry).to_s
  if curr_expr.strip != "" and curr_expr.rstrip[-1].numeric?
    curr_expr = curr_expr.rstrip
  end
  new_expr = curr_expr + "9 "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row3, button9, 1)

button_div = UI.new_button('/')
UI.button_on_clicked(button_div) do
  curr_expr = UI.entry_text(calc_entry).to_s
  new_expr = curr_expr + "/ "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row3, button_div, 1)

# Row 4
button_del = UI.new_button('del')
UI.button_on_clicked(button_del) do
  curr_expr = UI.entry_text(calc_entry).to_s
  new_expr = curr_expr.rstrip[0...-1]
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row4, button_del, 1)

button_open = UI.new_button('(')
UI.button_on_clicked(button_open) do
  curr_expr = UI.entry_text(calc_entry).to_s
  new_expr = curr_expr + "( "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row4, button_open, 1)

button_close = UI.new_button(')')
UI.button_on_clicked(button_close) do
  curr_expr = UI.entry_text(calc_entry).to_s
  new_expr = curr_expr + ") "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row4, button_close, 1)

button_exp = UI.new_button('^')
UI.button_on_clicked(button_exp) do
  curr_expr = UI.entry_text(calc_entry).to_s
  new_expr = curr_expr + "^ "
  UI.entry_set_text(calc_entry, new_expr)
end
UI.box_append(row4, button_exp, 1)

# Row 5
button_clr = UI.new_button('C')
UI.button_on_clicked(button_clr) do
  UI.entry_set_text(calc_entry, "")
end
UI.box_append(row5, button_clr, 0)



UI.control_show(MAIN_WINDOW)

UI.main
UI.quit