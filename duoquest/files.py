import os

def squid_results_path(config, dataset, mode, tsq_rows):
    basename = '_'.join([dataset, mode, f'r{tsq_rows}'])
    return os.path.join(config['duoquest']['results_dir'], f'{basename}')

def results_path(config, dataset, mode, tsq_level, tsq_rows, timeout,
    disable_clauses, disable_semantics, disable_column, disable_literals):

    basename = '_'.join([dataset, mode, tsq_level, f'r{tsq_rows}',
        f't{timeout}'])

    if disable_clauses:
        basename += '_dc'
    if disable_semantics:
        basename += '_ds'
    if disable_column:
        basename += '_dl'
    if disable_literals:
        basename += '_di'

    return os.path.join(config['duoquest']['results_dir'], f'{basename}')
