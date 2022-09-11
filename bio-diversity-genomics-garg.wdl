version 1.0

workflow BioDivGenomics {
  input {
    File input_file
  }
  call FastK { input: source=input_file }
  output {
    File info = FastK.info
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
      tmp/FastK/info.txt
  }
  output {
    File info = "tmp/FastK/info.txt"
  }
  runtime {
    docker: "quay.io/junaruga/garg-fastk:latest"
  }
}
