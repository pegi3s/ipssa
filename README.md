# FastScreen [![license](https://img.shields.io/badge/license-MIT-brightgreen)](https://github.com/pegi3s/pss-fs) [![dockerhub](https://img.shields.io/badge/hub-docker-blue)](https://hub.docker.com/r/pegi3s/pss-fs) [![compihub](https://img.shields.io/badge/hub-compi-blue)](https://www.sing-group.org/compihub/explore/5d5bb64f6d9e31002f3ce30a)
> **FastScreen** is a [compi](https://www.sing-group.org/compi/) pipeline to identify datasets that likely show evidence for positive selection and thus should be the subject of detailed, time-consuming analyses<sup>1</sup>. A Docker image is available for this pipeline in [this Docker Hub repository](https://hub.docker.com/r/pegi3s/pss-fs).

## FastScreen repositories

- [GitHub](https://github.com/pegi3s/pss-fs)
- [DockerHub](https://hub.docker.com/r/pegi3s/pss-fs)
- [CompiHub](https://www.sing-group.org/compihub/explore/5d5bb64f6d9e31002f3ce30a)

# Using the FastScreen image in Linux
In order to use the FastScreen image, create first a directory with name `compi_fss_working_dir/input` in your local file system. `compi_fss_working_dir` is the name of the working directory of the pipeline where the output results and intermediate files will be created. The input FASTA files to be analized must be placed in the `compi_fss_working_dir/input` directory.

# Test data
The sample data is available [here](https://github.com/pegi3s/pss-fs/tree/master/resources/test-data). Download the FASTA files and put them inside the directory `compi_fss_working_dir/input` in your local file system. Please, note that the folder `input` must remain with that name as the pipeline will look for the FASTA files there.

Then, you should adapt and run the following commands:

```bash
WORKING_DIR=/path/to/compi_fss_working_dir

mkdir -p ${WORKING_DIR}/logs

docker run -v ${WORKING_DIR}:/working_dir --rm pegi3s/pss-fs --logs /working_dir/logs
```
In these commands, you should replace:
- `/path/to/compi_fss_working_dir` to the actual path in your file system.

# Extra
To re-run the pipeline in the same working directory, run the following command first in order to clean it:

```bash
sudo rm -rf ${WORKING_DIR}/ali ${WORKING_DIR}/renamed_seqs ${WORKING_DIR}/logs ${WORKING_DIR}/tree ${WORKING_DIR}/FUBAR_files ${WORKING_DIR}/FUBAR_results ${WORKING_DIR}/short_list ${WORKING_DIR}/to_be_reevaluated_by_codeML ${WORKING_DIR}/codeML_random_list ${WORKING_DIR}/codeML_results ${WORKING_DIR}/tree.codeML ${WORKING_DIR}/codeML_short_list ${WORKING_DIR}/negative_list ${WORKING_DIR}/files_requiring_attention ${WORKING_DIR}/FUBAR_short_list && mkdir -p ${WORKING_DIR}/logs
``` 

```bash
WORKING_DIR=/home/hlfernandez/Investigacion/Colaboraciones/IBMC-JorgeVieira/Pipelines/PSS-Paula/pss-dp/working_dir/pipeline_working_dir
INPUT_DIR=/home/hlfernandez/Investigacion/Colaboraciones/IBMC-JorgeVieira/Pipelines/PSS-Paula/pss-dp/working_dir/input
PARAMS_DIR=/home/hlfernandez/Investigacion/Colaboraciones/IBMC-JorgeVieira/Pipelines/PSS-Paula/pss-dp/working_dir/
COMPI_NUM_TASKS=6

# Run with default values
docker run -v /var/run/docker.sock:/var/run/docker.sock -v ${WORKING_DIR}:/working_dir -v ${INPUT_DIR}:/input -v ${PARAMS_DIR}:/params --rm pegi3s/pss-dp -o --logs /working_dir/logs --num-tasks ${COMPI_NUM_TASKS} -- --host_working_dir ${WORKING_DIR}

# Run with compi.params file
docker run -v /var/run/docker.sock:/var/run/docker.sock -v ${WORKING_DIR}:/working_dir -v ${INPUT_DIR}:/input -v ${PARAMS_DIR}:/params --rm pegi3s/pss-dp -o --logs /working_dir/logs --num-tasks ${COMPI_NUM_TASKS} -pa /params/compi.params

rm -rf ${WORKING_DIR}/*

# Get the running times
docker run -v /var/run/docker.sock:/var/run/docker.sock -v ${WORKING_DIR}:/working_dir --rm --entrypoint /bin/bash pegi3s/pss-dp /opt/scripts/get_running_times.sh /working_dir/console.log /working_dir/running_times.txt
```
