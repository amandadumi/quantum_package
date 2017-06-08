BEGIN_PROVIDER [ double precision , ao_value_at_nucl, (ao_num,nucl_num) ]
  implicit none
  BEGIN_DOC
! Values of the atomic orbitals at the nucleus 
  END_DOC
  integer :: i,j,k
  double precision :: x,y,z,expo,poly, r2

  do k=1,nucl_num
    do i=1,ao_num
      x = nucl_coord(ao_nucl(i),1) - nucl_coord(k,1)
      y = nucl_coord(ao_nucl(i),2) - nucl_coord(k,2)
      z = nucl_coord(ao_nucl(i),3) - nucl_coord(k,3)
      poly = x**(ao_power(i,1)) * y**(ao_power(i,2)) * z**(ao_power(i,3)) 
      if (poly == 0.d0) cycle

      r2 = (x*x) + (y*y) + (z*z)
      ao_value_at_nucl(i,k) = 0.d0
      do j=1,ao_prim_num(i)
        expo = ao_expo_ordered_transp(j,i)*r2
        if (expo > 40.d0) cycle
        ao_value_at_nucl(i,k) = ao_value_at_nucl(i,k) +             &
            ao_coef_normalized_ordered_transp(j,i) *                &
            dexp(-expo)
      enddo
      ao_value_at_nucl(i,k) *= poly
    enddo
  enddo
END_PROVIDER

BEGIN_PROVIDER [ double precision, mo_value_at_nucl, (mo_tot_num,nucl_num) ]
  implicit none
  BEGIN_DOC
! Values of the molecular orbitals at the nucleus 
  END_DOC

  call dgemm('N','N',mo_tot_num,nucl_num,ao_num,1.d0,                &
      mo_coef_transp, size(mo_coef_transp,1),                        &
      ao_value_at_nucl, size(ao_value_at_nucl,1),                    &
      0.d0, mo_value_at_nucl, size(mo_value_at_nucl,1))
END_PROVIDER


BEGIN_PROVIDER [ double precision , slater_value_at_nucl, (nucl_num,nucl_num) ]
  implicit none
  BEGIN_DOC
! Values of the Slater orbitals (1) at the nucleus (2)
  END_DOC
  integer :: i,j,k
  double precision :: x,y,z,expo,poly, r

  do k=1,nucl_num
    do i=1,nucl_num
      x = nucl_coord(ao_nucl(i),1) - nucl_coord(k,1)
      y = nucl_coord(ao_nucl(i),2) - nucl_coord(k,2)
      z = nucl_coord(ao_nucl(i),3) - nucl_coord(k,3)

      expo = slater_expo(i)*slater_expo(i)*((x*x) + (y*y) + (z*z))
      if (expo > 160.d0) cycle
      expo = dsqrt(expo)
      slater_value_at_nucl(i,k) = dexp(-expo) * slater_normalization(i)
    enddo
  enddo
END_PROVIDER
