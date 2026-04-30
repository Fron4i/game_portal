module Api
  module V1
    class BaseController < ActionController::API
      include Pagy::Backend

      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      private

      def record_not_found
        render json: { error: "not_found" }, status: :not_found
      end

      def pagy_meta(pagy)
        {
          count: pagy.count,
          page: pagy.page,
          pages: pagy.pages,
          limit: pagy.limit
        }
      end
    end
  end
end
