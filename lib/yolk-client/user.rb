module YolkClient
  class User < Entity
    # Immutable properties
    property :id, :immutable => true
    property :username, :immutable => true
    property :directory_id, :immutable => true

    property :active, :default => true
    property :description

    attribute :first_name
    attribute :last_name
    attribute :student_id
    attribute :display_name
    attribute :email

    def errors
      errors = super
      errors[:username] = "cannot be blank" if username.to_s == ""
      errors
    end
  end
end
