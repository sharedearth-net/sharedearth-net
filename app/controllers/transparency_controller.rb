class TransparencyController < ApplicationController
  layout :dynamic_layout
  
  def dynamic_layout
    if current_user.nil?
      'shared_earth'
    else
      'application'
    end
  end

  def index
  end

end
