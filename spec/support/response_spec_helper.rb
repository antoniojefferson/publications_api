module ResponseSpecHelper
  def json
    JSON.parse(response.body)
  end

  def errors
    json['errors']
  end
end
