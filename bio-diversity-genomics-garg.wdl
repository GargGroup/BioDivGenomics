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
    FastK -v -t -p "${source}"
  }
  output {
    File result = stdout()
  }
  runtime {
    docker: "quay.io/junaruga/garg-fastk:latest"
  }
}
