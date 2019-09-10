# frozen_string_literal: true

module Aid::Colorize
  module_function

  def self.included(base)
    colorize = self

    base.class_eval do
      extend colorize
    end
  end

  COLOR_CODES = {
    black: 30,
    blue: 34,
    brown: 33,
    cyan: 36,
    dark_gray: 90,
    green: 32,
    light_blue: 94,
    light_cyan: 96,
    light_gray: 37,
    light_green: 92,
    light_purple: 95,
    light_red: 91,
    light_yellow: 93,
    purple: 35,
    red: 31,
    white: 97,
    yellow: 33,

    command: 96,
    error: 91,
    info: 93
  }.freeze

  def colorize(color, string)
    "\e[#{COLOR_CODES[color]}m#{string}\e[0m"
  end
end
