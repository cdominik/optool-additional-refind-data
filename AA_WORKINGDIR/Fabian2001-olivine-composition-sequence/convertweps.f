	program ConvertWeps
	IMPLICIT NONE
	real*8 wn(10000),reps(10000),ceps(10000)
	complex*16 eps,m
	real*8 lam
	integer i,nlam
	character*100 filein,fileout
	
	call getarg(1,filein)
	write(fileout,'(a,".lnk")') filein(1:len_trim(filein)-5)
	print*,trim(fileout)
	
	open(unit=20,file=filein)
	nlam=1
1	read(20,*,end=2,err=1) wn(nlam),reps(nlam),ceps(nlam)
	nlam=nlam+1
	goto 1
2	nlam=nlam-1
	close(unit=20)
	open(unit=21,file=fileout)
	
	do i=nlam,1,-2
		lam=10000d0/wn(i)
		eps=dcmplx(reps(i),ceps(i))
		m=eps	!cdsqrt(eps)
		write(21,*) lam,real(m),dimag(m)
	enddo

	close(unit=21)
	
	end
	
	