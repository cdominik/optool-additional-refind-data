	program convert
	IMPLICIT NONE
	real*8 lam(10000),n(10000),k(10000),dummy
	character*100 file
	integer i,nlam
	
	call getarg(1,file)
	open(unit=20,file=file)
	call getarg(2,file)
	open(unit=21,file=file)
	
	read(20,*)
	read(20,*)
	read(20,*)
	read(20,*)
	read(20,*)
	i=1
1	read(20,*,end=2) lam(i),dummy,dummy,n(i),k(i)
	i=i+1
	goto 1
2	close(unit=20)
	nlam=i-1
	
	do i=nlam,1,-1
		write(21,*) lam(i),n(i)+1d0,k(i)
	enddo
	close(unit=21)
	
	end
	
	