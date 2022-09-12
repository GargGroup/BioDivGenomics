version 1.0

workflow assembly {
  input {
    File input_file
  }

  call hifiasm { input: source=input_file }

  output {
    File gfa_out = hifiasm.gfa_out
    File fa_out = hifiasm.fa_out
  }
}

task hifiasm {
  input {
    File source
    Int kmer_size = 31
    # Set variable as a workaround to avoid a syntax error.
    # https://discuss.dockstore.org/t/5876
    String awk_prog = '/^S/{print ">"$2; print $3}'
  }
  command {
    mkdir -p tmp/hifiasm
    # Limit the number of the threads not to be killed by system.
    nproc --all > tmp/hifiasm/cpu_num.txt
    # Set the -f0 option to disable the bloom filter to save the memory.
    # https://github.com/chhylp123/hifiasm#usage
    hifiasm -o tmp/hifiasm/asm -t$(cat tmp/hifiasm/cpu_num.txt) -k${kmer_size} -f0 -z40 "${source}"

    # Select the rows with starting with 'S', and convert each row to fasta
    # format, and create the fasta file.
    awk '${awk_prog}' tmp/hifiasm/asm.bp.r_utg.gfa \
        > tmp/hifiasm/generated_asm.bp.r_utg.fa
  }
  output {
    File gfa_out = "tmp/hifiasm/asm.bp.r_utg.gfa"
    File fa_out = "tmp/hifiasm/generated_asm.bp.r_utg.fa"
  }
  runtime {
    docker: "quay.io/biocontainers/hifiasm:0.16.1--h5b5514e_1"
  }
}
