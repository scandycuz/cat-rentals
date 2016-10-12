require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @rendered ? true : false
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Aleady rendered" if @rendered
    @res.header["location"] = url
    @res.status = 302
    @rendered = true
    @session.store_session(res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Aleady rendered" if @rendered
    @res['Content-Type'] = content_type
    @res.body = [content]
    @rendered = true
    @session.store_session(res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    controller_name = self.class.to_s.underscore
    file = "views/#{controller_name}/#{template_name}.html.erb"
    template_content = File.read(file)
    erb_content = ERB.new(template_content).result(binding)
    render_content(erb_content, "text/html" )
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
