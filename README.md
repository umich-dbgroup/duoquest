# duoquest

Dual-specification query synthesis with natural language and table sketch
queries.

## Setup

### Python Dependencies

First, make a virtual environment and install requirements:
```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```
Activate this virtual environment with `source venv/bin/activate` whenever you
are running the system.

### Config

Make a copy of the `config.ini.example` in the main repository folder and name
it `config.ini`.

### Spider Dataset

1. Download the [Spider dataset](https://yale-lily.github.io/spider).
2. Unzip to wherever you like.
3. Edit the paths under `spider` in `config.ini` accordingly.

### Synthesizer (SyntaxSQLNet)

1. The [SyntaxSQLNet](https://github.com/taoyds/syntaxSQL) is forked and set up
as a Git submodule under `/systems/syntaxSQL`. Read more on [submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) for help.
2. Pull the most up-to-date version of the [forked SyntaxSQLNet](https://github.com/chrisjbaik/syntaxSQL) on branch `duoquest`.
3. Download the [pretrained Glove models](https://nlp.stanford.edu/data/wordvecs/glove.42B.300d.zip) and unzip somewhere. Update `syntaxsql.glove_path` in `config.ini` accordingly.
4. Download the [pretrained SyntaxSQL models](https://drive.google.com/file/d/1FHEcceYuf__PLhtD5QzJvexM7SNGnoBu/view?usp=sharing) and unzip somewhere. Update `syntaxsql.models_path` in `config.ini` accordingly.
5. Make a Python 2 virtual environment in the `/systems/syntaxSQL` and run `pip install -r requirements.txt`. This is distinct from the Python dependencies setup above.

### NLTK Packages Download

An additional step may be necessary to install NLTK package dependencies. Follow [the instructions](https://www.nltk.org/data.html).

## Run Tests

### Warnings

1. The Synthesizer runs on Python 2 (as it is mostly external code), while the main execution and verifier code runs on Python 3!
2. The Synthesizer requires a GPU-enabled machine and PyTorch to run.

### Procedure

1. Run Synthesizer by going to `systems/syntaxSQL` and running `python --config_path=../../config.ini`.
2. After the Synthesizer is up and listening, run `python3 main.py` with the appropriate arguments **in a new terminal window**.
