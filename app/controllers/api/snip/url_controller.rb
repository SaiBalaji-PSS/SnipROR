require "nanoid"
class Api::Snip::UrlController < ApplicationController
  skip_before_action :check_authorization, only: [ :redirect_to_full_url ]
  def shorten_url
    short_code = Nanoid.generate(size: 3)
    puts current_user.email
    full_url_from_body = shorten_url_params[:full_url]
    url_data = current_user.urls.new
    url_data.short_code = short_code
    url_data.url = full_url_from_body
    url_data.thumnailimage = ThumbnailExtractor.extract(full_url_from_body)
    if url_data.save
      render json: { issuccess: true, message: "Url data saved successfully", code: short_code }, status: :ok
    else
      render json: { issuccess: false, message: url_data.errors.full_messages.to_sentence }, status: :ok
    end
  end
  def redirect_to_full_url
    short_code = params[:code]
    matching_url_record = Url.find_by({ short_code: short_code })
    if matching_url_record
      matching_url_record.increment!(:click_count) # increment and saves the record that's why !
      redirect_to matching_url_record.url, allow_other_host: true # allow_other_host is needed if not it will throw error
    else
      render json: { issucess: false, message: "Url with shortcode not found" }, status: :ok
    end
  end

  def get_all_urls
    render json: { issucess: true, urls: current_user.urls }, status: :ok
  end
  def delete_url_with_id
    matching_url_record = current_user.urls.find_by({ id: params[:id] })

    if matching_url_record
      if matching_url_record.destroy
        render json: { is_success: true, message: "URL deleted successfully" }, status: :ok
      else
        render json: { is_success: false, message: "Unable to delete URL" }, status: :ok
      end
    else
      render json: { is_success: false, message: "URL with given ID not found" }, status: :ok
    end
  end


  private
  def shorten_url_params
    params.permit(:full_url)
  end
end
