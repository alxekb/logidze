# frozen_string_literal: true

module Logidze
  module IgnoreLogData # :nodoc:
    extend ActiveSupport::Concern

    included do
      if Rails::VERSION::MAJOR == 4
        require "logidze/ignore_log_data/ignored_columns"
        attribute :log_data, ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Jsonb.new
      elsif Rails::VERSION::MAJOR == 5
        require "logidze/ignore_log_data/cast_attribute_patch"
        include CastAttributePatch
      end

      scope :with_log_data, lambda {
        if ignored_columns == ["log_data"]
          select(arel_table[Arel.star])
        else
          select(column_names + [arel_table[:log_data]])
        end
      }
    end
  end
end
