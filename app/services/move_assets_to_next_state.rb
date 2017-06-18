class MoveAssetsToNextState

  include ActiveModel::Model

  attr_accessor :assets, :flash_status, :current_state, :team

  validates :assets, presence: true
  validates :current_state, presence: true

  def initialize(attributes={})
    super
    # this is not right and should be removed as soon as frontend is changed
    # team should always be passed to the service
    # it should always be the same team for all assets
    @team ||= assets.first.workflow.team
    @flash_status = :alert
  end

  def call
    current_procedure = team.procedure_for(current_state)
    next_procedure = team.procedure_after(current_procedure)
    ActiveRecord::Base.transaction do
      assets.each do |asset|
        # finish current procedure by marking asset as 'completed' or 'reported' if required
        asset.update(current_procedure.finishing_state)
        # move asset to the state of the next procedure
        asset.move_to_next(next_procedure.state) if next_procedure.present?
      end
      @flash_status = :notice
    end
  end

  def done?
    flash_status == :notice
  end

  def identifiers
    @identifiers = assets.map(&:identifier)
  end

  def message
    done? ? "#{current_state.name.humanize} is done for #{identifiers.to_sentence}" :
            "#{current_state.name.humanize} has not been finished for requested assets."
  end

  def redirect_state
    current_state.name
  end

end