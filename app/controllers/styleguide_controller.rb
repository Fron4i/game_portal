class StyleguideController < ApplicationController
  skip_after_action :verify_authorized, :verify_policy_scoped

  def show
  end
end
