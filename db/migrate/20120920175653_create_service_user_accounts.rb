class CreateServiceUserAccounts < ActiveRecord::Migration

  def up
    # And pre-populate with our service users
    ServiceUser.create :username => 'picard', :password => 'm@keItS0!', :email => 'hrwa-portal-admins@libraries.cul.columbia.edu'
    ServiceUser.create :username => 'computer', :password => 'D3structS3qu3nc31,cod31-1A', :email => 'hrwa-computer@libraries.cul.columbia.edu'
  end

end
