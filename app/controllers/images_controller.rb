class ImagesController < ApplicationController
  def create
    @image = Image.new(image_params)
    @image.build_task
    @image.save
  end

  private
  def image_params
    params.require(:image).permit(:id, :attachment)
  end
end