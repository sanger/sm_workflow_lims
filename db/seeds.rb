require './config/data/asset_types'
require './config/data/states'
require './config/data/teams'
require './config/data/workflows'
require './config/data/pipeline_destinations'

AssetTypeFactory.seed
PipelineDestinationFactory.seed
StateFactory.seed
TeamFactory.seed
WorkflowFactory.seed
