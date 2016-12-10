class Revision < ActiveRecord::Base
  belongs_to :document
  belongs_to :verification_list

  def self.delete_null_fields
    Revision.destroy_all(verification_list_id: nil)
  end

end
