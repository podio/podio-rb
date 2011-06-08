# Serves as the base for Contacts and Organization Contacts
class Podio::Profile < ActivePodio::Base
  property :profile_id, :integer
  property :name, :string
  property :avatar, :integer
  property :image, :hash
  property :birthdate, :date
  property :department, :string
  property :vatin, :string
  property :skype, :string
  property :about, :string
  property :address, :array
  property :zip, :string
  property :city, :string
  property :country, :string
  property :im, :array
  property :location, :array
  property :mail, :array
  property :phone, :array
  property :title, :array
  property :url, :array
end
