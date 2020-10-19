class ImagesController < ApplicationController
  def create
    printer = Product.find_by_id(params[:id])
    @product_photo = printer.prodcut_photos.create(photo_params)
  end

    # strong params
  private
    def photo_params
      params.require(:images).permit(:attachment)
    end
end