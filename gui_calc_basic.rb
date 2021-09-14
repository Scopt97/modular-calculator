#!/usr/bin/env ruby
#gui_calc_basic.rb
# Author: Kyle Nielsen
# Date created: 9/8/21
# Last update: 9/10/21
# Purpose: A GUI to complement tui_calc. Basic text entry version.
# Credit: https://github.com/kojix2/LibUI for the ruby version of libui, as well
#           as examples used to help put my GUI together.
# Future improvements: Make a normal executable. Users using a GUI may not be
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
MAIN_WINDOW = UI.new_window('Calculator', 250, 100, 1)
UI.window_set_margined(MAIN_WINDOW, 1)
UI.window_on_closing(MAIN_WINDOW, should_quit)


# Vertical Box
vbox = UI.new_vertical_box
UI.window_set_child(MAIN_WINDOW, vbox)
UI.box_set_padded(vbox, 1)

# Horizontal Box
hbox = UI.new_horizontal_box
UI.box_set_padded(hbox, 1)
UI.box_append(vbox, hbox, 1)

# Result
result_label = UI.new_label('Separate all elements with spaces')
UI.box_append(vbox, result_label, 1)

# Expression Entry
expr_entry = UI.new_entry
UI.entry_set_text expr_entry, ''
UI.box_append(hbox, expr_entry, 1)

# Submit/= Button
button_eq = UI.new_button('=')
UI.button_on_clicked(button_eq) do
  expr = UI.entry_text(expr_entry).to_s
  result = calc(expr).to_s

  # case where result was nil (invalid expression)
  if result == ""
    result = "Invalid expression.\nDid you use spaces?"
  end

  UI.label_set_text(result_label, result)
end
UI.box_append(hbox, button_eq, 0)


UI.control_show(MAIN_WINDOW)

UI.main
UI.quit