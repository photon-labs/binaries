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
class SettingsController < ApplicationController

  SECTION=Navigation::SECTION_CONFIGURATION

  SPECIAL_CATEGORIES=['email', 'encryption', 'server_id']

  verify :method => :post, :only => ['update'], :redirect_to => {:action => :index}

  def index
    access_denied unless is_admin?
    load_properties(nil)
    @category ||= 'general'
  end

  def update
    @project=nil
    resource_id=nil
    if params[:resource_id]
      @project=Project.by_key(params[:resource_id])
      access_denied unless (@project && is_admin?(@project))
      resource_id=@project.id
    else
      access_denied unless is_admin?
    end
    is_global=(@project.nil?)

    load_properties(@project)

    @persisted_properties_per_key={}
    if @category && @definitions_per_category[@category]
      @definitions_per_category[@category].each do |property|
        value=params[property.getKey()]
        persisted_property = Property.find(:first, :conditions => {:prop_key=> property.key(), :resource_id => resource_id, :user_id => nil})

        # update the property
        if persisted_property
          if value.empty?
            Property.delete_all('prop_key' => property.key(), 'resource_id' => resource_id, 'user_id' => nil)
            java_facade.setGlobalProperty(property.getKey(), nil) if is_global
          elsif persisted_property.text_value != value.to_s
            persisted_property.text_value = value.to_s
            if persisted_property.save && is_global
              java_facade.setGlobalProperty(property.getKey(), value.to_s)
            end
            @persisted_properties_per_key[persisted_property.key]=persisted_property
          end

        # create the property
        elsif value.present?
          persisted_property=Property.new(:prop_key => property.key(), :text_value => value.to_s, :resource_id => resource_id)
          if persisted_property.save && is_global
            java_facade.setGlobalProperty(property.getKey(), value.to_s)
          end
          @persisted_properties_per_key[persisted_property.key]=persisted_property
        end
      end

      params[:layout]='false'
      render :partial => 'settings/properties'
    end
  end

  private

  def load_properties(project)
    @category=params[:category]
    @definitions_per_category={}
    definitions = java_facade.getPropertyDefinitions()
    definitions.getAll().select { |property_definition|
      (project.nil? && property_definition.isGlobal()) || (project && project.module? && property_definition.isOnModule()) || (project && project.project? && property_definition.isOnProject())
    }.each do |property_definition|
      category = definitions.getCategory(property_definition.getKey())
      @definitions_per_category[category]||=[]
      @definitions_per_category[category]<<property_definition
    end

    SPECIAL_CATEGORIES.each do |category|
      @definitions_per_category[category]=[]
    end
  end
end
