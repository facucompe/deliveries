class NotFound < StandardError
  def status
    :NOT_FOUND
  end
end
