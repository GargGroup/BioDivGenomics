version 1.0

workflow estimation {
  input {
    File input_file
  }

  call fastk { input: source=input_file }
  call ploidy_plot { input: fastk_table_tar_gz=fastk.fastk_table_out_tar_gz }
  call histex { input: fastk_table_tar_gz=ploidy_plot.fastk_table_out_tar_gz }
  call gene_scope_fk_r { input: hist=histex.hist_out }

  output {
    File fastk_report = fastk.report
    File table_ktab = ploidy_plot.fastk_table_out_tar_gz
    File gene_scope_fk_report = gene_scope_fk_r.report
  }
}

task fastk {
  input {
    File source
    Int kmer_size = 31
  }
  command {
    echo "Running FastK with soruce: ${source} .."
    mkdir -p tmp/FastK
    # The -N3 option limits the maximum memory to 3 GB due to the GitHub
    # Actions CI environment.
    # The -v option outputs the information to stderr.
    FastK -k${kmer_size} -v -t -p -M3 "${source}" -Ntmp/FastK/table 2> \
      tmp/FastK/report.txt
    # Record the FastK producing files permissions.
    ls -l tmp/FastK/table.* > tmp/FastK_files_permissons.log
    # FIXME FastK produces the files with 700.
    chmod 666 tmp/FastK/table.ktab
    chmod 666 tmp/FastK/.table.ktab.*
    pushd tmp
    tar czvf FastK_table.tar.gz FastK/
    popd
  }
  output {
    File report = "tmp/FastK/report.txt"
    File fastk_table_out_tar_gz = "tmp/FastK_table.tar.gz"
  }
  runtime {
    docker: "quay.io/junaruga/garg-fastk:latest"
  }
}

task ploidy_plot {
  input {
    File fastk_table_tar_gz
  }
  command {
    mkdir tmp
    tar xzvf "${fastk_table_tar_gz}" -C tmp/
    PloidyPlot tmp/FastK/table
    pushd tmp
    tar czvf FastK_table.tar.gz FastK/
    popd
  }
  output {
    File fastk_table_out_tar_gz = "tmp/FastK_table.tar.gz"
  }
  runtime {
    docker: "quay.io/junaruga/garg-merqury-fk:latest"
  }
}

task histex {
  input {
    File fastk_table_tar_gz
  }
  command {
    mkdir tmp
    tar xzvf "${fastk_table_tar_gz}" -C tmp/
    Histex -G tmp/FastK/table > "tmp/FastK/histex_out.hist"
  }
  output {
    File hist_out = "tmp/FastK/histex_out.hist"
  }
  runtime {
    docker: "quay.io/junaruga/garg-fastk:latest"
  }
}

task gene_scope_fk_r {
  input {
    File hist
    Int kmer_size = 31
  }
  command {
    mkdir tmp
    GeneScopeFK.R -i ${hist} -o tmp/GeneScopeFK.R -k "${kmer_size}"
    pushd tmp
    tar czvf GeneScopeFK.R_report.tar.gz GeneScopeFK.R
    popd
  }
  output {
    File report = "tmp/GeneScopeFK.R_report.tar.gz"
  }
  runtime {
    docker: "quay.io/junaruga/garg-gene-scope-fk:latest"
  }
}
