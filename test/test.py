import os
import subprocess

TEST_INPUT_DIR = os.path.join('test', 'input')
CRONMEWLL_JAR_FILE = os.path.join('vendor', 'cromwell', 'cromwell-77.jar')

def run_cmd(cmd):
    status = True

    try:
        subprocess.run(cmd, check=True, shell=True)
    except subprocess.CalledProcessError:
        status = False

    return status


def run_wdl_by_cromwell(wdl_file, input_file):
    cmd_format = 'java -jar {0} run --inputs {1} {2}'
    cmd = cmd_format.format(CRONMEWLL_JAR_FILE, input_file, wdl_file)
    return run_cmd(cmd)


def run_wdl_by_dockstore_cli(wdl_file, input_file):
    cmd_format = 'dockstore tool launch --local-entry {0} --json {1}'
    cmd = cmd_format.format(wdl_file, input_file)
    return run_cmd(cmd)


def test_estimation():
    input_file = os.path.join(TEST_INPUT_DIR, 'estimation.inputs.json')
    assert run_wdl_by_cromwell('estimation.wdl', input_file)


def test_assembly_on_data_type_hifi():
    input_file = os.path.join(TEST_INPUT_DIR, 'assembly.inputs.json')
    assert run_wdl_by_cromwell('assembly.wdl', input_file)


def test_assembly_on_data_type_ont():
    input_file = os.path.join(TEST_INPUT_DIR, 'assembly_ont.inputs.json')
    assert run_wdl_by_cromwell('assembly.wdl', input_file)


def test_scaffold_on_is_test_1():
    input_file = os.path.join(TEST_INPUT_DIR, 'scaffold.inputs.json')
    assert run_wdl_by_cromwell('scaffold.wdl', input_file)


def test_scaffold_on_is_test_0():
    input_file = os.path.join(TEST_INPUT_DIR, 'scaffold_is_test_0.inputs.json')
    assert run_wdl_by_cromwell('scaffold.wdl', input_file)


def test_scaffold_on_data_type_ont():
    input_file = os.path.join(TEST_INPUT_DIR, 'scaffold_ont.inputs.json')
    assert run_wdl_by_cromwell('scaffold.wdl', input_file)


def test_all():
    input_file = os.path.join(TEST_INPUT_DIR,
                              'bio-diversity-genomics-garg.inputs.json')
    assert run_wdl_by_dockstore_cli('bio-diversity-genomics-garg.wdl',
                                    input_file)
