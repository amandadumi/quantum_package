program write_integrals_erf_to_regular_integrals
 implicit none
 BEGIN_DOC
 ! This program saves the bielec erf integrals into the EZFIO folder but at the regular bielec integrals place. 
 ! Threfore, if the user runs a future calculation with a reading of the integrals, the calculation will be performed with the erf bielec integrals instead of the regular bielec integrals
 END_DOC
 disk_access_mo_integrals = "None"
 touch disk_access_mo_integrals
 disk_access_ao_integrals = "None"
 touch disk_access_ao_integrals
 call routine

end

subroutine routine
 implicit none
 call  save_erf_bielec_ints_mo_into_ints_ao
 call  save_erf_bielec_ints_mo_into_ints_mo

end

