# Stores full data on seen items
# Used to cache items and render them later if need be (e.g. RSS, SMS)

class SeenItem
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :subscription

  # origin subscription
  field :subscription_id
  field :subscription_type
  field :subscription_interest_in

  # for convenience, interest object this came from
  field :interest_id

  # result fields from remote source
  field :item_id
  field :data, :type => Hash
  field :date, :type => Time
  field :search_url # search URL that originally produced this item
  field :find_url # if this came from a find request, produce that URL


  index [
    [:subscription_id, Mongo::ASCENDING],
    [:item_id, Mongo::ASCENDING]
  ]

  validates_presence_of :subscription_id
  validates_presence_of :item_id

  def url
    if subscription.adapter.respond_to? :find_url
      subscription.adapter.find_url item_id, data
    end
  end
end