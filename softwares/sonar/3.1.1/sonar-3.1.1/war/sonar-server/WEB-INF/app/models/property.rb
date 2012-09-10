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
# License along with {library}; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02
#
class Property < ActiveRecord::Base
  validates_presence_of :prop_key

  def key
    prop_key
  end

  def value
    text_value
  end

  def self.hash(resource_id=nil)
    hash={}
    Property.find(:all, :conditions => {'resource_id' => resource_id, 'user_id' => nil}).each do |prop|
      hash[prop.key]=prop.value
    end
    hash
  end

  def self.value(key, resource_id=nil, default_value=nil)
    prop=Property.find(:first, :conditions => {'prop_key' => key, 'resource_id' => resource_id, 'user_id' => nil})
    if prop
      prop.text_value || default_value
    else
      default_value
    end
  end

  def self.values(key, resource_id=nil)
    Property.find(:all, :conditions => {'prop_key' => key, 'resource_id' => resource_id, 'user_id' => nil}).collect { |p| p.text_value }
  end

  def self.set(key, value, resource_id=nil)
    text_value = (value.nil? ? nil : value.to_s)
    prop = Property.new(:prop_key => key, :text_value => text_value, :resource_id => resource_id)
    if prop.valid?
      Property.transaction do
        Property.delete_all('prop_key' => key, 'resource_id' => resource_id, 'user_id' => nil)
        prop.save
      end
      Java::OrgSonarServerUi::JRubyFacade.getInstance().setGlobalProperty(key, text_value) unless resource_id
    end
    prop
  end

  def self.clear(key, resource_id=nil)
    Property.delete_all('prop_key' => key, 'resource_id' => resource_id, 'user_id' => nil)
    Java::OrgSonarServerUi::JRubyFacade.getInstance().setGlobalProperty(key, nil) unless resource_id
  end

  def self.by_key(key, resource_id=nil)
    Property.find(:first, :conditions => {'prop_key' => key, 'resource_id' => resource_id, 'user_id' => nil})
  end

  def self.by_key_prefix(prefix)
    Property.find(:all, :conditions => ["prop_key like ?", prefix + '%'])
  end

  def self.update(key, value)
    property = Property.find(:first, :conditions => {:prop_key => key, :resource_id => nil, :user_id => nil});
    property.text_value = value
    property.save
    Java::OrgSonarServerUi::JRubyFacade.getInstance().setGlobalProperty(key, value)
    property
  end

  def to_hash_json
    {:key => key, :value => value.to_s}
  end

  def to_xml(xml=Builder::XmlMarkup.new(:indent => 0))
    xml.property do
      xml.key(prop_key)
      xml.value { xml.cdata!(text_value.to_s) }
    end
    xml
  end

  def java_definition
    @java_definition ||=
      begin
        Java::OrgSonarServerUi::JRubyFacade.getInstance().getPropertyDefinitions().get(key)
      end
  end

  def validation_error_message
    msg=''
    errors.each_full do |error|
      msg += Api::Utils.message("property.error.#{error}")
    end
    msg
  end

  private

  def validate
    if java_definition
      validation_result=java_definition.validate(text_value)
      errors.add_to_base(validation_result.getErrorKey()) unless validation_result.isValid()
    end
  end
end
