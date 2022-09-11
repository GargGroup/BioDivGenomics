version 1.0
import "estimation.wdl" as estimation_wdl

workflow bio_diversity_genomics {
  input {
    File input_file
    # "HIFI" or "ONT"
    String data_type = "HIFI"
  }

  call estimation_wdl.estimation {
    input:
      input_file=input_file
  }

  output {
    File report = estimation.report
    File table_ktab = estimation.table_ktab
  }
}

# The dummy task to pass the `dockstore tool launch`.
task Dummy {
  command {
    echo "dummy"
  }
}
