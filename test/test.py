import os
import subprocess

TEST_INPUT_DIR = os.path.join('test', 'input')

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
    input_file = os.path.join(TEST_INPUT_DIR, 'estimation.inputs.json')
    assert run_wdl('estimation.wdl', input_file)


def test_assembly_on_data_type_hifi():
    input_file = os.path.join(TEST_INPUT_DIR, 'assembly.inputs.json')
    assert run_wdl('assembly.wdl', input_file)


def test_assembly_on_data_type_ont():
    input_file = os.path.join(TEST_INPUT_DIR, 'assembly_ont.inputs.json')
    assert run_wdl('assembly.wdl', input_file)


def test_scaffold_on_is_test_1():
    input_file = os.path.join(TEST_INPUT_DIR, 'scaffold.inputs.json')
    assert run_wdl('scaffold.wdl', input_file)


def test_scaffold_on_is_test_0():
    input_file = os.path.join(TEST_INPUT_DIR, 'scaffold_is_test_0.inputs.json')
    assert run_wdl('scaffold.wdl', input_file)


def test_scaffold_on_data_type_ont():
    input_file = os.path.join(TEST_INPUT_DIR, 'scaffold_ont.inputs.json')
    assert run_wdl('scaffold.wdl', input_file)


def test_all():
    input_file = os.path.join(TEST_INPUT_DIR,
                              'bio-diversity-genomics-garg.inputs.json')
    assert run_wdl('bio-diversity-genomics-garg.wdl', input_file)
