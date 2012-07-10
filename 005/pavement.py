import os
import subprocess as sub
from paver.easy import *

@task
def test(options):
    env = os.environ.copy()
    env['PYTHONPATH'] = 'src;%s' % env['PYTHONPATH'] if 'PYTHONPATH' in env else 'src'
    cmd = 'nosetests --with-doctest'
    sub.call(cmd, env=env)
