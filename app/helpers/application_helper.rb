module ApplicationHelper
  include Pagy::Frontend

  def format_date date
    date.strftime(Settings.date.format)
  end
end
