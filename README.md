# IPSSA [![license](https://img.shields.io/badge/license-MIT-brightgreen)](https://github.com/pegi3s/ipssa) [![dockerhub](https://img.shields.io/badge/hub-docker-blue)](https://hub.docker.com/r/pegi3s/ipssa) [![compihub](https://img.shields.io/badge/hub-compi-blue)](https://www.sing-group.org/compihub/explore/5d5bb64f6d9e31002f3ce30a)
> **IPSSA** (Integrated Positively Selected Sites Analyses) is a [compi](https://www.sing-group.org/compi/) pipeline to XXXYYYZZZ. A Docker image is available for this pipeline in [this Docker Hub repository](https://hub.docker.com/r/pegi3s/ipssa).

## IPSSA repositories

- [GitHub](https://github.com/pegi3s/ipssa)
- [DockerHub](https://hub.docker.com/r/pegi3s/ipssa)
- [CompiHub](https://www.sing-group.org/compihub/explore/5d5bb64f6d9e31002f3ce30a)

# What does IPSSA do?

**IPSSA** (Integrated Positively Selected Sites Analyses) is a [compi](https://www.sing-group.org/compi/) pipeline to XXXYYYZZZ.
 
IPSSA applies the same steps to each input FASTA file separately. This process comprises:
    1. Checking if the input FASTA file contains contains ambiguous nucleotide positions or non-multiple of three sequences. If so, the pipeline stops at this point and the files must be fixed.
    2. Extract a random subset of sequences according to the sequence limit specified.
    3. Translate to protein sequences and perform sequence alignment on the aligned sequences.
    4. The aligned protein sequences are then backtranslated to produce a master DNA alignment, used to:
        4.1 Run phipack.
        4.2 Create the PSS subsets for CodeML, omegaMap, and FUBAR, according to the number of replicas specified for each method.
    5. The aligned protein sequences are also filtered to remove positions corresponding to aminoacids with low support. These filtered files are converted into DNA files, which are split into the same subsets than the master DNA alignment files. These are the Mr. Bayes PSS subsets, used to run Mr. Bayes on them.
    6. Run phipack for each one of the PSS subsets.
    7. Run Mr. Bayes for each one of the PSS subsets (using the filtered DNA files produced in step 5).
    8. Run CodeML, omegaMap, and FUBAR, using their corresponding PSS subsets.
    9. Finally, gather the results of all PSS methods into a tabular format.

# Using the IPSSA image in Linux
In order to use the IPSSA image, create first a directory in your local file system (`ipssa_project` in the example) with the following structure: 

```bash
ipssa_project/
├── input
│   ├── 1.fasta
│   ├── 2.fasta
│   ├── .
│   ├── .
│   ├── .
│   └── n.fasta
└── ipssa-project.params
```

Where:
- The input FASTA files to be analized must be placed in the `ipssa_project/input` directory.
- If neccessary, the Compi parameters file is located at `ipssa_project/ipssa-project.params`.

## Running IPSSA without a parameters file

Once this structure and files are ready, you should run and adapt the following commands to run the entire pipeline using the default parameters (i.e. without a Compi parameters file). Here, you only need to set `PROJECT_DIR` to the right path in your local file system and `COMPI_NUM_TASKS` to the maximum number of parallel tasks that can be run. Pipeline parameters can be added at the end of the pipeline (e.g. `--sequence_limit 10`). Note that the `--host_working_dir` is mandatory and must point to the pipeline working directory in the host machine.

```bash
PROJECT_DIR=/path/to/ipssa_project
COMPI_NUM_TASKS=6

PIPELINE_WORKING_DIR=${PROJECT_DIR}/pipeline_working_dir
INPUT_DIR=${PROJECT_DIR}/input

# Run with default parameter values
docker run -v /tmp:/tmp -v /var/run/docker.sock:/var/run/docker.sock -v ${PIPELINE_WORKING_DIR}:/working_dir -v ${INPUT_DIR}:/input --rm pegi3s/ipssa -o --logs /working_dir/logs --num-tasks ${COMPI_NUM_TASKS} -- --host_working_dir ${PIPELINE_WORKING_DIR}
```

## Running IPSSA with a parameters file

If you want to specify the pipeline parameters using a Compi parameters file, you should run and adapt the following commands to run the entire pipeline using the default parameters (i.e. without a Compi parameters file). Here, you only need to set `PROJECT_DIR` to the right path in your local file system and `COMPI_NUM_TASKS` to the maximum number of parallel tasks that can be run. 

```bash
PROJECT_DIR=/path/to/ipssa_project
COMPI_NUM_TASKS=6

PIPELINE_WORKING_DIR=${PROJECT_DIR}/pipeline_working_dir
INPUT_DIR=${PROJECT_DIR}/input
PARAMS_DIR=${PROJECT_DIR}

docker run -v /tmp:/tmp -v /var/run/docker.sock:/var/run/docker.sock -v ${PIPELINE_WORKING_DIR}:/working_dir -v ${INPUT_DIR}:/input -v ${PARAMS_DIR}:/params --rm pegi3s/ipssa -o --logs /working_dir/logs --num-tasks ${COMPI_NUM_TASKS} -pa /params/ipssa-project.params
```

As the `host_working_dir`, a minimal Compi parameters file must contain it:

```
host_working_dir=/path/to/ipssa_project/pipeline_working_dir
```

## Extra

### Find out tasks with errors

Some tasks may produce errors that do not cause the pipeline to fail, but they can be important. Such errors are reported in the log files produced in the `logs` directory of the pipeline working directory. The `find-error-tasks.sh` script of the `pegi3s/ipssa` Docker image displays the errored tasks (i.e. those containing the word error in their log files) along with the names of the corresponding input files. Run the following command to find them (assuming the environment variables with the project and working directory paths have been declared):

```bash
docker run --entrypoint /opt/scripts/find-error-tasks.sh -v ${PIPELINE_WORKING_DIR}:/working_dir -v ${INPUT_DIR}:/input --rm pegi3s/ipssa /working_dir/logs /input
```

### Re-running the pipeline

To re-run the pipeline in the same project directory, run the following command first in order to clean the pipeline working directory:

```bash
sudo rm -rf ${PIPELINE_WORKING_DIR}
``` 

# Pipeline parameters

These are the pipeline parameters:
		
- `sequence_limit`: The maximum number of sequences to use.
- `random_seed`: The random seed.
- `align_method`: The alignment method to use, one of: `clustalw`, `muscle`, `kalign`, `t_coffee`, or `amap`.
- `tcoffee_min_score`: Minimum support value for columns.
- `fubar_sequence_limit`: XXXYYYZZZ.
- `omegamap_sequence_limit`: XXXYYYZZZ.
- `codeml_sequence_limit`: XXXYYYZZZ.
- `fubar_runs`: XXXYYYZZZ.
- `omegamap_runs`: XXXYYYZZZ.
- `codeml_runs`: XXXYYYZZZ.
- `mrbayes_generations`: XXXYYYZZZ.
- `mrbayes_burnin`: XXXYYYZZZ.
- `mrbayes_model`: XXXYYYZZZ.
- `mrbayes_rates`: XXXYYYZZZ.
- `codeml_models`: XXXYYYZZZ.
- `omegamap_recomb`: Runs OmegaMap only if recombination is detected in the master file.
- `omegamap_iterations`: Number of OmegaMap iterations.


# For Developers

## Building the Docker image

To build the Docker image, [`compi-dk`](https://www.sing-group.org/compi/#downloads) is required. Once you have it installed, simply run `compi-dk build` from the project directory to build the Docker image. The image will be created with the name specified in the `compi.project` file (i.e. `pegi3s/ipssa:latest`). This file also specifies the version of compi that goes into the Docker image.
