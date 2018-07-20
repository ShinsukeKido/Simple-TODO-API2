class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid do
    key = @todo.errors.messages.keys.join(', ')
    errors = [
      { title: 'バリデーションに失敗しました', status: 422, source: { pointer: "/data/attributes/#{key}" } },
    ]
    render json: { errors: errors }, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: { errors: [{ title: '見つかりませんでした', status: 404 }] }, status: :not_found
  end
end
