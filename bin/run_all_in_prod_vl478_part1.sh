#!/bin/bash
echo "Usage: ./run_all_in_prod_vl478_part1.sh  <Your_USER_ID> "
source ./install_puppet_agent.sh $1
#source ./download_code.sh  $1  ## Manual as this is an egg-or-chicken-first case
source ./prepare_code.sh

