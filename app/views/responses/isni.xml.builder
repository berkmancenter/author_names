xml.instruct!
xml.responses do
  @response_hash.each_key do |questionnaire|
    xml.questionnaire do
      xml.id questionnaire.id
      @response_hash[questionnaire].each_key do |user| 
        xml.user do
          xml.id user
          questionnaire.form_items.each do |item|
            xml.item do
              response = Response.all(:conditions => {:questionnaire_id => questionnaire.id, :user_id => user}).select{|resp| resp.form_item_id == item.id}[0]
              xml.field_name item.field_name
              unless response.nil?
                xml.response response.response_text
              end  
            end  
          end
        end
      end  
    end
  end
end
