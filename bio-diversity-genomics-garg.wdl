version 1.0
import "estimation.wdl" as estimation_wdl
import "assembly.wdl" as assembly_wdl
import "scaffold.wdl" as scaffold_wdl

workflow bio_diversity_genomics {
  input {
    File input_file
    # "HIFI" or "ONT"
    String data_type = "HIFI"
    File input_hic_1_file
    File input_hic_2_file
    Int is_test = 1
  }

  call estimation_wdl.estimation {
    input:
      input_file=input_file
  }

  call assembly_wdl.assembly {
    input:
      input_file=input_file
  }

  call scaffold_wdl.scaffold {
    input:
      input_file=input_file,
      input_hic_1_file=input_hic_1_file,
      input_hic_2_file=input_hic_2_file,
      input_asm_gfa_file=assembly.gfa_out,
      input_asm_fa_file=assembly.fa_out,
      is_test=is_test
  }

  output {
    File est_fastk_report = estimation.fastk_report
    File est_table_ktab = estimation.table_ktab
    File est_gene_scope_fk_report = estimation.gene_scope_fk_report
    File asm_gfa = assembly.gfa_out
    File asm_fa = assembly.fa_out
    File sca_hap1_fa = scaffold.hap1_fa_out
    File sca_hap2_fa = scaffold.hap2_fa_out
    File sca_pstools = scaffold.pstools_out
  }
}

# The dummy task to pass the `dockstore tool launch`.
# https://discuss.dockstore.org/t/5874
task dummy {
  command {
    echo "dummy"
  }
}
