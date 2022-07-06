#!/bin/bash
docker exec -ti $(docker ps -q -f name=sm_workflow_lims) $@
