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
    # Set variable as a workaround to avoid a syntax error.
    # https://discuss.dockstore.org/t/5876
    String awk_prog = '/^S/{print ">"$2; print $3}'
  }
  command {
    mkdir -p tmp/hifiasm
    hifiasm -o tmp/hifiasm/asm -t10 -z40 "${source}"

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
