# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class JargonExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/jargon"
  
  # define_routes do |map|
  #   map.connect 'admin/jargon/:action', :controller => 'admin/jargon'
  # end
  
  def activate
    ApplicationHelper.class_eval{
      def save_model_button(model)
        label = if model.new_record?
          "Create #{model.class.name}"[:create]
        else
          'Save Changes'[:save_changes]
        end
        submit_tag label, :class => 'button'
      end

      def save_model_and_continue_editing_button(model)
        submit_tag 'Save and Continue Editing'[:save_and_continue], :name => 'continue', :class => 'button'
      end
      
      def updated_stamp(model)
        unless model.new_record?
          updated_by = (model.updated_by || model.created_by)
          login = updated_by ? updated_by.login : nil
          time = (model.updated_at || model.created_at)
          if login or time
            html = %{<p style="clear: left"><small>#{"Last updated"[:last_updated]} } 
            html << %{#{"by"[:by]} #{login} } if login
            html << %{#{"at"[:at]} #{ timestamp(time) }} if time
            html << %{</small></p>}
            html
          end
        else
          %{<p class="clear">&nbsp;</p>}
        end
      end
    }
    # Translate Main Menu
    admin.tabs.remove "Pages"
    admin.tabs.add "Seiten", "/admin/pages", :before => "Snippets"
    
    admin.tabs.remove "Snippets"
    admin.tabs.add "Snippets", "/admin/snippets", :before => "Layouts", :visibility => [:admin, :developer]
    
    admin.tabs.remove "Assets"
    admin.tabs.add "Dateien", "/admin/assets", :after => "Seiten"
    
    admin.tabs.remove "Layouts"
    admin.tabs.add "Layouts", "/admin/layouts", :after => "Snippets", :visibility => [:admin, :developer]
    
    admin.tabs.remove "Settings"
    admin.tabs.add "Einstellungen", "/admin/settings", :after => "Layouts", :visibility => [:admin, :developer]
  end
  
  def deactivate
    # admin.tabs.remove "Jargon"
  end
  
end