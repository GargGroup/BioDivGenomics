import os
import subprocess

def run_wdl(wdl_file, input_file):
    cmd_format = 'dockstore tool launch --local-entry {0} --json {1}'
    cmd = cmd_format.format(wdl_file, input_file)
    status = True

    try:
        subprocess.run(cmd, check=True, shell=True)
    except subprocess.CalledProcessError:
        status = False

    return status


def test_estimation():
    assert run_wdl('estimation.wdl', 'estimation.inputs.json')


def test_assembly():
    assert run_wdl('assembly.wdl', 'assembly.inputs.json')


def test_scaffold_on_is_test_1():
    assert run_wdl('scaffold.wdl', 'scaffold.inputs.json')


def test_scaffold_on_is_test_0():
    assert run_wdl('scaffold.wdl', 'scaffold_is_test_0.inputs.json')


def test_all():
    assert run_wdl('bio-diversity-genomics-garg.wdl',
                   'bio-diversity-genomics-garg.inputs.json')
