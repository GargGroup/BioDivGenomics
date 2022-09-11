version 1.0
import "estimation.wdl" as estimation_wdl

workflow bio_diversity_genomics {
  input {
    File input_file
    # "HIFI" or "ONT"
    String data_type = "HIFI"
  }

  call check_input {
    input:
      input_file=input_file,
      data_type=data_type
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
task check_input {
  input {
    File input_file
    String data_type
  }
  command {
    echo "Check input parameters."
    # If the input_file is not "gs://" format on Terra, it raises the error
    # here.
    echo "input_file: ${input_file}"
    echo "data_type: ${data_type}"
    if [ "${data_type}" != "HIFI" && "${data_type}" != "ONT" ]; then
      echo "Invalid data_type: ${data_type}" 1>&2
      false
    fi
  }
}
