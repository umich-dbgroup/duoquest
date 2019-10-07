import os

def results_path(config, dataset, mode, tsq_level, tsq_rows, timeout,
    disable_clauses, disable_semantics, disable_col_types, disable_col_val,
    disable_early_row, disable_literals):
    basename = '_'.join([dataset, mode, tsq_level, f'r{tsq_rows}',
        f't{timeout}'])

    if disable_clauses:
        basename += '_dc'
    if disable_semantics:
        basename += '_ds'
    if disable_col_types:
        basename += '_dt'
    if disable_col_val:
        basename += '_dv'
    if disable_early_row:
        basename += '_dr'
    if disable_literals:
        basename += '_dl'

    return os.path.join(config['duoquest']['results_dir'], f'{basename}')
