module ApplicationHelper

  def getS3GeneralUrl(image_name)
    return 'https://tbar-general.s3.amazonaws.com/images/'+image_name
  end
end
