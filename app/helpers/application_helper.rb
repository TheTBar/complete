module ApplicationHelper

  def getS3GeneralUrl(image_name)
    return 'https://tbar-general.s3.amazonaws.com/images/'+image_name
  end

  def getURLForProduct2ifItExistsIfNotGetProduct1(image)
    if image.attachment.exists?(:product2)
      return image.attachment.url(:product2)
    else
      return image.attachment.url(:product)
    end
  end

end
