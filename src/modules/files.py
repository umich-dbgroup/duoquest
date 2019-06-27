import os

def results_path(config, system, dataset, mode, n, b, tsq_level, tsq_rows,
    mixtape, cache):

    basename = '_'.join([system, dataset, mode, f'n{n}', f'b{b}', tsq_level,
        f'r{tsq_rows}', f'm{int(mixtape)}', f'c{int(cache)}'])
    return os.path.join(config['mixtape']['results_dir'], f'{basename}.sqls')
