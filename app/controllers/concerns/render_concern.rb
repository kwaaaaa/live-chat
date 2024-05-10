module RenderConcern
  extend ActiveSupport::Concern
  private

  def render_turbo_stream_with_flash(message, status)
    flash.now[:error] = message
    render turbo_stream: turbo_stream.replace('flash_alert', partial: 'layouts/flash', locals: { flash: flash}),
           status: status
  end
end
