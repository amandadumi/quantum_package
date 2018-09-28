#!/usr/bin/env bats

source $QP_ROOT/tests/bats/common.bats.sh

#=== H2O
@test "MRCC-lambda H2O cc-pVDZ" {
  INPUT=h2o.ezfio
  EXE=mrcc
  test_exe $EXE || skip
  qp_edit -c $INPUT  
  ezfio set_file $INPUT
  ezfio set determinants threshold_generators 1.
  ezfio set determinants threshold_selectors  1.
  ezfio set determinants read_wf True
  ezfio set mrcc lambda_type 1
  ezfio set mrcc perturbative_triples 0
  ezfio set mrcc n_it_max_dressed_ci 3
  cp -r $INPUT TMP ; qp_run $EXE TMP 
  ezfio set_file TMP
  energy="$(ezfio get mrcc energy)"
  energy_pt2="$(ezfio get mrcc energy_pt2)"
  rm -rf TMP
  eq $energy -76.2294920123364 1.e-4
  eq $energy_pt2 -76.2382119593925 1.e-4
}


@test "MRCC H2O cc-pVDZ" {
  INPUT=h2o.ezfio
  EXE=mrcc
  test_exe $EXE || skip
  qp_edit -c $INPUT  
  ezfio set_file $INPUT
  ezfio set determinants threshold_generators 1.
  ezfio set determinants threshold_selectors  1.
  ezfio set determinants read_wf True
  ezfio set mrcc lambda_type 0
  ezfio set mrcc perturbative_triples 0
  ezfio set mrcc n_it_max_dressed_ci 3
  cp -r $INPUT TMP ; qp_run $EXE TMP 
  ezfio set_file TMP
  energy="$(ezfio get mrcc energy)"
  energy_pt2="$(ezfio get mrcc energy_pt2)"
  rm -rf TMP
  eq $energy -76.2294460531211 1.e-4
  eq $energy_pt2 -76.2381753982904 1.e-4
}

