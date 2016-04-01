program mrcepa0
  implicit none
  !mrmode : 1=mrcepa0, 2=mrsc2 add, 3=mrsc2 sub
  mrmode = 1
  if (.not.read_wf) then
    print *,  'read_wf has to be true.'
    stop 1
  endif
  call print_cas_coefs
  call run_mrcepa0
end

subroutine print_cas_coefs
  implicit none

  integer :: i,j
  print *,  'CAS'
  print *,  '==='
  do i=1,N_det_cas
    print *,  psi_cas_coef(i,:)
    call debug_det(psi_cas(1,1,i),N_int)
  enddo

  call write_double(6,ci_energy(1),"Initial CI energy")
end
