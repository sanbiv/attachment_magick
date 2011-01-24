class Publisher::ImagesController < ActionController::Base
  protect_from_forgery  :except => :create
  respond_to            :html, :js
  
  before_filter :load_klass
  
  def create
    @image = @klass.images.create(:photo => params[:Filedata])
    @klass.save
    
    render :partial => AttachmentMagick.configuration.default_add_partial, :collection => [@image], :as => :image, :locals => { :size => @klass.publisher }
  end
  
  def update_sortable
    array_ids = params[:images]
    hash      = {}
    
    array_ids.each_with_index do |id, index|
      hash.merge!( {"#{index}" => {:id => "#{id}", :priority => index}} )
    end

    @klass.images_attributes = hash
    @klass.save
    
    render :text => "ok"
  end
  
  def destroy
    @klass.images.find(params[:id]).destroy
    render :text => "ok"
  end
    
  private
  
  def load_klass
    klass   = params[:klass].capitalize.constantize
    @klass  = klass.find(params[:klass_id])
  end
end