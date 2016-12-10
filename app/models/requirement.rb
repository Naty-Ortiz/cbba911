class Requirement < ActiveRecord::Base
  belongs_to :document


  def self.delete_null_fields
    Requirement.destroy_all(document_id: nil)

  end

end
