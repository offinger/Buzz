  require 'digest' #digest je biblioteka koja sadrzi metode za hash-ovanje podataka
  class User < ActiveRecord::Base
  #attr_accessible method is important for preventing a mass assignment vulnerability, a distressingly common and often serious security hole in many Rails applications.
  
  #attr_accessor can be used for values you don't want to store in the database directly and that will only exist for the life of the object (e.g. passwords).
  
  #Trik je u tome, kada se unosi password prvi put, samo se enkriptova unosi u bazi zbog sigurnosti a password sluzi za proveru uslova i nece ici u bazu jer je insecure
  
  # attr_accessor je virtualni atribut koji ne mora da ide u bazu a moze da se koristi u memoriji za proveru uslova
  attr_accessor :password 
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_many :microposts, :dependent => :destroy
  
  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy
                           
  has_many :following, :through => :relationships, :source => :followed
  
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
                                   
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence => true,
                   :length => { :maximum => 50 }
                   
  validates :email,  :presence => true,
                     :format => { :with => email_regex },
                     :uniqueness => { :case_sensitive => false }
                    
  validates :password, :presence => true,
                       :confirmation => true,#:confirmation eleminise usere kojima se password i password_confirmation ne slazu
                       :length => { :within => 6..40 }
                       
                before_save :encrypt_password
                
                       def has_password?(submitted_password)
                         encrypted_password == encrypt(submitted_password)
                       end
                       
                       def self.authenticate(email, submitted_password)
                         user = find_by_email(email)
                         return nil if user.nil?
                         return user if user.has_password?(submitted_password)
                       end
                       
                       def self.authenticate_with_salt(id, cookie_salt)
                         user = find_by_id(id)
                         (user && user.salt == cookie_salt) ? user : nil
                       end
                       
                       def following?(followed)
                         relationships.find_by_followed_id(followed)
                       end
                       
                       def follow!(followed)
                         relationships.create!(:followed_id => followed.id)
                       end
                       
                       def unfollow!(followed)
                         relationships.find_by_followed_id(followed).destroy
                       end
                       
                       def feed
                         # This is preliminary. See Chapter 12 for the full implementation.
                         #Micropost.where("user_id = ?", id)
                         Micropost.from_users_followed_by(self)
                       end
                       
                       private
                       
                       def encrypt_password
                         self.salt = make_salt if new_record?
                         self.encrypted_password = encrypt(password)
                       end
                       
                       def encrypt(string)
                         secure_hash("#{salt}--#{string}")
                       end
                       
                       def make_salt
                        secure_hash("#{Time.now.utc}--#{password}")
                       end
                       
                       def secure_hash(string)
                         Digest::SHA2.hexdigest(string)
                       end
                  end
# user.errors.full_messages za proveru u konzoli ako nesto krene naopako
