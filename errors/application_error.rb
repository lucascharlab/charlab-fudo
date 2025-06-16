class ApplicationError < StandardError
  attr_reader :status

  def initialize(message = nil, status = 500)
    @status = status
    super(message)
  end
end

class BadRequestError < ApplicationError
  def initialize(message = 'Bad Request')
    super(message, 400)
  end
end

class UnauthorizedError < ApplicationError
  def initialize(message = 'Unauthorized')
    super(message, 401)
  end
end

class ForbiddenError < ApplicationError
  def initialize(message = 'Forbidden')
    super(message, 403)
  end
end

class NotFoundError < ApplicationError
  def initialize(message = 'Not Found')
    super(message, 404)
  end
end

class MethodNotAllowedError < ApplicationError
  def initialize(message = 'Method Not Allowed')
    super(message, 405)
  end
end 