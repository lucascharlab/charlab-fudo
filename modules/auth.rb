require 'bcrypt'
require 'jwt'
require 'securerandom'

module Auth
  JWT_SECRET = ENV['JWT_SECRET'] || 'your-secret-key' # In production, use ENV variable

  def self.register(email, password)
    return { status: 400, body: { error: 'Email and password are required' } } if email.nil? || password.nil?

    # In a real app, you would check if the email already exists
    hashed_password = BCrypt::Password.create(password)
    
    # Store user in database (simplified for this example)
    user_id = SecureRandom.uuid
    $users ||= {}
    $users[user_id] = { email: email, password: hashed_password }

    { status: 201, body: { message: 'User registered successfully' } }
  end

  def self.login(email, password)
    return { status: 400, body: { error: 'Email and password are required' } } if email.nil? || password.nil?

    # In a real app, you would look up the user in the database
    user = $users&.values&.find { |u| u[:email] == email }
    return { status: 401, body: { error: 'Invalid credentials' } } unless user

    return { status: 401, body: { error: 'Invalid credentials' } } unless BCrypt::Password.new(user[:password]) == password

    # Generate JWT token
    user_id = $users.key(user)
    token = JWT.encode({ user_id: user_id }, JWT_SECRET, 'HS256')

    { status: 200, body: { token: token } }
  end
end 