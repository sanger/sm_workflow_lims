require 'csv'

class Report
  include ActiveModel::Model

  attr_accessor :workflow_id, :workflow, :start_date, :end_date

  validates :workflow, :start_date, :end_date, presence: true
  validate :correctness_of_period, if: :dates_present?

  def to_csv
    CSV.generate do |csv|
      csv << [title]
      csv << column_names.map(&:humanize)
      rows.each do |row|
        csv << row.data_for(column_names)
      end
    end
  end

  def column_names
    %w[study project cost_code_name assets_count]
  end

  def title
    from = start_date.strftime(date_format)
    to = end_date.strftime(date_format)
    "Report for '#{workflow.name}' workflow from #{from} to #{to}"
  end

  def rows
    @rows ||= create_rows
  end

  def workflow_id=(workflow_id)
    @workflow = Workflow.find_by(id: workflow_id)
  end

  def start_date=(start_date)
    @start_date = start_date.to_datetime.beginning_of_day if start_date.present?
  end

  def end_date=(end_date)
    @end_date = end_date.to_datetime.end_of_day if end_date.present?
  end

  def date_format
    '%d/%m/%Y'
  end

  private

  def create_rows
    [].tap do |rows|
      assets_data.each do |data|
        rows << Row.new(data)
      end
    end
  end

  def assets_data
    @assets_data ||= Asset.generate_report_data(start_date, end_date, workflow)
  end

  def correctness_of_period
    errors.add(:start_date, 'should be earlier than the end date.') unless start_date <= end_date
  end

  def dates_present?
    start_date.present? && end_date.present?
  end

  class Row
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def data_for(column_names)
      data.values_at(*column_names).map { |el| el || 'Not defined' }
    end
  end
end
