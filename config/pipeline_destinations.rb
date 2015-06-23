module PipelineDestinationFactory
  def self.pipeline_destinations
    [
      {:name=>'Destination A'},
      {:name=>'Destination B'},
      {:name=>'Destination C'}
    ]
  end

  def self.seed
    PipelineDestination.create!(pipeline_destinations)
  end

  def self.update
    ActiveRecord::Base.transaction do
      pipeline_destinations.each do |at|
        PipelineDestination.find_or_initialize_by(name:at[:name]).tap do |pd|
          pd.update_attributes(at)
        end.save!
      end
    end
  end
end
