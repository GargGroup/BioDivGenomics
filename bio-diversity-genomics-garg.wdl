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
    File fastk_report = estimation.fastk_report
    File table_ktab = estimation.table_ktab
    File gene_scope_fk_report = estimation.gene_scope_fk_report
  }
}

# The dummy task to pass the `dockstore tool launch`.
# https://discuss.dockstore.org/t/5874
task dummy {
  command {
    echo "dummy"
  }
}
