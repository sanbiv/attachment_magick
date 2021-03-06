require "test_helper"

class AttachmentMagick::AttachmentMagickHelperTest < ActionView::TestCase
  setup do
    create_artist
    create_work(@artist)
    create_place
  end

  def test_attachment_progress_container
    html = attachment_progress_container(@artist)
    assert        assert_element_in(html, "div[@id='attachmentProgressContainer']")
    assert        assert_element_in(html, "span[@id='attachmentButton']")
    assert        assert_element_in(html, "input[@id='attachmentmagick_key']")
    assert_equal  "Artist_#{@artist.id}", assert_element_value(html, "input[@id='attachmentmagick_key']", "data_attachment")

    html = attachment_progress_container(@artist.works.first)
    assert        assert_element_in(html, "div[@id='attachmentProgressContainer']")
    assert        assert_element_in(html, "span[@id='attachmentButton']")
    assert        assert_element_in(html, "input[@id='attachmentmagick_key']")
    assert_equal  "Artist_#{@artist.id}_works_#{@artist.works.first.id}", assert_element_value(html, "input[@id='attachmentmagick_key']", "data_attachment")

    html = attachment_progress_container(@place)
    assert        assert_element_in(html, "div[@id='attachmentProgressContainer']")
    assert        assert_element_in(html, "span[@id='attachmentButton']")
    assert        assert_element_in(html, "input[@id='attachmentmagick_key']")
    assert_equal  "Place_#{@place.id}", assert_element_value(html, "input[@id='attachmentmagick_key']", "data_attachment")
  end

  def test_attachment_for_view
    html = attachment_for_view(@artist)
    assert assert_element_in(html, "a[@class='remove_image']")
    assert assert_element_in(html, "input[@id='image_id']")

    html = attachment_for_view(@artist, example_partial)
    assert assert_element_in(html, "div[@class='image_caption']")
    assert assert_element_in(html, "div[@class='image_thumb']")
    assert assert_element_in(html, "img")

    html = attachment_for_view(@place)
    assert assert_element_in(html, "a[@class='remove_image']")
    assert assert_element_in(html, "input[@id='image_id']")

    html = attachment_for_view(@place, example_partial)
    assert assert_element_in(html, "div[@class='image_caption']")
    assert assert_element_in(html, "div[@class='image_thumb']")
    assert assert_element_in(html, "img")
  end

  def test_attachment_for_video
    html = attachment_for_video(@artist)

    assert assert_element_in(html, "input")
    assert assert_element_in(html, "a[@class='video_upload']")
  end

  def test_attachment_for_flash
    @artist.images.create(:photo => example_file)

    html = attachment_for_flash(@artist.images.first.photo.url)
    assert assert_element_in(html, "object")
    assert assert_element_in(html, "object[@width='100'][@height='60']")
  end
  
  def test_should_resize_video
    html = "<iframe width=\"450\" height=\"250\"></iframe>"
    assert_equal(resize_video(html, 300), "<iframe width='300' height='200'></iframe>")
  end
      
end
