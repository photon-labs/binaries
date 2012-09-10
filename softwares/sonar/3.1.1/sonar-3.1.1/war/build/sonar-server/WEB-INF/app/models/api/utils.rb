#
# Sonar, entreprise quality control tool.
# Copyright (C) 2008-2012 SonarSource
# mailto:contact AT sonarsource DOT com
#
# Sonar is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Sonar is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with Sonar; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02
#
require 'time'

class Api::Utils

  # Format dateTime to ISO format
  def self.format_datetime(datetime)
    datetime.strftime("%Y-%m-%dT%H:%M:%S%z")
  end

  def self.parse_datetime(datetime_string, default_is_now=true)
    if datetime_string.blank?
      return (default_is_now ? Time.now : nil)
    end
    Time.parse(datetime_string)
  end

  def self.is_number?(s)
    true if Float(s) rescue false
  end

  def self.is_integer?(s)
    s.to_s =~ /\A[+-]?\d+\Z/
  end

  def self.markdown_to_html(markdown)
    markdown ? Java::OrgSonarServerUi::JRubyFacade.markdownToHtml(ERB::Util.html_escape(markdown)) : ''
  end

  # Splits a string into an array of lines
  # For history reference:
  #   - http://jira.codehaus.org/browse/SONAR-2282 first modified the behaviour to keep the trailing lines
  #   - then http://jira.codehaus.org/browse/SONAR-3003 reverted this modification to remove potential last empty line
  def self.split_newlines(input)
    result = input.split(/\r?\n|\r/, -1)
    result.pop if result.last==''
    result
  end

  def self.convert_string_to_unix_newlines(input)
    # Don't use '\n' here
    # See http://jira.codehaus.org/browse/SONAR-2571
    split_newlines(input).join("\n")
  end

  #
  # i18n
  # Since 2.10
  def self.message(key, options={})
    default = options[:default]
    params = options[:params]||[]
    Java::OrgSonarServerUi::JRubyFacade.getInstance().getMessage(I18n.locale, key, default, params.to_java)
  end

  #
  # Options :
  # - backtrace: append backtrace if true. Default value is false.
  #
  def self.exception_message(exception, options={})
    cause = exception
    if exception.is_a?(NativeException) && exception.respond_to?(:cause)
      cause = exception.cause
    end
    result = (cause.respond_to?(:message) ? "#{cause.message}\n" : "#{cause}\n")
    if options[:backtrace]==true && cause.respond_to?(:backtrace)
      result << "\t" + cause.backtrace.join("\n\t") + "\n"
    end
    result
  end

  # Returns a new array created by sorting arr
  # Since Sonar 3.0
  #
  # Examples :
  # Api::Utils.insensitive_sort(['foo', 'bar'])
  # Api::Utils.insensitive_sort([foo, bar]) { |elt| elt.nullable_field_to_compare }
  #
  def self.insensitive_sort(arr)
    if block_given?
      arr.sort do |a, b|
        a_string=yield(a) || ''
        b_string=yield(b) || ''
        a_string.downcase <=> b_string.downcase || a_string <=> b_string
      end
    else
      arr.sort do |a, b|
        a_string=a || ''
        b_string=b || ''
        a_string.downcase <=> b_string.downcase || a_string <=> b_string
      end
    end
  end


  # Sorts arr
  # Since Sonar 3.0
  #
  # Examples :
  # Api::Utils.insensitive_sort!(['foo', 'bar'])
  # Api::Utils.insensitive_sort!([foo, bar]) { |elt| elt.nullable_field_to_compare }
  #
  def self.insensitive_sort!(arr)
    if block_given?
      arr.sort! do |a, b|
        a_string=yield(a) || ''
        b_string=yield(b) || ''
        a_string.downcase <=> b_string.downcase || a_string <=> b_string
      end
    else
      arr.sort! do |a, b|
        a_string=a || ''
        b_string=b || ''
        a_string.downcase <=> b_string.downcase || a_string <=> b_string
      end
    end
  end

  #
  # Since Sonar 3.0
  #
  def self.valid_period_index?(index)
    Api::Utils.is_integer?(index) && index.to_i > 0 && index.to_i <6
  end

  #
  # Since Sonar 3.1
  #
  # Read content of HTTP POST request. Example: read_post_request_param(params[:backup])
  #
  def self.read_post_request_param(param_value)
    if param_value
      param_value.respond_to?(:read) ? param_value.read : param_value
    else
      nil
    end
  end
end
