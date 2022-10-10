import os
import subprocess
import tempfile
from contextlib import contextmanager

TEST_INPUT_DIR = os.path.join('test', 'input')
TEST_TMP_DIR = os.path.join('test', 'tmp')
CRONMEWLL_JAR_FILE = os.path.join('vendor', 'cromwell', 'cromwell-77.jar')

def print_input_file(file):
    print('[DEBUG] input file: {0}'.format(file))
    with open(file, mode='r') as f:
        for line in f:
            print(line, end='')


def run_cmd(cmd):
    status = True

    try:
        print('[DEBUG] CMD: {0}'.format(cmd))
        subprocess.run(cmd, check=True, shell=True)
    except subprocess.CalledProcessError:
        status = False

    return status


def run_wdl_by_cromwell(wdl_file, input_file):
    cmd_format = 'java -jar {0} run --inputs {1} {2}'
    cmd = cmd_format.format(CRONMEWLL_JAR_FILE, input_file, wdl_file)
    print_input_file(input_file)
    return run_cmd(cmd)


def run_wdl_by_dockstore_cli(wdl_file, input_file):
    cmd_format = 'dockstore tool launch --local-entry {0} --json {1}'
    cmd = cmd_format.format(wdl_file, input_file)
    print_input_file(input_file)
    return run_cmd(cmd)


@contextmanager
def generate_file(template_path, value_dict):
    content = None

    with open(template_path, mode='r') as f:
        content = f.read()

    for key in value_dict:
        src_key = '%%{0}%%'.format(key)
        content = content.replace(src_key, value_dict[key])

    try:
        if not os.path.exists(TEST_TMP_DIR):
            os.mkdir(TEST_TMP_DIR)
        generated_file = tempfile.NamedTemporaryFile(
            mode='x', dir=TEST_TMP_DIR,
            prefix='generated-file-', delete=False
        )
        generated_file.write(content)
    finally:
        generated_file.close()

    yield(generated_file.name)
    os.unlink(generated_file.name)


def test_estimation():
    input_file = os.path.join(TEST_INPUT_DIR, 'estimation.inputs.json')
    assert run_wdl_by_cromwell('estimation.wdl', input_file)


def test_assembly_on_data_type_hifi():
    tmpl_file = os.path.join(TEST_INPUT_DIR, 'assembly.inputs.json.tmpl')

    with generate_file(tmpl_file, {'DATA_TYPE': 'HIFI'}) as input_file:
        assert run_wdl_by_cromwell('assembly.wdl', input_file)


def test_assembly_on_data_type_ont():
    tmpl_file = os.path.join(TEST_INPUT_DIR, 'assembly.inputs.json.tmpl')

    with generate_file(tmpl_file, {'DATA_TYPE': 'ONT'}) as input_file:
        assert run_wdl_by_cromwell('assembly.wdl', input_file)


def test_scaffold_on_data_type_hifi_is_test_1():
    tmpl_file = os.path.join(TEST_INPUT_DIR, 'scaffold.inputs.json.tmpl')
    value_dict = {
        'ASM_GFA_FILE': 'test/data/hifiasm/asm.bp.r_utg.gfa',
        'ASM_FA_FILE': 'test/data/hifiasm/generated_asm.bp.r_utg.fa',
        'IS_TEST': '1'
    }

    with generate_file(tmpl_file, value_dict) as input_file:
        assert run_wdl_by_cromwell('scaffold.wdl', input_file)


def test_scaffold_on_data_type_hifi_is_test_0():
    tmpl_file = os.path.join(TEST_INPUT_DIR, 'scaffold.inputs.json.tmpl')
    value_dict = {
        'ASM_GFA_FILE': 'test/data/hifiasm/asm.bp.r_utg.gfa',
        'ASM_FA_FILE': 'test/data/hifiasm/generated_asm.bp.r_utg.fa',
        'IS_TEST': '0'
    }

    with generate_file(tmpl_file, value_dict) as input_file:
        assert run_wdl_by_cromwell('scaffold.wdl', input_file)


def test_scaffold_on_data_type_ont():
    tmpl_file = os.path.join(TEST_INPUT_DIR, 'scaffold.inputs.json.tmpl')
    value_dict = {
        'ASM_GFA_FILE': 'test/data/shasta/Assembly.gfa',
        'ASM_FA_FILE': 'test/data/shasta/Assembly.fasta',
        'IS_TEST': '0'
    }

    with generate_file(tmpl_file, value_dict) as input_file:
        assert run_wdl_by_cromwell('scaffold.wdl', input_file)


def test_all():
    input_file = os.path.join(TEST_INPUT_DIR,
                              'bio-diversity-genomics-garg.inputs.json')
    assert run_wdl_by_dockstore_cli('bio-diversity-genomics-garg.wdl',
                                    input_file)
