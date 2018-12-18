program four_idx_transform
  implicit none
  BEGIN_DOC
! 4-index transformation of two-electron integrals from AO to MO integrals
  END_DOC
  
  disk_access_mo_integrals = 'Write'
  SOFT_TOUCH disk_access_mo_integrals
  if (.true.) then
    PROVIDE mo_bielec_integrals_in_map
  endif
end
