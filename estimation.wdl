version 1.0

workflow estimation {
  input {
    File input_file
  }

  call FastK { input: source=input_file }

  output {
    File report = FastK.report
    File table_ktab = FastK.table_ktab
    File table_hist = FastK.table_hist
  }
}

task FastK {
  input {
    File source
  }
  command {
    echo "Running FastK with soruce: ${source} .."
    mkdir -p tmp/FastK
    # The -N3 option limits the maximum memory to 3 GB due to the GitHub
    # Actions CI environment.
    # The -v option outputs the information to stderr.
    FastK -v -t -p -M3 "${source}" -Ntmp/FastK/table 2> \
      tmp/FastK/report.txt
  }
  output {
    File report = "tmp/FastK/report.txt"
    File table_ktab = "tmp/FastK/table.ktab"
    File table_hist = "tmp/FastK/table.hist"
  }
  runtime {
    docker: "quay.io/junaruga/garg-fastk:latest"
  }
}
