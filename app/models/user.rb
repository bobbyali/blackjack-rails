class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :players
  has_many :games, through: :players
  #before_save :default_values

  def get_player_score
  	if self.games_won.nil?
  		return 0
  	else
  		return self.games_won
  	end
  end

  def is_signed_in?
  	if self.current_sign_in_ip.nil?
  		return false
  	else
  		return true
  	end
  end

  private

    #def default_values
    #    self.cpu_player ||= false
    #end    
end
