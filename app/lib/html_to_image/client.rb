# frozen_string_literal: true

module HtmlToImage
  API_URL = 'https://hcti.io/'
  API_KEY = 'x'
  USER_ID = 'x'

  # Singleton client - converter
  class Client
    include Singleton

    attr_reader :html, :css

    def img_for_task(task)
      @params = task
      @template = File.read(file_path + '/views/task.html.erb')
      @css = File.read(file_path + '/styles/task.css')
      render_template

      conn = Faraday.new(API_URL)
      conn.basic_auth(USER_ID, API_KEY)

      res = conn.post('v1/image', {html: @html, css: @css})

      JSON.parse(res.body)["url"]
    end

    private

    def file_path
      File.expand_path(File.dirname(__FILE__))
    end

    def render_template
      ERB.new(@template, 0, "", "@html").result(binding)
    end
  end
end