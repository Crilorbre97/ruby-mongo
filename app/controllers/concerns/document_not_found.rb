module DocumentNotFound
    extend ActiveSupport::Concern
    
    included do
        rescue_from Mongoid::Errors::DocumentNotFound, :with => :error_render_method

        protected
        def error_render_method(exception)
            render json: { error: exception.problem }, status: :not_found
        end
    end
end