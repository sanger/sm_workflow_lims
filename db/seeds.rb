require './config/asset_types'
require './config/steps'
require './config/flows'
require './config/workflows'
require './config/pipeline_destinations'

AssetTypeFactory.seed
PipelineDestinationFactory.seed
StepFactory.seed
FlowFactory.seed
WorkflowFactory.seed
