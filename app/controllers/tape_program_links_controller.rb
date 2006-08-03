class TapeProgramLinksController < ApplicationController
  sidebar :general

  before_filter :require_no_ssl if (RAILS_ENV == "production")

  scaffold :TapeProgramLink
end
