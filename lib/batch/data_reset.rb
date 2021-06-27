class Batch::DataReset
  def self.data_reset
    guest_user = User.find_by(email: 'guest@example.com')
    guest_user.destroy
  end
end