program read_integrals
  BEGIN_DOC
! Reads the integrals from the following files:
! - kinetic_mo
! - nuclear_mo
! - bielec_mo
  END_DOC

  integer :: iunit
  integer :: getunitandopen
  integer :: i,j,n

  PROVIDE ezfio_filename
  call ezfio_set_mo_one_e_integrals_disk_access_mo_one_integrals("None")

  logical :: has
  call ezfio_has_mo_basis_mo_tot_num(has)
  if (.not.has) then

    iunit = getunitandopen('nuclear_mo','r')
    n=0
    do 
      read (iunit,*,end=12) i
      n = max(n,i)
    enddo
    12 continue
    close(iunit)
    call ezfio_set_mo_basis_mo_tot_num(n)

    call ezfio_has_ao_basis_ao_num(has)
    mo_label = "None"
    if (has) then
      call huckel_guess
    else
      call ezfio_set_ao_basis_ao_num(n)
      double precision, allocatable :: X(:,:)
      allocate (X(n,n))
      X = 0.d0
      do i=1,n
        X(i,i) = 1.d0
      enddo
      call ezfio_set_mo_basis_mo_coef(X)
      call save_mos
    endif
  endif
  call run
end

subroutine run
  use map_module
  implicit none
  
  integer :: iunit
  integer :: getunitandopen

  integer ::i,j,k,l
  double precision :: integral
  double precision, allocatable :: A(:,:)

  integer             :: n_integrals 
  integer(key_kind), allocatable   :: buffer_i(:) 
  real(integral_kind), allocatable :: buffer_values(:)
  integer(key_kind)  :: key
   
  call ezfio_get_mo_basis_mo_tot_num(mo_tot_num)

  allocate (A(mo_tot_num,mo_tot_num))
  A = 0.d0
  
  iunit = getunitandopen('kinetic_mo','r')
  do 
    read (iunit,*,end=10) i,j, integral
    A(i,j) = integral
  enddo
  10 continue
  close(iunit)
  call ezfio_set_mo_one_e_integrals_integral_kinetic(mo_kinetic_integral)


  iunit = getunitandopen('nuclear_mo','r')
  do 
    read (iunit,*,end=12) i,j, integral
    A(i,j) = integral
  enddo
  12 continue
  close(iunit)
  call ezfio_set_mo_one_e_integrals_integral_nuclear(A)
  call ezfio_set_mo_one_e_integrals_integral_pseudo(mo_pseudo_integral)

  call ezfio_set_mo_one_e_integrals_disk_access_mo_one_integrals("Read")


  call ezfio_set_integrals_monoelec_disk_access_mo_one_integrals("Read")

  allocate(buffer_i(mo_tot_num**4), buffer_values(mo_tot_num**4))
   
  iunit = getunitandopen('bielec_mo','r')
  n_integrals=0
  do 
    read (iunit,*,end=13) i,j,k,l, integral
    n_integrals += 1
    call bielec_integrals_index(i, j, k, l, buffer_i(n_integrals) )
    buffer_values(n_integrals) = integral
  enddo
  13 continue
  close(iunit)
  
  call map_append(mo_integrals_map, buffer_i, buffer_values, n_integrals)

  call map_sort(mo_integrals_map)
  call map_unique(mo_integrals_map)

  call map_save_to_disk(trim(ezfio_filename)//'/work/mo_ints',mo_integrals_map)
  call ezfio_set_integrals_bielec_disk_access_mo_integrals("Read")
  
end
