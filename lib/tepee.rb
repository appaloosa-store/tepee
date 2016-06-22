# encoding: utf-8
# frozen_string_literal: true

require 'tepee/version'

# Tepee configuration helper for the braves
class Tepee
  class << self
    attr_accessor :env_var_prefix

    protected

    def add(name, default, env_var: "#{env_var_prefix}#{name}")
      value = ENV[String(env_var).upcase] || default
      const_set(String(name).upcase, value)
      define_singleton_method(name) { value }
      self
    end

    SEP = '_'.freeze
    MISSING_BLOCK = 'Missing block'.freeze

    def section(name, &block)
      raise MISSING_BLOCK unless block_given?
      new_env_var_prefix = "#{String(name)}#{SEP}"
      unless env_var_prefix.nil?
        new_env_var_prefix = "#{env_var_prefix}#{new_env_var_prefix}"
      end
      klass = Class.new(self)
      klass.env_var_prefix = new_env_var_prefix.upcase
      klass.instance_exec(&block)
      const_set(String(name).upcase, klass)
      define_singleton_method(name) { klass }
    end
    self
  end
end
