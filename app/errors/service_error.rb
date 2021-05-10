class ServiceError < StandardError
  def status
    :SERVICE_ERROR
  end
end
