class UserSerializer < ActiveModel::Serializer
  attributes :id,:nickname,:created_at,:updated_at

  def attributes
    data = super
    if scope and scope.can_access_complete_credentials_of(object)
      data[:email] = object.email
      data[:auth_token] = object.auth_token
    end
    return data
  end

end
