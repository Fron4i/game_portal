class StyleguideController < ApplicationController
  def show
    flash.now[:notice]  = t("iwebix.styleguide.flash.notice")
    flash.now[:alert]   = t("iwebix.styleguide.flash.alert")
    flash.now[:warning] = t("iwebix.styleguide.flash.warning")
    flash.now[:info]    = t("iwebix.styleguide.flash.info")
  end
end
