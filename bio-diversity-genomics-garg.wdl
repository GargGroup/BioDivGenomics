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
    echo "Running FastK.."
    echo "soruce: ${source}"
    # FastK -v -t -p "${source}"
    cat /etc/os-release
  }
  output {
    File result = stdout()
  }
  runtime {
    docker: "docker.io/ubuntu:latest"
    # docker: "quay.io/junaruga/garg-fastk:latest"
  }
}
