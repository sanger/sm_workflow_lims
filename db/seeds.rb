require './config/asset_types'
require './config/states'
require './config/workflows'
require './config/pipeline_destinations'

AssetTypeFactory.seed
PipelineDestinationFactory.seed
StateFactory.seed
WorkflowFactory.seed
