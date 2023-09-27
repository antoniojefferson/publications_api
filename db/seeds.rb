# Creating the admin user to use in the system
user = User.find_or_initialize_by(
  name: 'Administrator',
  email: 'administrator@gmail.com'
)
user.password = 'admin@temp123'
user.save
