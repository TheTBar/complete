Deface::Override.new(:virtual_path => 'spree/babes/x_form',
                     :name => 'temporary_babe_fields',
                     :insert_before => "erb[loud]:contains('f.submit \"Show me the goods\"')",
                     :text => "
                      vixen<%= f.text_field :vixen_value %><br>
                      romantic<%= f.text_field :romantic_value %><br>
                      flirt<%= f.text_field :flirt_value %><br>
                      sophisticate<%= f.text_field :sophisticate_value %><br>
                    ");