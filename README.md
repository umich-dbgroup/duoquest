# duoquest

Dual-specification query synthesis with natural language and table sketch
queries.

## Quickstart

**Dependencies**:
- Docker 19.03+
- NVIDIA GPU
- [NVIDIA Docker](https://github.com/NVIDIA/nvidia-docker)

**TODO**: Simplify this process with Docker compose - cannot do this until
[issue](https://github.com/docker/compose/issues/6691) with GPUS is resolved.

1. Set the variable correctly for the most recent version.
```
export DQ_VERSION=0.1
```
2. Start the Docker network (`dq-net`).
```
docker network create dq-net
```
3. Run the data container (`dq-data`).
```
docker run --rm -dit --name dq-data -v dq-vol:/home/data chrisjbaik/duoquest-data:$DQ_VERSION
```
4. Run the Enumerator (`dq-enum`) using one of the following instructions.
```
docker run --rm --gpus all -dit --name dq-enum --network dq-net -v dq-vol:/workspace/data chrisjbaik/duoquest-enum:$DQ_VERSION

# Add `--toy` for fast-starting debugging mode with decreased performance
docker run --rm --gpus all -dit --name dq-enum --network dq-net -v dq-vol:/workspace/data chrisjbaik/duoquest-enum:$DQ_VERSION --toy
```
5. Run the task database container (`dq-task-db`).
```
docker run --rm -dit --name dq-task-db --network dq-net chrisjbaik/duoquest-task-db:$DQ_VERSION
```
6. Run the autocomplete container (`dq-autocomplete`).
```
docker run --rm -dit --name dq-autocomplete --network dq-net redis
```
7. Run the web interface container (`dq-web`). Note the `-p` option, where the first port number indicates which port the web interface will run on the host machine. Also note the `WORKERS_PER_CORE` option, which determines how many workers will run for the web server (we set it to `0.1` because we have a 32-core server).
```
docker run --rm -dit -p 5000:80 -e WORKERS_PER_CORE="0.1" --name dq-web --network dq-net -v dq-vol:/home/data chrisjbaik/duoquest-web:$DQ_VERSION
```
8. Run the main container (`dq-main`). The `--timeout` flag indicates how many seconds each task will run before giving up.
```
docker run --rm -dit --name dq-main --network dq-net -v dq-vol:/home/data chrisjbaik/duoquest-main:$DQ_VERSION --timeout=60
```

## Simulation Experiments

### Run

Follow the instructions in steps 1-7 under **Quickstart** above. Instead of starting the `dq-main` container with the default entrypoint, we run simulation experiments using the following command:

```
docker run --rm -dit --name dq-main --network dq-net -v dq-vol:/home/data --entrypoint="python" chrisjbaik/duoquest-main experiments.py spider dev default
```

The last 3 arguments indicate the dataset, subset of dataset, and type of evaluation (`default`, `partial`, `minimal`, `nlq_only`, `tsq_only`, `chain`), respectively.

If `dq-main` is already running, shut down and remove that container using `docker stop` and `docker rm` if needed to ensure this container can run.

If you want to view the experiment progress in real-time, use the following:

```
docker logs -f dq-main
```

The results will automatically be saved in a `results` folder within the shared volume `dq-vol`.

### Result Summary/Analysis

The following container can be executed to generate a viewable result summary/analysis after running a simulation experiment:
```
docker run --rm -it --name dq-eval --network dq-net -v dq-vol:/home/data --entrypoint="python" chrisjbaik/duoquest-main eval.py spider dev default
```

Note that all arguments (including any additional arguments unmentioned above, like `--timeout`) must **exactly match** the arguments executed when running the `dq-main` container for running the experiment!

## Task Database Schema

The task database has the following schema:

**Tasks**

| Column Name | Type | Description |
| ----------- | ---- | ----------- |
| tid | text | task id |
| db | text | database name |
| nlq | text | natural language query |
| nlq_with_literals | text | raw NLQ including tag markup |
| tsq_proto | blob | table sketch query protobuf |
| literals_proto | blob | literals protobuf |
| status | text | `waiting`, `running`, `done`, or `error` |
| time | integer | timestamp for task submission time |
| error_msg | text | error message, if any |

**Databases**

| Column Name | Type | Description |
| ----------- | ---- | ----------- |
| name | text | database name |
| path | text | database path in file system |
| schema_proto | blob | schema protobuf |

**Results**

| Column Name | Type | Description |
| ----------- | ---- | ----------- |
| rid | integer | primary key/unique id for result |
| tid | text | foreign key to task id |
| query | text | candidate SQL query |


## Build Process for Docker Images (Development Only)

1. Save the version number as a variable.
```
export DQ_VERSION=<version_number_here>
```
2. Download [Spider dataset](https://yale-lily.github.io/spider) and [mas_smallest.sqlite](https://drive.google.com/file/d/16z05ZD0Wsc3LYZ32semzIMuUWiIhZcQZ/view?usp=sharing) into `data/` folder.

3. Build data container.
```
docker build -t chrisjbaik/duoquest-data:$DQ_VERSION data/
```
4. Load/build Enumerator image.
```
cd enum/syntaxSQL
git submodule init        # only if submodule not initialized yet
git submodule update      # only if submodule not initialized yet
docker build -t chrisjbaik/duoquest-enum:$DQ_VERSION .
cd ../../
```
5. Build task database image.
```
docker build -t chrisjbaik/duoquest-task-db:$DQ_VERSION -f task_db/Dockerfile .
```
6. Build web interface image.
```
docker build -t chrisjbaik/duoquest-web:$DQ_VERSION -f web/Dockerfile .
```
7. Build main image.
```
docker build -t chrisjbaik/duoquest-main:$DQ_VERSION .
```
