class MockEssaysController < ApplicationController

  def download_file
    @mock_essay = MockEssay.find(params[:id])
    url = @mock_essay.essay.url
    data = open(url)
    send_data data.read, filename: @mock_essay.essay_file_name, type: "application/pdf", stream: 'true', buffer_size: '4096'
  end
end
