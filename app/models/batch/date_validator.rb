class Batch
  module DateValidator
    def valid_date_provided
      @date = nil
      return true unless begun_at.present?

      begin
        @date = DateTime.strptime(begun_at, '%d/%m/%Y') + 12.hours
        raise ArgumentError unless @date < DateTime.now
      rescue ArgumentError
        errors.add(:dates, 'must be in the format DD/MM/YYYY and cannot be in the future.')
      end
    end
  end
end
