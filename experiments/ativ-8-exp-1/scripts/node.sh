#!/bin/bash

function launch_node {
  main_node_ip="${1}"
  num_nodes="${2}"

  log_experiment_settings
  start_dcgan "${main_node_ip}" "${num_nodes}"
}

function log_experiment_settings {
  log_in_category "Experiment settings" "Parsing experiment settings"
  log_basic_settings
}

function start_dcgan {
  main_node_ip="${1}"
  num_nodes="${2}"

  result_file_path="${EXPERIMENT_DIR_PATH}/GAN.out"
  error_file_path="${EXPERIMENT_DIR_PATH}/GAN.err"

  cd "${ROOT_DIR_PATH}"

  log_in_category "DCGAN" "Launching DCGAN. Results will being saved in ${result_file_path}"

  docker run \
    --env OMP_NUM_THREADS=1 \
    --rm \
    --network=host \
    -v=$(pwd):/root \
    -p 1234:1234 \
      dist_dcgan:latest \
      python -m \
        torch.distributed.launch \
          --nproc_per_node=1 \
          --nnodes="${num_nodes}" \
          --node_rank="${OMPI_COMM_WORLD_RANK}" \
          --master_addr="${main_node_ip}" \
          --master_port=1234 \
          dist_dcgan.py \
            --dataset cifar10 \
            --dataroot ./cifar10 \
            --num_epochs=1 > "${result_file_path}" 2> "${error_file_path}"

  log_in_category "DCGAN" "Finished executing"
}
