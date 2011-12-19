module ApplicationHelper
  
  #vraca titl stranice, embedovan
  
  def title
    base_title="Ruby on Rails Tutorial Sample App"
    
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title} "
    end
  end
  
  def logo
   image_tag("logo.png", :alt => "Sample App", :class => "round")
  end
  
  def slika
    slika = image_tag("bw_logo.png")
  end
  
end
