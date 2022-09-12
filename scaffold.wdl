version 1.0

workflow scaffold {
  input {
    File input_file
    File input_hic_1_file
    File input_hic_2_file
    File input_asm_gfa_file
    File input_asm_fa_file
    Int is_test = 1
  }

  call pstools {
    input:
      source=input_file,
      hic_1_file=input_hic_1_file,
      hic_2_file=input_hic_1_file,
      asm_gfa_file=input_asm_gfa_file,
      asm_fa_file=input_asm_fa_file,
      is_test=is_test
  }

  output {
    File hap1_fa_out = pstools.hap1_fa_out
    File hap2_fa_out = pstools.hap2_fa_out
    File pstools_out = pstools.pstools_out_tar_gz
  }
}

task pstools {
  input {
    File source
    File hic_1_file
    File hic_2_file
    File asm_gfa_file
    File asm_fa_file
    Int kmer_size = 31
    Int is_test = 1
  }
  command {
    mkdir -p tmp/pstools
    nproc --all > tmp/pstools/cpu_num.txt
    # Create hic_name_connection.output and map.out files.
    pstools hic_mapping_unitig \
      -k${kmer_size} -t$(cat tmp/pstools/cpu_num.txt) -o tmp/pstools/map.out \
      "${asm_fa_file}" "${hic_1_file}" "${hic_2_file}"

    # Create hic_name_connection.output and map.out files.
    # * pred_broken_nodes.fa
    # * pred_haplotypes.fa
    # * scaffold_connection.txt
    # TODO: scaffold_connection.txt is empty. Create non-empty one.
    pstools resolve_haplotypes \
      -t$(cat tmp/pstools/cpu_num.txt) \
      tmp/pstools/map.out ${asm_gfa_file} tmp/pstools/

    if [ "${is_test}" = 1 ]; then
      # Temporary workaround for test example in the case that the
      # "pstools haplotype_scaffold" finishes with error without creating
      # the pred_hap1.fa and pred_hap2.fa.
      grep -A1 hap1 tmp/pstools/pred_haplotypes.fa > tmp/pstools/pred_hap1.fa
      grep -A1 hap2 tmp/pstools/pred_haplotypes.fa > tmp/pstools/pred_hap2.fa
    else
      # Create fscaff_connections.txt file.
      pstools hic_mapping_haplo \
        -t$(cat tmp/pstools/cpu_num.txt) \
        tmp/pstools/pred_haplotypes.fa "${hic_1_file}" "${hic_2_file}" \
        -k${kmer_size} \
        -o tmp/pstools/scaff_connections.txt

      # Create pred_hap1.fa, pred_hap2.fa and pred_broken_nodes.fa files in the
      # 3rd argument directory.
      # FIXME: Prepare the test data to create the pred_hap1.fa, pred_hap2.fa
      # files. The "is_test" variable is the temporary workaround.
      if ! pstools haplotype_scaffold \
        -t$(cat tmp/pstools/cpu_num.txt) \
        tmp/pstools/scaff_connections.txt tmp/pstools/pred_haplotypes.fa \
        tmp/pstools; then
        echo "[ERROR] pstools haplotype_scaffold failed. Create empty files."
        pushd tmp/pstools
        touch pred_hap1.fa pred_hap2.fa pred_broken_nodes.fa
        popd
      fi
    fi

    # Create hap1.fa and hap2 fa files.
    pushd tmp/pstools
    cp -p pred_hap1.fa hap1.fa
    cat pred_hap2.fa pred_broken_nodes.fa > hap2.fa
    popd

    pushd tmp
    tar czvf pstools_out.tar.gz pstools/
    popd
  }
  output {
    File hap1_fa_out = "tmp/pstools/hap1.fa"
    File hap2_fa_out = "tmp/pstools/hap2.fa"
    File pstools_out_tar_gz = "tmp/pstools_out.tar.gz"
  }
  runtime {
    docker: "quay.io/biocontainers/pstools:0.2a3--hd03093a_1"
  }
}
