import os

def results_path(config, dataset, mode, tsq_level, tsq_rows, timeout):
    basename = '_'.join([dataset, mode, tsq_level, f'r{tsq_rows}',
        f't{timeout}'])
    return os.path.join(config['duoquest']['results_dir'], f'{basename}')
