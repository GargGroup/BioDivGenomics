version 1.0

workflow BioDivGenomics {
  input {
    File input_file
  }
  call FastK { input: source=input_file }
}

task FastK {
  input {
    File source
  }
  command {
    echo "Running FastK with soruce: ${source} .."
    # Limit with the maximum memory 3 GB due to the GitHub Actions CI
    # environment.
    FastK -v -t -p -M3 "${source}"
  }
  output {
    File result = stdout()
  }
  runtime {
    docker: "quay.io/junaruga/garg-fastk:latest"
  }
}
