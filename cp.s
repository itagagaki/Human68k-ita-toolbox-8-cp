* cp - copy file
*
* Itagaki Fumihiko  5-Jul-92  Create.
*
* Usage: cp [ -adfinpsuvR ] <�t�@�C��1> <�t�@�C��2>
*        cp -rR [ -adefinpsuv ] <�f�B���N�g��1> <�f�B���N�g��2>
*        cp [ -adefinprsuvPR ] <�t�@�C��> ... <�f�B���N�g��>

.include doscall.h
.include error.h
.include limits.h
.include stat.h
.include chrcode.h

.xref DecodeHUPAIR
.xref getlnenv
.xref issjis
.xref strlen
.xref strcpy
.xref strfor1
.xref headtail
.xref cat_pathname
.xref strip_excessive_slashes
.xref tfopen
.xref fclose

REQUIRED_OSVER	equ	$200			*  2.00�ȍ~

MAXRECURSE	equ	64	*  �T�u�f�B���N�g�����폜���邽�߂ɍċA����񐔂̏���D
				*  MAXDIR �i�p�X���̃f�B���N�g���� "/1/2/3/../" �̒����j
				*  �� 64 �ł��邩��A31�ŏ[���ł��邪�C
				*  �V���{���b�N�E�����N���l������ 64 �Ƃ���D
				*  �X�^�b�N�ʂɂ������D

GETSLEN		equ	32

FLAG_d		equ	0
FLAG_e		equ	1
FLAG_f		equ	2
FLAG_i		equ	3
FLAG_n		equ	4
FLAG_p		equ	5
FLAG_r		equ	6
FLAG_s		equ	7
FLAG_u		equ	8
FLAG_v		equ	9
FLAG_x		equ	10
FLAG_path	equ	11

LNDRV_O_CREATE		equ	4*2
LNDRV_O_OPEN		equ	4*3
LNDRV_O_DELETE		equ	4*4
LNDRV_O_MKDIR		equ	4*5
LNDRV_O_RMDIR		equ	4*6
LNDRV_O_CHDIR		equ	4*7
LNDRV_O_CHMOD		equ	4*8
LNDRV_O_FILES		equ	4*9
LNDRV_O_RENAME		equ	4*10
LNDRV_O_NEWFILE		equ	4*11
LNDRV_O_FATCHK		equ	4*12
LNDRV_realpathcpy	equ	4*16
LNDRV_LINK_FILES	equ	4*17
LNDRV_OLD_LINK_FILES	equ	4*18
LNDRV_link_nest_max	equ	4*19
LNDRV_getrealpath	equ	4*20

.text
start:
		bra.s	start1
		dc.b	'#HUPAIR',0
start1:
		lea	stack_bottom,a7			*  A7 := �X�^�b�N�̒�
		DOS	_VERNUM
		cmp.w	#REQUIRED_OSVER,d0
		bcs	dos_version_mismatch

		DOS	_GETPDB
		movea.l	d0,a0				*  A0 : PDB�A�h���X
		move.l	a7,d0
		sub.l	a0,d0
		move.l	d0,-(a7)
		move.l	a0,-(a7)
		DOS	_SETBLOCK
		addq.l	#8,a7
	*
	*  �������ъi�[�G���A���m�ۂ���
	*
		lea	1(a2),a0			*  A0 := �R�}���h���C���̕�����̐擪�A�h���X
		bsr	strlen				*  D0.L := �R�}���h���C���̕�����̒���
		addq.l	#1,d0
		bsr	malloc
		bmi	insufficient_memory

		movea.l	d0,a1				*  A1 := �������ъi�[�G���A�̐擪�A�h���X
	*
	*  �o�b�t�@���m�ۂ���
	*
		move.l	#$00ffffff,d0
		bsr	malloc
		sub.l	#$81000000,d0
		cmp.l	#1024,d0
		blo	insufficient_memory

		move.l	d0,d4				*  D4.L : �o�b�t�@�T�C�Y
		bsr	malloc
		bmi	insufficient_memory

		movea.l	d0,a4				*  A4 : �o�b�t�@
	*
	*  lndrv ���g�ݍ��܂�Ă��邩�ǂ�������������
	*
		bsr	getlnenv
		move.l	d0,lndrv
	*
	*  �������f�R�[�h���C���߂���
	*
		bsr	DecodeHUPAIR			*  �������f�R�[�h����
		movea.l	a1,a0				*  A0 : �����|�C���^
		move.l	d0,d7				*  D7.L : �����J�E���^
		moveq	#0,d5				*  D5.L : �t���O
decode_opt_loop1:
		tst.l	d7
		beq	decode_opt_done

		cmpi.b	#'-',(a0)
		bne	decode_opt_done

		subq.l	#1,d7
		addq.l	#1,a0
		move.b	(a0)+,d0
		beq	decode_opt_done
decode_opt_loop2:
		cmp.b	#'a',d0
		beq	set_option_a

		moveq	#FLAG_f,d1
		cmp.b	#'f',d0
		beq	set_option

		moveq	#FLAG_i,d1
		cmp.b	#'i',d0
		beq	set_option

		moveq	#FLAG_p,d1
		cmp.b	#'p',d0
		beq	set_option

		moveq	#FLAG_r,d1
		cmp.b	#'r',d0
		beq	set_option

		cmp.b	#'R',d0
		beq	set_option

		moveq	#FLAG_d,d1
		cmp.b	#'d',d0
		beq	set_option

		moveq	#FLAG_e,d1
		cmp.b	#'e',d0
		beq	set_option

		moveq	#FLAG_n,d1
		cmp.b	#'n',d0
		beq	set_option

		moveq	#FLAG_s,d1
		cmp.b	#'s',d0
		beq	set_option

		moveq	#FLAG_u,d1
		cmp.b	#'u',d0
		beq	set_option

		moveq	#FLAG_v,d1
		cmp.b	#'v',d0
		beq	set_option

		moveq	#FLAG_x,d1
		cmp.b	#'x',d0
		beq	set_option

		moveq	#FLAG_path,d1
		cmp.b	#'P',d0
		beq	set_option

		moveq	#1,d1
		tst.b	(a0)
		beq	bad_option_1

		bsr	issjis
		bne	bad_option_1

		moveq	#2,d1
bad_option_1:
		move.l	d1,-(a7)
		pea	-1(a0)
		move.w	#2,-(a7)
		lea	msg_illegal_option(pc),a0
		bsr	werror_myname_and_msg
		DOS	_WRITE
		lea	10(a7),a7
		bra	usage

set_option_a:
		bset	#FLAG_d,d5
		bset	#FLAG_p,d5
		bset	#FLAG_r,d5
		bra	set_option_done

set_option:
		bset	d1,d5
set_option_done:
		move.b	(a0)+,d0
		bne	decode_opt_loop2
		bra	decode_opt_loop1

decode_opt_done:
		subq.l	#2,d7
		bcs	too_few_args
	*
	*  target�𒲂ׂ�
	*
		moveq	#0,d6				*  D6.W : �G���[�E�R�[�h
		movea.l	a0,a1				*  A1 : 1st source
		move.l	d7,d0
find_target:
		bsr	strfor1
		subq.l	#1,d0
		bcc	find_target
							*  A0 : target
		bsr	strip_excessive_slashes

		*  target���f�B���N�g���ł��邩�ǂ����𒲂ׂ�
		*
		*  �����ł́A�f�B���N�g���ւ̃V���{���b�N�E�����N��������
		*  �f�B���N�g���Ɠ����Ɉ����B-d �I�v�V�����͉e�����Ȃ��B

		bsr	is_directory
		bmi	exit_program
		bne	cp_into_dir

		btst	#FLAG_path,d5
		bne	bad_target

		tst.l	d7
		bne	bad_target
	*
	*  cp [ -ipr ] f1 f2
	*
		exg	a0,a1				*  A0 : 1st source, A1 : target (== destination)
		bsr	strip_excessive_slashes
		bsr	copy_file_or_directory_0
		bra	exit_program
****************
cp_into_dir:
	*
	*  cp [ -ipr ] file ... dir
	*
		exg	a0,a1				*  A0 : 1st source, A1 : targetdir
cp_into_dir_loop:
		movea.l	a0,a2
		bsr	strfor1
		exg	a0,a2				*  A2 : next arg
		bsr	strip_excessive_slashes
		move.l	#-1,drive
		moveq	#0,d0
		bsr	copy_into_dir
		movea.l	a2,a0
		subq.l	#1,d7
		bcc	cp_into_dir_loop
exit_program:
		move.w	d6,-(a7)
		DOS	_EXIT2

bad_target:
		lea	msg_not_a_directory(pc),a2
		bsr	lgetmode
		bpl	cp_error_exit

		lea	msg_nodir(pc),a2
cp_error_exit:
		bsr	werror_myname_word_colon_msg
		bra	exit_program

too_few_args:
		lea	msg_too_few_args(pc),a0
		bsr	werror_myname_and_msg
usage:
		lea	msg_usage(pc),a0
		bsr	werror
		moveq	#1,d6
		bra	exit_program

dos_version_mismatch:
		lea	msg_dos_version_mismatch(pc),a0
		bra	cp_error_exit_3

insufficient_memory:
		lea	msg_no_memory(pc),a0
cp_error_exit_3:
		bsr	werror_myname_and_msg
		moveq	#3,d6
		bra	exit_program
*****************************************************************
* copy_into_dir
*
*      A0 �Ŏ������G���g���� A1 �Ŏ������f�B���N�g�����ɃR�s�[����
*
* CALL
*      D0.L   �ċA���x��
*
* NOTE
*      source ���L�����N�^�E�f�o�C�X�ł���ꍇ�̓G���[
*****************************************************************
destination = -((((MAXPATH+1)+1)>>1)<<1)
copy_into_dir_autosize = -destination

copy_into_dir:
		link	a6,#destination
		movem.l	d0-d3/d5/d7/a0-a3,-(a7)
		move.l	d0,d7
	*
	*  source���`�F�b�N����
	*
		bsr	open_source			*  source��open���Ă݂�
		cmp.l	#-1,d0
		beq	copy_into_dir_done

		move.l	d0,d1
		bmi	copy_into_dir_cannot_open_source

		*  source��open���ꂽ
		*  �L�����N�^�E�f�o�C�X�Ȃ�G���[
		tst.l	source_mode
		bpl	copy_into_dir_ok

		bsr	fclose
		lea	msg_is_device(pc),a2
		bsr	werror_myname_word_colon_msg
		bra	copy_into_dir_done

copy_into_dir_cannot_open_source:
		*  source��open����Ȃ�����
		*  -P �ł�source�����݂���G���g���ł��邱�Ƃ������Ń`�F�b�N���Ă���
		btst	#FLAG_path,d5
		beq	copy_into_dir_ok

		bsr	lgetmode
		bmi	copy_into_dir_perror
copy_into_dir_ok:
		btst	#FLAG_path,d5
		beq	copy_into_dir_3

		movea.l	a0,a2
		tst.b	(a2)
		beq	copy_into_dir_path_3

		cmpi.b	#':',1(a2)
		bne	copy_into_dir_path_1

		addq.l	#2,a2
copy_into_dir_path_1:
		cmpi.b	#'/',(a2)
		beq	copy_into_dir_path_2

		cmpi.b	#'\',(a2)
		beq	copy_into_dir_path_3
copy_into_dir_path_2:
		addq.l	#1,a2
copy_into_dir_path_3:
		bra	copy_into_dir_4

copy_into_dir_3:
		movea.l	a1,a2
		bsr	headtail
		exg	a1,a2				*  A2 : tail of source
copy_into_dir_4:
		move.l	a0,-(a7)
		lea	destination(a6),a0
		bsr	cat_pathname_x
		movea.l	(a7)+,a1
		bmi	copy_into_dir_done

		btst	#FLAG_path,d5
		beq	copy_into_dir_go
		*
		*  �����ŁC
		*       source:       A:/s1/s2/s3
		*                     |  |
		*                     A1 A2
		*
		*       targetdir:    B:/t1/t2/t3
		*
		*       destination:  B:/t1/t2/t3/s1/s2/s3
		*                     |           |
		*                     A0          A3
		*
make_path_loop:
		move.b	(a3)+,d0
		beq	copy_into_dir_go

		cmp.b	#'/',d0
		beq	make_path_slash_found

		cmp.b	#'\',d0
		beq	make_path_slash_found

		bsr	issjis
		bne	make_path_loop

		move.b	(a3)+,d0
		bne	make_path_loop
make_path_slash_found:
		move.b	d0,d2
		clr.b	-(a3)
		bsr	is_directory
		bmi	copy_into_dir_done
		bne	make_path_next

		btst	#FLAG_n,d5
		beq	make_path_mkdir
		*{
			bsr	lgetmode
			bmi	make_path_verbose

			moveq	#EMKDIREXISTS,d0
copy_into_dir_perror:
			bsr	perror
			bra	copy_into_dir_done
		*}
make_path_mkdir:
		bsr	do_mkdir
		bmi	copy_into_dir_perror

		btst	#FLAG_v,d5
		beq	make_path_next
make_path_verbose:
		pea	msg_mkdir(pc)
		DOS	_PRINT
		move.l	a0,-(a7)
		DOS	_PRINT
		pea	msg_newline(pc)
		DOS	_PRINT
		lea	12(a7),a7
make_path_next:
		move.b	d2,(a3)+
		bra	make_path_loop

copy_into_dir_go:
		exg	a0,a1
		move.l	d7,d2
		moveq	#0,d7
		bsr	copy_file_or_directory_1
copy_into_dir_done:
		movem.l	(a7)+,d0-d3/d5/d7/a0-a3
		unlk	a6
		rts
*****************************************************************
* copy_file_or_directory_0, copy_file_or_directory_1
*
*      A0 �Ŏ������t�@�C���܂��̓f�B���N�g����
*      A1 �Ŏ������t�@�C���܂��̓f�B���N�g���Ƃ��ăR�s�[����
*
* CALL
*      A0     source pathname
*      A1     destination pathname
*
*      copy_file_or_directory_1
*
*      �\�� open_source ����ɍs���āAsource_pathname �� source_mode ��
*      �Z�b�g����Ă�����̂Ƃ���D
*      D1.L   source�̃t�@�C���E�n���h��
*      D2.L   �ċA�̐[��
*      D7.L   0
*
* RETURN
*      D0-D3/D7/A0-A3  �j��
*      D5.L �� FLAG_path bit �̓N���A����邱�Ƃ�����
*****************************************************************
copy_directory_depth = -4
copy_directory_pathbuf = copy_directory_depth-((((MAXPATH+1)+1)>>1)<<1)
copy_directory_filesbuf = copy_directory_pathbuf-(((STATBUFSIZE+1)>>1)<<1)
copy_directory_autosize = -copy_directory_filesbuf

copy_file_or_directory_0:
		move.l	#-1,drive
		moveq	#-1,d7
		moveq	#0,d2
		*
		*  source��open���Ă݂�
		*
		bsr	open_source
		cmp.l	#-1,d0
		beq	copy_directory_done

		move.l	d0,d1				*  D1.L : source �̃t�@�C���E�n���h��
copy_file_or_directory_1:
		tst.l	d1
		bpl	copy_file			*  source�̓I�[�v���ł���
							*  .. �f�B���N�g���ł͂Ȃ�
		*
		*  source��open�ł��Ȃ����� ... �f�B���N�g�����ǂ����𒲂ׂ�
		*
		link	a6,#copy_directory_filesbuf
		lea	copy_directory_pathbuf(a6),a2
		bsr	is_directory_2			*  source���f�B���N�g�����ǂ����𒲂ׂ�
		bmi	copy_directory_done		*  �G���[
		bne	copy_directory

		*  �f�B���N�g���ł͂Ȃ� .. open�ł��Ȃ������G���[��\������
		move.l	d1,d0
		cmp.l	#EDIRVOL,d0
		bne	copy_directory_perror

		lea	msg_is_volumelabel(pc),a2
		bsr	werror_myname_word_colon_msg
		bra	copy_directory_done
****************
*
*  �f�B���N�g�����R�s�[����
*
copy_directory:
	*
	*  -r ���w�肳��Ă���Ȃ�C�ċA�I�ɃR�s�[����
	*  �����Ȃ��΃G���[
	*
		btst	#FLAG_r,d5
		beq	cannot_copy_directory
		*
		*  A2 : copy_directory_pathbuf : source/*.*
		*                                       |
		*                                       A3
	*
	*  �ċA���x���`�F�b�N
	*
		addq.l	#1,d2				*  �f�B���N�g���̐[�����C���N�������g
		cmp.l	#MAXRECURSE,d2
		bhi	dir_too_deep

		move.l	d2,copy_directory_depth(a6)
	*
	*  -x �̃h���C�u�̐ݒ�ƃ`�F�b�N
	*
		btst	#FLAG_x,d5
		beq	copy_directory_drive_ok		*  �`�F�b�N�s�v

		tst.l	drive
		bmi	copy_directory_get_drive

		bsr	lgetmode
		bmi	copy_directory_drive_ok

		move.l	a0,-(a7)
		lea	source_pathname(pc),a0
		bsr	getdno
		movea.l	(a7)+,a0
		cmp.l	drive,d0
		bne	copy_directory_done
		bra	copy_directory_drive_ok

copy_directory_get_drive:
		move.l	#-2,drive
		bsr	get_drive
copy_directory_drive_ok:
	*
	*  destination���`�F�b�N����
	*
		bclr	#31,d5
		exg	a0,a1
		movem.l	a1,-(a7)
		lea	realdest_pathname(pc),a1
		bsr	xopen				*  D1.L : real destination �� mode
							*         �������L�����N�^�E�f�o�C�X�Ȃ� -1
		movem.l	(a7)+,a1
		cmp.l	#-1,d0
		beq	copy_directory_done

		move.l	d0,d2
		bmi	copy_directory_check_dest

		bsr	fclose
copy_directory_check_dest:
		tst.l	d1
		bmi	copy_directory_dest_is_not_link

		btst	#MODEBIT_LNK,d1
		bne	copy_directory_dest_is_nondir
copy_directory_dest_is_not_link:
		bsr	is_directory
		bmi	copy_directory_done		*  �G���[
		bne	copy_directory_attributes	*  �f�B���N�g�����܂���
							*  �f�B���N�g���ւ̃V���{���b�N�E�����N
		*  destination�̓f�B���N�g���ł͂Ȃ�

		tst.l	d1
		bpl	copy_directory_dest_is_nondir

		*  destination�̃p�X������
		*  destination���G���g���Ƃ��đ��݂��Ȃ�
		*  destination�̓V���{���b�N�E�����N�ŁC���̎Q�ƃt�@�C�������݂��Ȃ�

		btst	#FLAG_n,d5
		beq	copy_directory_do_mkdir
		*{
			moveq	#EBADNAME,d0
			tst.l	d2
			bpl	copy_directory_perror

			move.l	d2,d0
			cmp.l	#ENOFILE,d0
			beq	copy_directory_mkdir_done

			cmp.l	#ENODIR,d0
			bne	copy_directory_perror

			tst.l	d7
			bpl	copy_directory_mkdir_done
copy_directory_perror:
			bsr	perror
			bra	copy_directory_done
		*}

copy_directory_dest_is_nondir:
		*  real destination �� non-directory
		exg	a0,a1
		bsr	confirm
		exg	a0,a1
		bne	copy_directory_done

		moveq	#EMKDIREXISTS,d0
		btst	#FLAG_f,d5
		beq	copy_directory_perror

		btst	#FLAG_n,d5
		bne	copy_directory_mkdir_done

		*  real destination ���폜����
		move.l	a0,-(a7)
		lea	realdest_pathname(pc),a0
		bsr	unlink
		movea.l	(a7)+,a0
copy_directory_do_mkdir:
		move.l	a0,-(a7)
		lea	realdest_pathname(pc),a0
		bsr	do_mkdir
		movea.l	(a7)+,a0
		bmi	copy_directory_perror
copy_directory_mkdir_done:
		exg	a0,a1
		bsr	verbose
		exg	a0,a1
		bset	#31,d5				*  real destinaiton �� new
		moveq	#MODEVAL_DIR,d1
copy_directory_attributes:
		exg	a0,a1
		btst	#FLAG_n,d5
		bne	copy_directory_contents

		tst.l	d1				*  real destination ��
		bmi	copy_directory_contents		*  ���ۂ̃T�u�E�f�B���N�g���łȂ�
	*
	*  source�̑����𓾂�
	*
		bsr	lgetmode
		bmi	copy_directory_attributes_done

		btst	#MODEBIT_LNK,d0
		beq	copy_directory_source_mode_ok

		lea	source_pathname(pc),a0
		bsr	lgetmode
		bmi	copy_directory_attributes_done
copy_directory_source_mode_ok:
		move.w	d0,d2				*  D2.W : source�̑���
		btst	#FLAG_p,d5
		beq	skip_copy_directory_date
	*
	*  �^�C���X�^���v���R�s�[����
	*
		bclr	#MODEBIT_DIR,d0
		bclr	#MODEBIT_VOL,d0
		bset	#MODEBIT_ARC,d0
		bsr	lchmod
		bmi	copy_directory_attributes_done

		moveq	#0,d0
		bsr	tfopen
		move.l	d0,d1
		bmi	copy_directory_open_source_fail

		move.l	d1,d0
		bsr	fgetdate
		exg	d0,d1
		bsr	fclose
			* �G���[�����ȗ� (����)
		exg	d0,d1
copy_directory_open_source_fail:
		move.l	d0,d3				*  D3.L : source�̃^�C���X�^���v
		move.w	d2,d0
		bsr	lchmod
			* �G���[�����ȗ� (����)
		cmp.l	#$ffff0000,d3
		bcc	copy_directory_mode

		lea	realdest_pathname(pc),a0
		move.w	#MODEVAL_ARC,d0
		bsr	lchmod
		bmi	copy_directory_mode

		moveq	#1,d0
		bsr	tfopen
		move.l	d0,d1
		bmi	copy_directory_mode

		move.l	d3,-(a7)
		move.w	d1,-(a7)
		DOS	_FILEDATE			*  �^�C���X�^���v��ݒ肷��
		addq.l	#6,a7
		move.w	d1,d0
		bsr	fclose
			* �G���[�����ȗ� (����)
		bra	copy_directory_mode

skip_copy_directory_date:
		btst	#31,d5
		beq	copy_directory_attributes_done
copy_directory_mode:
	*
	*  �������R�s�[����
	*
		lea	realdest_pathname(pc),a0
		move.w	d2,d0
		bsr	lchmod				*  ������ݒ肷��
			* �G���[�����ȗ� (����)
copy_directory_attributes_done:
copy_directory_contents:
	*
	*  �\�[�X�E�f�B���N�g�����̃t�@�C�����ċA�I�ɃR�s�[����
	*
		bclr	#FLAG_path,d5
		move.w	#MODEVAL_ALL,-(a7)		*  ���ׂẴG���g������������
		move.l	a2,-(a7)
		pea	copy_directory_filesbuf(a6)
		DOS	_FILES
		lea	10(a7),a7
copy_directory_contents_loop:
		tst.l	d0
		bmi	copy_directory_done

		btst.b	#MODEBIT_VOL,copy_directory_filesbuf+ST_MODE(a6)
		bne	copy_directory_sub_continue	*  �{�����[���E���x���̓R�s�[���Ȃ�

		lea	copy_directory_filesbuf+ST_NAME(a6),a0
		cmpi.b	#'.',(a0)
		bne	copy_directory_contents_dothis

		tst.b	1(a0)
		beq	copy_directory_sub_continue

		cmpi.b	#'.',1(a0)
		bne	copy_directory_contents_dothis

		tst.b	2(a0)
		beq	copy_directory_sub_continue
copy_directory_contents_dothis:
		move.l	a1,-(a7)
		movea.l	a0,a1
		movea.l	a3,a0
		bsr	strcpy
		movea.l	(a7)+,a1
		movea.l	a2,a0
		move.l	copy_directory_depth(a6),d0
		bsr	copy_into_dir
copy_directory_sub_continue:
		pea	copy_directory_filesbuf(a6)
		DOS	_NFILES
		addq.l	#4,a7
		bra	copy_directory_contents_loop

dir_too_deep:
		lea	msg_dir_too_deep(pc),a2
		bsr	werror_myname_word_colon_msg
		bra	copy_directory_done

cannot_copy_directory:
		lea	msg_is_directory(pc),a2
		bsr	werror_myname_word_colon_msg
copy_directory_done:
		unlk	a6
		bra	copy_file_or_directory_return
****************
*
*  �t�@�C�����R�s�[����
*
copy_file:
		lea	fatchkbuf1(pc),a2
		move.l	a2,d0
		bset	#31,d0
		move.w	#14,-(a7)
		move.l	d0,-(a7)
		pea	source_pathname(pc)
		DOS	_FATCHK
		lea	10(a7),a7
		move.w	(a2),d3
	*
	*  -x �̃`�F�b�N
	*
		btst	#FLAG_x,d5
		beq	copy_file_x_ok

		move.l	drive,d0
		bpl	copy_file_compare_drive

		cmp.l	#-1,d0
		beq	copy_file_x_ok

		bsr	get_drive
		bmi	copy_file_x_ok
copy_file_compare_drive:
		cmp.w	d0,d3
		bne	copy_file_done
copy_file_x_ok:
	*
	*  -s ���L�����ǂ����𒲂ׂ�
	*
		btst	#FLAG_s,d5
		beq	copy_file_s_ok

		movea.l	a0,a2
		tst.b	(a2)
		beq	copy_file_check_s

		cmpi.b	#':',1(a2)
		bne	copy_file_check_s

		addq.l	#2,a2
copy_file_check_s:
		cmpi.b	#'/',(a2)
		beq	copy_file_s_ok

		cmpi.b	#'\',(a2)
		beq	copy_file_s_ok

		movem.l	a0-a1,-(a7)
		movea.l	a1,a0
		bsr	headtail
		move.l	a1,d0
		sub.l	a0,d0
		movem.l	(a7)+,a0-a1
		beq	copy_file_s_ok

		lea	msg_dont_make_symbolic_link(pc),a2
		subq.l	#2,d0
		bne	copy_file_destination_error

		cmpi.b	#'.',(a1)
		bne	copy_file_destination_error

		cmpi.b	#'/',1(a1)
		beq	copy_file_s_ok

		cmpi.b	#'\',1(a1)
		bne	copy_file_destination_error
copy_file_s_ok:
	*
	*  destination��open���Ă݂�
	*
		movem.l	d1/d5/a0-a1,-(a7)
		movea.l	a1,a0
		lea	realdest_pathname(pc),a1
		btst	#FLAG_s,d5
		beq	open_destination

		bset	#FLAG_d,d5
open_destination:
		bsr	xopen
		move.l	d1,realdest_mode
		movem.l	(a7)+,d1/d5/a0-a1
		move.l	d0,d2
		bpl	check_destination

		cmp.l	#EDIRVOL,d0
		beq	cannot_overwrite_dirvol

		cmp.l	#ENOFILE,d0
		beq	create_dest_with_source_mode

		cmp.l	#ENODIR,d0
		bne	copy_file_perror_1

		btst	#FLAG_n,d5
		beq	copy_file_perror_1
		*{
			tst.l	d7
			bmi	copy_file_perror_1
			bra	create_dest_with_source_mode
		*}
check_destination:
		tst.l	realdest_mode
		bpl	check_identical
		*
		*  destination��open�ł����D����̓L�����N�^�E�f�o�C�X�ł���D
		*
		move.w	d2,d0
		bsr	fclose
		moveq	#EBADNAME,d0
		tst.l	d7
		bpl	copy_file_perror_1

		btst	#FLAG_d,d5
		bne	copy_file_perror_1

		btst	#FLAG_s,d5
		bne	copy_file_perror_1

		bsr	verbose
		btst	#FLAG_n,d5
		bne	copy_file_done

		*  �������݃��[�h�ōăI�[�v������D
		move.w	#1,-(a7)			*  �������݃��[�h��
		pea	realdest_pathname(pc)		*  �ăI�[�v������
		DOS	_OPEN
		addq.l	#6,a7
		bra	copy_file_contents

check_identical:
		*
		*  destination��open�ł����D����̓u���b�N�E�f�o�C�X�ł���D
		*  source �Ɠ���łȂ������`�F�b�N����D
		*
		lea	fatchkbuf2(pc),a3
		move.l	a3,d0
		bset	#31,d0
		move.w	#14,-(a7)
		move.l	d0,-(a7)
		pea	realdest_pathname(pc)
		DOS	_FATCHK
		lea	10(a7),a7
		lea	fatchkbuf1(pc),a2
		cmpm.w	(a2)+,(a3)+
		bne	copy_file_not_identical

		cmpm.l	(a2)+,(a3)+
		bne	copy_file_not_identical

		*  They are identical!
		bsr	werror_myname_and_msg
		lea	msg_and(pc),a0
		bsr	werror
		movea.l	a1,a0
		bsr	werror
		lea	msg_are_identical(pc),a0
		bsr	werror
		bsr	werror_newline_and_set_error
		bra	copy_file_done

copy_file_not_identical:
		btst	#FLAG_u,d5
		beq	update_ok

		move.w	d1,d0
		bsr	fgetdate
		bcc	update_ok

		move.l	d0,d3
		move.w	d2,d0
		bsr	fgetdate
		bcc	update_ok

		cmp.l	d3,d0
		bhs	copy_file_done
update_ok:
		bsr	confirm
		bne	copy_file_done

		move.w	d2,d0
		bsr	fclose
			* �G���[�����ȗ� (����)
		moveq	#-1,d2
		btst	#FLAG_f,d5
		bne	remove_and_create_dest_with_source_mode

		move.l	realdest_mode,d3
		bmi	create_dest_with_source_mode

		btst	#FLAG_p,d5
		bne	create_dest_with_source_mode

		and.w	#MODEVAL_EXE|MODEVAL_SYS|MODEVAL_HID|MODEVAL_RDO,d3
		move.l	source_mode,d0
		bmi	re_create_dest_with_arc

		and.w	#MODEVAL_LNK|MODEVAL_DIR|MODEVAL_VOL|MODEVAL_ARC,d0
		or.w	d0,d3
		bra	create_dest_1

re_create_dest_with_arc:
		bset	#MODEBIT_ARC,d3
		bra	create_dest_1

remove_and_create_dest_with_source_mode:
		btst	#FLAG_n,d5
		bne	create_dest_3

.if 0
		*  GNU fileutils 3.3 �� cp �ł́Cdestination���V���{���b�N�E
		*  �����N�ł��낤�Ɖ��ł��낤��destination���̂��̂��폜�����
		exg	a0,a1
		bsr	unlink
		exg	a0,a1
		*  ����͂�������
.else
		*  real destination ���폜����
		move.l	a0,-(a7)
		lea	realdest_pathname(pc),a0
		bsr	unlink
		movea.l	(a7)+,a0
		*  ���ꂪ�������Ǝv��
.endif
create_dest_with_source_mode:
		move.l	source_mode,d3
		bpl	create_dest_1

		move.w	#MODEVAL_ARC,d3
create_dest_1:
		btst	#FLAG_s,d5
		beq	create_dest_2

		move.w	#(MODEVAL_LNK|MODEVAL_ARC),d3
create_dest_2:
		move.l	a0,-(a7)
		lea	realdest_pathname(pc),a0
		bsr	lgetmode
		movea.l	(a7)+,a0
		bmi	create_dest_3

		*  real destination �����݂��Ă���

		lea	msg_cannot_create_link(pc),a2
		btst	#MODEBIT_LNK,d3			*  �V���{���b�N�E�����N��
		bne	copy_file_destination_error	*  �㏑���쐬���邱�Ƃ͂ł��Ȃ�

		lea	msg_cannot_overwrite_symlink(pc),a2
		btst	#MODEBIT_LNK,d0			*  �V���{���b�N�E�����N��
		bne	copy_file_destination_error	*  �㏑�����邱�Ƃ͂ł��Ȃ�
create_dest_3:
		bsr	verbose
		btst	#FLAG_n,d5
		bne	copy_file_done

		move.w	d3,-(a7)
		move.l	a1,-(a7)			*  destination��
		DOS	_CREATE				*  �쐬����
		addq.l	#6,a7				*  �i�h���C�u�̌����͍ς�ł���j
copy_file_contents:
		move.l	d0,d2
		bmi	copy_file_perror_1
	*
	*  �t�@�C���̓��e���R�s�[����
	*
		btst	#FLAG_s,d5
		beq	copy_loop

		bsr	strlen
		move.l	a0,d3
		bra	copy_write

copy_loop:
		move.l	d4,-(a7)
		move.l	a4,-(a7)
		move.w	d1,-(a7)
		DOS	_READ
		lea	10(a7),a7
		tst.l	d0
		bmi	copy_file_perror
		beq	copy_file_contents_done

		move.l	a4,d3
copy_write:
		move.l	d0,-(a7)
		move.l	d3,-(a7)
		move.w	d2,-(a7)
		move.l	d0,d3
		DOS	_WRITE
		lea	10(a7),a7
		tst.l	d0
		bmi	copy_file_perror_1

		cmp.l	d3,d0
		blt	copy_file_or_directory_disk_full

		btst	#FLAG_s,d5
		beq	copy_loop
copy_file_contents_done:
	*
	*  -p ���w�肳��Ă���΁A�t�@�C���̃^�C���X�^���v���R�s�[����
	*
		btst	#FLAG_p,d5
		beq	copy_file_date_done

		move.w	d1,d0
		bsr	fgetdate
		bcc	copy_file_date_done

		move.l	d0,-(a7)
		move.w	d2,-(a7)
		DOS	_FILEDATE
		addq.l	#6,a7
			* �G���[�����ȗ� (����)
copy_file_date_done:
copy_file_done:
		move.l	d2,d0
		bsr	fclosex
			* �G���[�����ȗ�
		move.l	d1,d0
		bsr	fclosex
			* �G���[�����ȗ�
copy_file_or_directory_return:
		rts

cannot_overwrite_dirvol:
		lea	msg_cannot_overwrite_dir(pc),a2
copy_file_destination_error:
		movea.l	a1,a0
		bsr	werror_myname_word_colon_msg
		bra	copy_file_done

copy_file_or_directory_disk_full:
		moveq	#EDISKFULL,d0
copy_file_perror_1:
		movea.l	a1,a0
copy_file_perror:
		cmp.l	#-1,d0
		beq	copy_file_done

		bsr	perror
		bra	copy_file_done
*****************************************************************
open_source:
		move.l	a1,-(a7)
		lea	source_pathname(pc),a1
		bsr	xopen
		move.l	d1,source_mode
		movea.l	(a7)+,a1
		tst.l	d0
		rts
*****************************************************************
confirm:
		move.l	a0,-(a7)
		btst	#FLAG_n,d5
		bne	confirm_yes

		btst	#FLAG_i,d5
		beq	confirm_yes

		movea.l	a1,a0
		bsr	werror
		lea	msg_confirm(pc),a0
		bsr	werror
		lea	getsbuf(pc),a0
		move.b	#GETSLEN,(a0)
		move.l	a0,-(a7)
		DOS	_GETS
		addq.l	#4,a7
		bsr	werror_newline
		moveq	#1,d0
		tst.b	1(a0)
		beq	confirm_done

		cmpi.b	#'y',2(a0)
		bne	confirm_done
confirm_yes:
		moveq	#0,d0
confirm_done:
		movea.l	(a7)+,a0
		tst.l	d0
		rts
*****************************************************************
verbose:
		btst	#FLAG_v,d5
		bne	do_verbose

		btst	#FLAG_n,d5
		beq	verbose_done
do_verbose:
		move.l	a0,-(a7)
		DOS	_PRINT
		pea	msg_arrow(pc)
		DOS	_PRINT
		move.l	a1,(a7)
		DOS	_PRINT
		pea	msg_newline(pc)
		DOS	_PRINT
		lea	12(a7),a7
verbose_done:
		rts
*****************************************************************
getdno:
		move.l	a1,-(a7)
		lea	fatchkbuf0(pc),a1
		move.l	a1,d0
		bset	#31,d0
		move.w	#14,-(a7)
		move.l	d0,-(a7)
		move.l	a0,-(a7)
		DOS	_FATCHK
		lea	10(a7),a7
		moveq	#0,d0
		move.w	(a1),d0
		movea.l	(a7)+,a1
		rts
*****************************************************************
get_drive:
		bsr	lgetmode
		bmi	get_drive_return

		bsr	getdno
		move.l	d0,drive
get_drive_return:
		rts
*****************************************************************
do_mkdir:
		move.l	a0,-(a7)
		DOS	_MKDIR
		addq.l	#4,a7
		tst.l	d0
		rts
*****************************************************************
unlink:
		move.w	#MODEVAL_ARC,-(a7)
		move.l	a0,-(a7)
		DOS	_CHMOD
		DOS	_DELETE
		addq.l	#6,a7
		rts
*****************************************************************
* xopen - �t�@�C���i�܂��̓f�o�C�X�j���I�[�v������
*
* CALL
*      A0     �I�[�v������t�@�C���i�܂��̓f�o�C�X�j��
*      A1     ���ۂɃI�[�v�������t�@�C���i�܂��̓f�o�C�X�j�����i�[����o�b�t�@
*             �i128�o�C�g�K�v�j
*      D5.B   FLAG_d�r�b�g�������Ă���΁A�t�@�C�����V���{���b�N�E�����N�ł���Ƃ�
*             �����N�E�t�@�C�����g���I�[�v������
*
* RETURN
*      D0.L   �I�[�v�������t�@�C���n���h���D�܂���DOS�G���[�E�R�[�h
*      D1.L   �I�[�v�������t�@�C���̃��[�h�D�������L�����N�^�E�f�o�C�X�Ȃ� -1
*****************************************************************
xopen:
		movem.l	d3/a2-a3/a6,-(a7)
		bsr	lgetmode
		move.l	d0,d1
		bmi	xopen_normal			*  �t�@�C���͖��� -> �ʏ�� OPEN
							*  �i�f�o�C�X�����m��Ȃ��j
		btst	#MODEBIT_LNK,d0
		beq	xopen_normal			*  SYMLINK�ł͂Ȃ� -> �ʏ�� OPEN

		*  �t�@�C���̓V���{���b�N�E�����N�ł���

		btst	#FLAG_d,d5			*  -d�t���O���w�肳��Ă���Ȃ�
		bne	xopen_link_on_lndrv		*  �w��t�@�C�����̂��̂�open����

		moveq	#LNDRV_getrealpath,d0
		tst.l	lndrv
		bne	xopen_on_lndrv			*  �����N���Q�Ƃ���t�@�C����open����

		lea	msg_cannot_access_link(pc),a2
		bsr	werror_myname_word_colon_msg
xopen_error:
		moveq	#-1,d0
		bra	xopen_done_1

xopen_link_on_lndrv:
		tst.l	lndrv				*  lndrv���풓���Ă��Ȃ��Ȃ�
		beq	xopen_normal			*  �ʏ�� OPEN

		moveq	#LNDRV_realpathcpy,d0
xopen_on_lndrv:
		movea.l	lndrv,a2
		movea.l	(a2,d0.l),a3
		clr.l	-(a7)
		DOS	_SUPER				*  �X�[�p�[�o�C�U�E���[�h�ɐ؂芷����
		addq.l	#4,a7
		move.l	d0,-(a7)			*  �O�� SSP �̒l
		movem.l	d2/d4-d7/a0-a5,-(a7)
		move.l	a0,-(a7)
		move.l	a1,-(a7)
		jsr	(a3)
		addq.l	#8,a7
		movem.l	(a7)+,d2/d4-d7/a0-a5
		tst.l	d0
		bmi	xopen_readlink_error

		exg	a0,a1
		bsr	strip_excessive_slashes
		bsr	lgetmode
		exg	a0,a1
		move.l	d0,d1
		movem.l	d1-d2/d4-d7/a0-a5,-(a7)
		clr.w	-(a7)
		move.l	a1,-(a7)
		movea.l	a7,a6
		movea.l	LNDRV_O_OPEN(a2),a3
		jsr	(a3)
		addq.l	#6,a7
		movem.l	(a7)+,d1-d2/d4-d7/a0-a5
		move.l	d0,d3
xopen_link_done:
		DOS	_SUPER				*  ���[�U�E���[�h�ɖ߂�
		addq.l	#4,a7
		move.l	d3,d0
		bra	xopen_done

xopen_readlink_error:
		DOS	_SUPER				*  ���[�U�E���[�h�ɖ߂�
		addq.l	#4,a7
xopen_normal:
		exg	a0,a1
		bsr	strcpy
		exg	a0,a1
		clr.w	-(a7)
		move.l	a0,-(a7)
		DOS	_OPEN
		addq.l	#6,a7
xopen_done:
		tst.l	d0
		bmi	xopen_done_1

		bsr	is_chrdev
		beq	xopen_return			*  �u���b�N�E�f�o�C�X
xopen_done_1:
		moveq	#-1,d1
xopen_return:
		movem.l	(a7)+,d3/a2-a3/a6
		rts
*****************************************************************
fclosex:
		bpl	fclose
		rts
*****************************************************************
* cat_pathname_x
*
* RETURN
*      A2     �j��
*****************************************************************
cat_pathname_x:
		bsr	cat_pathname
		bpl	cat_pathname_x_return

		lea	msg_too_long_pathname(pc),a2
		bsr	werror_myname_word_colon_msg
		tst.l	d0
cat_pathname_x_return:
		rts
*****************************************************************
fgetdate:
		clr.l	-(a7)
		move.w	d0,-(a7)
		DOS	_FILEDATE
		addq.l	#6,a7
		cmp.l	#$ffff0000,d0
		rts
*****************************************************************
lgetmode:
		moveq	#-1,d0
lchmod:
		move.w	d0,-(a7)
		move.l	a0,-(a7)
		DOS	_CHMOD
		addq.l	#6,a7
		tst.l	d0
		rts
*****************************************************************
malloc:
		move.l	d0,-(a7)
		DOS	_MALLOC
		addq.l	#4,a7
		tst.l	d0
		rts
*****************************************************************
is_chrdev:
		movem.l	d0,-(a7)
		move.w	d0,-(a7)
		clr.w	-(a7)
		DOS	_IOCTRL
		addq.l	#4,a7
		tst.l	d0
		bpl	is_chrdev_1

		moveq	#0,d0
is_chrdev_1:
		btst	#7,d0
		movem.l	(a7)+,d0
		rts
*****************************************************************
* is_directory, is_directory_2 - ���O���f�B���N�g���ł��邩�ǂ����𒲂ׂ�
*
* CALL
*      A0     ���O
*
*      is_directory_2
*      A2     ���O/*.* ���i�[����o�b�t�@
*
* RETURN
*      D0.L   ���O/*.* ����������Ȃ�� -1�D
*             ���̂Ƃ��G���[���b�Z�[�W���\������CD6.L �ɂ� 2 ���Z�b�g�����D
*
*             �����łȂ���΁C���O���f�B���N�g���Ȃ�� 1�C�����Ȃ��� 0
*
*      CCR    TST.L D0
*
*      is_directory_2
*      (A2)   ���O/*.* ���i�[�����
*                  |
*                  A3
*****************************************************************
is_directory:
		movem.l	a2-a3,-(a7)
		lea	pathname_buf(pc),a2
		bsr	is_directory_2
		movem.l	(a7)+,a2-a3
		rts

is_directory_2:
		movem.l	a0-a2,-(a7)
		tst.b	(a0)
		beq	is_directory_false

		movea.l	a0,a1
		movea.l	a2,a0
		lea	dos_wildcard_all(pc),a2
		bsr	cat_pathname_x
		bmi	is_directory_return

		move.w	#MODEVAL_ALL,-(a7)		*  ���ׂẴG���g������������
		move.l	a0,-(a7)
		pea	filesbuf(pc)
		DOS	_FILES
		lea	10(a7),a7
		tst.l	d0
		bpl	is_directory_true

		cmp.l	#ENOFILE,d0
		beq	is_directory_true
is_directory_false:
		moveq	#0,d0
		bra	is_directory_return

is_directory_true:
		moveq	#1,d0
is_directory_return:
		movem.l	(a7)+,a0-a2
		rts
*****************************************************************
werror_myname_and_msg:
		move.l	a0,-(a7)
		lea	msg_myname(pc),a0
		bsr	werror
		movea.l	(a7)+,a0
werror:
		movem.l	d0/a1,-(a7)
		movea.l	a0,a1
werror_1:
		tst.b	(a1)+
		bne	werror_1

		subq.l	#1,a1
		suba.l	a0,a1
		move.l	a1,-(a7)
		move.l	a0,-(a7)
		move.w	#2,-(a7)
		DOS	_WRITE
		lea	10(a7),a7
		movem.l	(a7)+,d0/a1
		rts
*****************************************************************
werror_newline:
		move.l	a0,-(a7)
		lea	msg_newline(pc),a0
		bsr	werror
		movea.l	(a7)+,a0
		rts
*****************************************************************
werror_myname_word_colon_msg:
		bsr	werror_myname_and_msg
		move.l	a0,-(a7)
		lea	msg_colon(pc),a0
		bsr	werror
		movea.l	a2,a0
		bsr	werror
		movea.l	(a7)+,a0
werror_newline_and_set_error:
		bsr	werror_newline
		moveq	#2,d6
		btst	#FLAG_e,d5
		bne	exit_program

		rts
*****************************************************************
perror:
		movem.l	d0/a2,-(a7)
		not.l	d0		* -1 -> 0, -2 -> 1, ...
		cmp.l	#25,d0
		bls	perror_2

		moveq	#0,d0
perror_2:
		lea	perror_table(pc),a2
		lsl.l	#1,d0
		move.w	(a2,d0.l),d0
		lea	sys_errmsgs(pc),a2
		lea	(a2,d0.w),a2
		bsr	werror_myname_word_colon_msg
		movem.l	(a7)+,d0/a2
		tst.l	d0
		rts
*****************************************************************
.data

	dc.b	0
	dc.b	'## cp 1.1 ##  Copyright(C)1992 by Itagaki Fumihiko',0

.even
perror_table:
	dc.w	msg_error-sys_errmsgs			*   0 ( -1)
	dc.w	msg_nofile-sys_errmsgs			*   1 ( -2)
	dc.w	msg_nopath-sys_errmsgs			*   2 ( -3)
	dc.w	msg_too_many_openfiles-sys_errmsgs	*   3 ( -4)
	dc.w	msg_error-sys_errmsgs			*   4 ( -5)
	dc.w	msg_error-sys_errmsgs			*   5 ( -6)
	dc.w	msg_error-sys_errmsgs			*   6 ( -7)
	dc.w	msg_error-sys_errmsgs			*   7 ( -8)
	dc.w	msg_error-sys_errmsgs			*   8 ( -9)
	dc.w	msg_error-sys_errmsgs			*   9 (-10)
	dc.w	msg_error-sys_errmsgs			*  10 (-11)
	dc.w	msg_error-sys_errmsgs			*  11 (-12)
	dc.w	msg_bad_name-sys_errmsgs		*  12 (-13)
	dc.w	msg_error-sys_errmsgs			*  13 (-14)
	dc.w	msg_bad_drive-sys_errmsgs		*  14 (-15)
	dc.w	msg_error-sys_errmsgs			*  15 (-16)
	dc.w	msg_error-sys_errmsgs			*  16 (-17)
	dc.w	msg_error-sys_errmsgs			*  17 (-18)
	dc.w	msg_write_disabled-sys_errmsgs		*  18 (-19)	CREATE
	dc.w	msg_cannot_mkdir-sys_errmsgs		*  19 (-20)	MKDIR
	dc.w	msg_error-sys_errmsgs			*  20 (-21)
	dc.w	msg_error-sys_errmsgs			*  21 (-22)
	dc.w	msg_disk_full-sys_errmsgs		*  22 (-23)
	dc.w	msg_directory_full-sys_errmsgs		*  23 (-24)
	dc.w	msg_error-sys_errmsgs			*  24 (-25)
	dc.w	msg_error-sys_errmsgs			*  25 (-26)

sys_errmsgs:
msg_error:		dc.b	'�G���[',0
msg_nofile:		dc.b	'���̂悤�ȃt�@�C����f�B���N�g���͂���܂���',0
msg_nopath:		dc.b	'�p�X�����݂��Ă��܂���',0
msg_too_many_openfiles:	dc.b	'�I�[�v�����Ă���t�@�C�����������܂�',0
msg_bad_name:		dc.b	'���O�������ł�',0
msg_bad_drive:		dc.b	'�h���C�u�̎w�肪�����ł�',0
msg_write_disabled:	dc.b	'�������݂�������Ă��܂���',0
msg_cannot_mkdir:	dc.b	'�f�B���N�g�����쐬�ł��܂���: �t�@�C�������݂��Ă��܂�',0
msg_directory_full:	dc.b	'�f�B���N�g�������t�ł�',0
msg_disk_full:		dc.b	'�f�B�X�N�����t�ł�',0

msg_myname:			dc.b	'cp'
msg_colon:			dc.b	': ',0
msg_dos_version_mismatch:	dc.b	'�o�[�W����2.00�ȍ~��Human68k���K�v�ł�',CR,LF,0
msg_no_memory:			dc.b	'������������܂���',CR,LF,0
msg_illegal_option:		dc.b	'�s���ȃI�v�V���� -- ',0
msg_too_few_args:		dc.b	'����������܂���',0
msg_too_long_pathname:		dc.b	'�p�X�������߂��܂�',0
msg_not_a_directory:		dc.b	'�f�B���N�g���ł͂���܂���',0
msg_nodir:			dc.b	'���̂悤�ȃf�B���N�g���͂���܂���',0
msg_dir_too_deep:		dc.b	'�f�B���N�g�����[�߂��ď����ł��܂���',0
msg_and:			dc.b	' �� ',0
msg_are_identical:		dc.b	' �Ƃ͓���̃t�@�C���ł��i�R�s�[���܂���j',0
msg_is_directory:		dc.b	'�f�B���N�g���ł��i�R�s�[���܂���j',0
msg_is_volumelabel:		dc.b	'�{�����[���E���x���ł��i�R�s�[���܂���j',0
msg_is_device:			dc.b	'�L�����N�^�E�f�o�C�X�ł��i�R�s�[���܂���j',0
msg_dont_make_symbolic_link:	dc.b	'���΃V���{���b�N�E�����N�́e.�f�ɂ̂ݍ쐬�\�ł�',0
msg_cannot_access_link:		dc.b	'lndrv���g�ݍ��܂�Ă��Ȃ����߃V���{���b�N�E�����N�̎Q�ƃt�@�C���ɃA�N�Z�X�ł��܂���',0
msg_confirm:			dc.b	' �ɏ㏑�����Ă�낵���ł����H',0
msg_cannot_overwrite_dir:	dc.b	'�f�B���N�g����{�����[���E���x���ɂ͏������߂܂���',0
msg_cannot_overwrite_symlink:	dc.b	'�V���{���b�N�E�����N�ɂ͏������߂܂���',0
msg_cannot_create_link:		dc.b	'�V���{���b�N�E�����N���쐬�ł��܂���: �t�@�C�������݂��Ă��܂�',0
msg_usage:			dc.b	CR,LF,CR,LF
	dc.b	'�g�p�@:  cp [-adfinpsuv] [-] f1 f2',CR,LF
	dc.b	'              f1: �R�s�[����t�@�C���܂��͓��̓f�o�C�X',CR,LF
	dc.b	'              f2: �����t�@�C�����܂��͏o�̓f�o�C�X',CR,LF,CR,LF

	dc.b	'         cp {-r|-R} [-adefinpsuvx] [-] d1 d2',CR,LF
	dc.b	'              d1: �R�s�[����f�B���N�g��',CR,LF
	dc.b	'              d2: �����f�B���N�g�����i�V�K�j',CR,LF,CR,LF

	dc.b	'         cp [-adefinprsuvxPR] [-] any ... targetdir',CR,LF
	dc.b	'              any: �R�s�[����t�@�C����f�B���N�g��',CR,LF
	dc.b	'              targetdir: �R�s�[��f�B���N�g��'
msg_newline:		dc.b	CR,LF,0
msg_arrow:		dc.b	' -> ',0
msg_mkdir:		dc.b	'mkdir ',0
dos_wildcard_all:	dc.b	'*.*',0
*****************************************************************
.bss

lndrv:			ds.l	1
source_mode:		ds.l	1
realdest_mode:		ds.l	1
drive:			ds.w	1
.even
fatchkbuf0:		ds.b	14
.even
fatchkbuf1:		ds.b	14
.even
fatchkbuf2:		ds.b	14
.even
filesbuf:		ds.b	STATBUFSIZE
.even
getsbuf:		ds.b	2+GETSLEN+1
source_pathname:	ds.b	128
realdest_pathname:	ds.b	128
pathname_buf:		ds.b	128
.even
			ds.b	4096+(copy_into_dir_autosize+4*12+copy_directory_autosize+4*3)*(MAXRECURSE+1)
			*  �K�v�ȃX�^�b�N�ʂ́C�ċA�̓x�ɏ�����X�^�b�N�ʂ�
			*  ���̉񐔂ƂŌ��܂�D
			*  ���̑��Ƀ}�[�W�����܂߂��~�j�}���ʂƂ��� 4096�o�C�g���m�ۂ��Ă����D
			*  ���̃v���O�����ł� 4096�o�C�g����Ώ[���ł���D
			*  �ilndrv �� 1.5KB���򂤉\��������j
			*  4*12 ... copy_into_dir �ł̃Z�[�u���W�X�^ D0-D3/D5/D7/A0-A3/A6/PC
			*  4*3 ... copy_directory �ł̃Z�[�u���W�X�^ A0/A6/PC
.even
stack_bottom:
*****************************************************************

.end start