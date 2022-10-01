version 1.0

workflow assembly {
  input {
    File input_file
    String data_type
  }

  if (data_type == "HIFI") {
    call hifiasm { input: source=input_file }
  } if (data_type == "ONT") {
    call shasta { input: source=input_file }
  }

  output {
    # Hack to use the type "File", not the optional type "File?".
    File gfa_out = select_first([hifiasm.gfa_out, shasta.gfa_out])
    File fa_out = select_first([hifiasm.fa_out, shasta.fa_out])
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

task shasta {
  input {
    File source
  }
  command {
    mkdir -p tmp/shasta
    # Limit the number of the threads not to be killed by system.
    nproc --all > tmp/shasta/cpu_num.txt
    shasta --input "${source}" --config Nanopore-Oct2021 \
      --assemblyDirectory tmp/shasta/out --threads $(cat tmp/shasta/cpu_num.txt)
    # FIXME Shasta creates the output directory and files with unreadable
    # permissions.
    chmod 777 tmp/shasta/out/ && chmod 666 tmp/shasta/out/*
  }
  output {
    File gfa_out = "tmp/shasta/out/Assembly.gfa"
    File fa_out = "tmp/shasta/out/Assembly.fasta"
  }
  runtime {
    docker: "quay.io/biocontainers/shasta:0.8.0--h7d875b9_0"
  }
}
