 BEGIN_PROVIDER [ double precision, ao_mono_elec_integral,(ao_num,ao_num)]
&BEGIN_PROVIDER [ double precision, ao_mono_elec_integral_diag,(ao_num)]
  implicit none
  integer :: i,j,n,l
  BEGIN_DOC
 ! Array of the one-electron Hamiltonian on the |AO| basis.
  END_DOC
  do j = 1, ao_num
   do i = 1, ao_num
    ao_mono_elec_integral(i,j) = ao_nucl_elec_integral(i,j) + ao_kinetic_integral(i,j) + ao_pseudo_integral(i,j)
   enddo
   ao_mono_elec_integral_diag(j) = ao_mono_elec_integral(j,j)
  enddo
END_PROVIDER

