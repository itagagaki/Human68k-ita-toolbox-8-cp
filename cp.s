* cp - copy file
*
* Itagaki Fumihiko 05-Jul-92  Create.
* 1.0
* Itagaki Fumihiko 06-Nov-92  strip_excessive_slashes のバグfixに伴う改版．
*                             fatchkバグ対策．
*                             些細なメッセージ変更．
* 1.2
* Itagaki Fumihiko 27-Dec-92  -I オプションと -m オプションの追加．
* Itagaki Fumihiko 28-Dec-92  プロテクトされたメディアから cp -rp でディレクトリをコピー
*                             できなかった不具合を修正．
* Itagaki Fumihiko 28-Dec-92  -x が正しく働いていなかったバグを修正．
* 1.3
* Itagaki Fumihiko 10-Jan-93  GETPDB -> lea $10(a0),a0
* Itagaki Fumihiko 20-Jan-93  引数 - と -- の扱いの変更
* Itagaki Fumihiko 22-Jan-93  スタックを拡張
* Itagaki Fumihiko 24-Jan-93  FATCHK のエラー EBADPARAM を無視することを忘れていたのを修正；
*                             -x が正しく働かない可能性があった．
* 1.4
* Itagaki Fumihiko 12-Feb-93  特殊デバイスに対応し，source と destination のどちらかで FATCHK
*                             が EBADPARAM 以外のエラーを返した場合には identical ではないと見
*                             なすようにした．
* Itagaki Fumihiko 13-Feb-93  -P foo bar で bar/foo ではなく bar/oo が作成されてしまうバグを修
*                             正．
* Itagaki Fumihiko 16-Feb-93  ディレクトリを新規コピーするとき，コピー元が「属性を持たないディ
*                             レクトリ」である場合にもコピー先に対して -m オプションが効くよう
*                             修正．
* Itagaki Fumihiko 16-Feb-93  -V オプションの追加
* Itagaki Fumihiko 16-Feb-93  その他些細な修正と最適化
* 1.5
* Itagaki Fumihiko 18-Feb-93  source が symbolic link であると exceptional abort するバグ
*                             （v1.5 でのエンバグ）を修正
* Itagaki Fumihiko 20-Feb-93  確認メッセージを若干詳しくした
* Itagaki Fumihiko 20-Feb-93  ボリューム・ラベルのコピー先のディレクトリ内にボリューム・ラベ
*                             ルが存在している場合，-f オプションが指定されていれば，それを
*                             予め強制的に削除してからコピーし，そうでなければエラーとなるよ
*                             うにした．
* Itagaki Fumihiko 20-Feb-93  cp -r foo foo/bar （foo/bar は新規）のようなケースで無限再帰し
*                             ないようにした．ただし cp -r foo foo/bar/baz のようなケースで
*                             は，やはり無限再帰する．
* Itagaki Fumihiko 20-Feb-93  その他些細だが重要な修正
* 1.6
* Itagaki Fumihiko 18-Feb-93  source が symbolic link であるとコピーできないことがあるバグ
*                             （v1.5 でのエンバグ）を修正
* 1.7
* Itagaki Fumihiko 03-Nov-93  高速化
* Itagaki Fumihiko 03-Nov-93  -m-w+x （-m と mode をくっつけて指定）を許す
* Itagaki Fumihiko 03-Nov-93  -m 644 （8進数値表現）を許す
* Itagaki Fumihiko 03-Nov-93  -g オプションの追加
* 1.8(非公開)
* Itagaki Fumihiko 04-Nov-93  -g オプションを廃止．その代わり，コピー元ファイルとコピー先ファイ
*                             ルが同一でないことが理屈の上で明確である場合に限りチェックしない
*                             ようにした．
* 1.9(非公開)
* Itagaki Fumihiko 11-Nov-93  ディレクトリをコピーするとき，ディレクトリ内のシンボリック・リン
*                             クが正しく処理されないバグ（v1.9 でのエンバグ）を修正
* Itagaki Fumihiko 13-Nov-93  -CDLSU オプションの追加
* 2.0(非公開)
* Itagaki Fumihiko 24-Nov-93  ボリューム・ラベルをコピーするとエラーになるバグ（v1.8 でのエンバ
*                             グ）を修正
* 2.1(非公開)
* Itagaki Fumihiko 26-Nov-93  -Sオプションを指定すると，システム・ファイルに出会う度にファイ
*                             ル・ハンドルを消費してしまうバグを修正．
* Itagaki Fumihiko 26-Nov-93  再帰コピー先がデバイスであるとき（エラー），コピー先のファイル・
*                             ハンドルを 2度closeしてしまうバグ（実害はない）を修正．
* Itagaki Fumihiko 27-Nov-93  -pオプションを指定してもディレクトリやボリューム・ラベルのタイム
*                             スタンプがコピーされないバグ（v1.8 でのエンバグ）を修正．
* Itagaki Fumihiko 27-Nov-93  最適化と高速化．
* 2.2
* Itagaki Fumihiko 02-Dec-93  -Cオプションか-Dオプションを指定すると ?: や ?:/ がコピーされない
*                             バグを修正．
* 2.3
* Itagaki Fumihiko 12-Dec-93  -Cオプションを指定していているとき，調整できない名前のファイルが
*                             あればエラーとなるようにした．
* Itagaki Fumihiko 28-Dec-93  -Cオプションは -Bオプションに変更し，新たに -Cオプションを追加
* 2.4
*
* Usage: cp [ -IRSVadfinpsuv ] [ -m mode ] [ - ] <ファイル1> <ファイル2>
*        cp -Rr [ -BCDILUSVadefinpsuv ] [ -m mode ] [ - ] <ディレクトリ1> <ディレクトリ2>
*        cp [ -BCDILPRSUVadefinprsuv ] [ -m mode ] [ - ] <ファイル> ... <ディレクトリ>

.include doscall.h
.include error.h
.include limits.h
.include stat.h
.include chrcode.h

.xref DecodeHUPAIR
.xref getlnenv
.xref issjis
.xref islower
.xref toupper
.xref strlen
.xref strcpy
.xref stpcpy
.xref strfor1
.xref strmove
.xref memmovi
.xref headtail
.xref cat_pathname
.xref skip_root
.xref find_slashes
.xref strip_excessive_slashes

REQUIRED_OSVER	equ	$200			*  2.00以降

MAXRECURSE	equ	64	*  サブディレクトリを削除するために再帰する回数の上限．
				*  MAXDIR （パス名のディレクトリ部 "/1/2/3/../" の長さ）
				*  が 64 であるから、31で充分であるが，
				*  シンボリック・リンクを考慮して 64 とする．
				*  スタック量にかかわる．

GETSLEN		equ	32

FLAG_d		equ	0
FLAG_e		equ	1
FLAG_f		equ	2
FLAG_i		equ	3
FLAG_I		equ	4
FLAG_n		equ	5
FLAG_p		equ	6
FLAG_r		equ	7
FLAG_s		equ	8
FLAG_u		equ	9
FLAG_v		equ	10
FLAG_x		equ	11
FLAG_path	equ	12
FLAG_V		equ	13
FLAG_B		equ	14
FLAG_C		equ	15
FLAG_D		equ	16
FLAG_L		equ	17
FLAG_U		equ	18
FLAG_S		equ	19

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
		lea	stack_bottom,a7			*  A7 := スタックの底
		DOS	_VERNUM
		cmp.w	#REQUIRED_OSVER,d0
		bcs	dos_version_mismatch

		lea	$10(a0),a0			*  A0 : PDBアドレス
		move.l	a7,d0
		sub.l	a0,d0
		move.l	d0,-(a7)
		move.l	a0,-(a7)
		DOS	_SETBLOCK
		addq.l	#8,a7
	*
	*  引数並び格納エリアを確保する
	*
		lea	1(a2),a0			*  A0 := コマンドラインの文字列の先頭アドレス
		bsr	strlen				*  D0.L := コマンドラインの文字列の長さ
		addq.l	#1,d0
		bsr	malloc
		bmi	insufficient_memory

		movea.l	d0,a1				*  A1 := 引数並び格納エリアの先頭アドレス
	*
	*  バッファを確保する
	*
		move.l	#$00ffffff,d0
		bsr	malloc
		sub.l	#$81000000,d0
		cmp.l	#1024,d0
		blo	no_buffer

		move.l	d0,d4				*  D4.L : バッファサイズ
		bsr	malloc
		bmi	no_buffer

		movea.l	d0,a4				*  A4 : バッファ
		bra	buffer_ok

no_buffer:
		moveq	#0,d4
buffer_ok:
	*
	*  lndrv が組み込まれているかどうかを検査する
	*
		bsr	getlnenv
		move.l	d0,lndrv
	*
	*  引数をデコードし，解釈する
	*
		bsr	DecodeHUPAIR			*  引数をデコードする
		movea.l	a1,a0				*  A0 : 引数ポインタ
		move.l	d0,d7				*  D7.L : 引数カウンタ
		move.b	#$ff,mode_mask
		clr.b	mode_plus
		moveq	#0,d5				*  D5.L : フラグ
decode_opt_loop1:
		tst.l	d7
		beq	decode_opt_done

		cmpi.b	#'-',(a0)
		bne	decode_opt_done

		tst.b	1(a0)
		beq	decode_opt_done

		subq.l	#1,d7
		addq.l	#1,a0
		move.b	(a0)+,d0
		cmp.b	#'-',d0
		bne	decode_opt_loop2

		tst.b	(a0)+
		beq	decode_opt_done

		subq.l	#1,a0
decode_opt_loop2:
		cmp.b	#'a',d0
		beq	set_option_a

		moveq	#FLAG_f,d1
		cmp.b	#'f',d0
		beq	set_option

		moveq	#FLAG_i,d1
		cmp.b	#'i',d0
		beq	set_option

		moveq	#FLAG_I,d1
		cmp.b	#'I',d0
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

		moveq	#FLAG_V,d1
		cmp.b	#'V',d0
		beq	set_option

		moveq	#FLAG_B,d1
		cmp.b	#'B',d0
		beq	set_option

		moveq	#FLAG_C,d1
		cmp.b	#'C',d0
		beq	set_option

		moveq	#FLAG_D,d1
		cmp.b	#'D',d0
		beq	set_option

		moveq	#FLAG_L,d1
		cmp.b	#'L',d0
		beq	set_option

		moveq	#FLAG_U,d1
		cmp.b	#'U',d0
		beq	set_option

		moveq	#FLAG_S,d1
		cmp.b	#'S',d0
		beq	set_option

		cmp.b	#'m',d0
		beq	decode_mode

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

decode_mode:
		tst.b	(a0)
		bne	decode_mode_0

		subq.l	#1,d7
		bcs	too_few_args

		addq.l	#1,a0
decode_mode_0:
		move.b	(a0),d0
		cmp.b	#'0',d0
		blo	decode_symbolic_mode

		cmp.b	#'7',d0
		bhi	decode_symbolic_mode

	*  numeric mode

		moveq	#0,d1
scan_numeric_mode_loop:
		move.b	(a0)+,d0
		beq	scan_numeric_mode_done

		sub.b	#'0',d0
		blo	bad_arg

		cmp.b	#7,d0
		bhi	bad_arg

		lsl.w	#3,d1
		or.b	d0,d1
		bra	scan_numeric_mode_loop

scan_numeric_mode_done:
		move.w	d1,d0
		lsr.w	#3,d0
		or.w	d0,d1
		lsr.w	#3,d0
		or.w	d0,d1
		moveq	#0,d0
		btst	#1,d1
		beq	decode_numeric_mode_w_ok

		bset	#MODEBIT_RDO,d0
decode_numeric_mode_w_ok:
		btst	#0,d1
		beq	decode_numeric_mode_x_ok

		bset	#MODEBIT_EXE,d0
decode_numeric_mode_x_ok:
		move.b	d0,mode_plus
		move.b	#(MODEVAL_VOL|MODEVAL_DIR|MODEVAL_LNK|MODEVAL_ARC|MODEVAL_SYS|MODEVAL_HID),mode_mask
		bra	decode_opt_loop1

	*  symbolic mode

decode_symbolic_mode:
		move.b	#$ff,mode_mask
		clr.b	mode_plus
decode_symbolic_mode_loop1:
		move.b	(a0)+,d0
		beq	decode_opt_loop1

		cmp.b	#',',d0
		beq	decode_symbolic_mode_loop1

		subq.l	#1,a0
decode_symbolic_mode_loop2:
		move.b	(a0)+,d0
		cmp.b	#'u',d0
		beq	decode_symbolic_mode_loop2

		cmp.b	#'g',d0
		beq	decode_symbolic_mode_loop2

		cmp.b	#'o',d0
		beq	decode_symbolic_mode_loop2

		cmp.b	#'a',d0
		beq	decode_symbolic_mode_loop2
decode_symbolic_mode_loop3:
		cmp.b	#'+',d0
		beq	decode_symbolic_mode_plus

		cmp.b	#'-',d0
		beq	decode_symbolic_mode_minus

		cmp.b	#'=',d0
		bne	bad_arg

		move.b	#(MODEVAL_VOL|MODEVAL_DIR|MODEVAL_LNK),mode_mask
		clr.b	mode_plus
decode_symbolic_mode_plus:
		bsr	decode_symbolic_mode_sub
		or.b	d1,mode_plus
		bra	decode_symbolic_mode_continue

decode_symbolic_mode_minus:
		bsr	decode_symbolic_mode_sub
		not.b	d1
		and.b	d1,mode_mask
		and.b	d1,mode_plus
decode_symbolic_mode_continue:
		tst.b	d0
		beq	decode_opt_loop1

		cmp.b	#',',d0
		beq	decode_symbolic_mode_loop1
		bra	decode_symbolic_mode_loop3

decode_symbolic_mode_sub:
		moveq	#0,d1
decode_symbolic_mode_sub_loop:
		move.b	(a0)+,d0
		moveq	#MODEBIT_ARC,d2
		cmp.b	#'a',d0
		beq	decode_symbolic_mode_sub_set

		moveq	#MODEBIT_SYS,d2
		cmp.b	#'s',d0
		beq	decode_symbolic_mode_sub_set

		moveq	#MODEBIT_HID,d2
		cmp.b	#'h',d0
		beq	decode_symbolic_mode_sub_set

		cmp.b	#'r',d0
		beq	decode_symbolic_mode_sub_loop

		moveq	#MODEBIT_RDO,d2
		cmp.b	#'w',d0
		beq	decode_symbolic_mode_sub_set

		moveq	#MODEBIT_EXE,d2
		cmp.b	#'x',d0
		beq	decode_symbolic_mode_sub_set

		rts

decode_symbolic_mode_sub_set:
		bset	d2,d1
		bra	decode_symbolic_mode_sub_loop

decode_opt_done:
		subq.l	#2,d7
		bcs	too_few_args
	*
	*  targetを調べる
	*
		moveq	#0,d6				*  D6.W : エラー・コード
		movea.l	a0,a1				*  A1 : 1st source
		move.l	d7,d0
find_target:
		bsr	strfor1
		subq.l	#1,d0
		bcc	find_target
							*  A0 : target
		bsr	strip_excessive_slashes

		*  targetがディレクトリであるかどうかを調べる
		*
		*  ここでは、ディレクトリへのシンボリック・リンクも現実の
		*  ディレクトリと同等に扱う。-d オプションは影響しない。

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
		bsr	copy_into_dir_0
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

bad_arg:
		lea	msg_bad_arg(pc),a0
		bra	arg_error

too_few_args:
		lea	msg_too_few_args(pc),a0
arg_error:
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
* copy_into_dir_0, copy_into_dir_1
*
*      A0 で示されるエントリを A1 で示されるディレクトリ下にコピーする
*
* CALL
*      D0.L   再帰レベル
*
* NOTE
*      source がキャラクタ・デバイスである場合はエラー
*****************************************************************
destination = -((((MAXPATH+1)+1)>>1)<<1)
copy_into_dir_autosize = -destination

copy_into_dir_0:
		move.l	#-1,source_mode
		move.l	#-1,source_time
		st	do_check_identical
copy_into_dir_1:
		link	a6,#destination
		movem.l	d0-d3/d5/d7/a0-a3,-(a7)
		move.l	d0,d7				*  D7.L : 再帰レベル
		move.l	a0,copy_into_dir_sourceP
		btst	#FLAG_path,d5
		bne	copy_into_dir_skip_root

		move.l	a1,-(a7)
		bsr	headtail
		movea.l	a1,a0
		movea.l	(a7)+,a1
		bra	copy_into_dir_2

copy_into_dir_skip_root:
		bsr	skip_root
copy_into_dir_2:
		movea.l	a0,a2
		*
		*  ここで，
		*       source:       A:/s1/s2/s3
		*                        |     |
		*                        A0    A0
		*                        A2    A2
		*                        (-P)
		*
		*       targetdir:    B:/t1/t2/t3
		*                     |
		*                     A1
	*
	*  -L オプションが指定されているとき，A0以降に小文字が含まれていないかどうか
	*  チェックする
	*
		btst	#FLAG_L,d5
		beq	check_name_case_ok
check_name_case:
		move.b	(a0)+,d0
		beq	check_name_case_ok

		bsr	islower
		beq	copy_into_dir_done

		bsr	issjis
		bne	check_name_case

		tst.b	(a0)+
		bne	check_name_case
check_name_case_ok:
	*
	*  destination name を作る
	*
		lea	destination(a6),a0
		move.l	#MAXPATH,d2
		*
		*  ここで，
		*       source:       A:/s1/s2/s3
		*                        |     |
		*                        A2    A2
		*                        (-P)
		*
		*       targetdir:    B:/t1/t2/t3
		*                     |
		*                     A1
		*
		*       destination:  ???
		*                     |
		*                     A0

		*
		*  targetdir を destination にコピーする
		*
		exg	a0,a1
		bsr	strlen
		exg	a0,a1
		sub.l	d0,d2
		bcs	copy_into_dir_too_long_path

		bsr	stpcpy
		exg	a0,a1
		bsr	skip_root
		exg	a0,a1
		beq	copy_into_dir_makedestname_1

		subq.l	#1,d2
		bcs	copy_into_dir_too_long_path

		move.b	#'/',(a0)+
copy_into_dir_makedestname_1:
		move.l	a0,copy_into_dir_destP
		*
		*  ここで，
		*       source:       A:/s1/s2/s3
		*                        |     |
		*                        A2    A2
		*                        (-P)
		*
		*       destination:  B:/t1/t2/t3/
		*                                 |
		*                                 A0
		*
		tst.b	(a2)
		beq	copy_into_dir_makedestname_2

		btst	#FLAG_B,d5
		bne	copy_into_dir_makedestname_3

		btst	#FLAG_C,d5
		bne	copy_into_dir_makedestname_3

		btst	#FLAG_D,d5
		bne	copy_into_dir_makedestname_3
copy_into_dir_makedestname_2:
		*
		*  A2以降を destination に追加する
		*
		exg	a0,a2
		bsr	strlen
		exg	a0,a2
		sub.l	d0,d2
		bcs	copy_into_dir_too_long_path

		movea.l	a2,a1
		bsr	strcpy
		bra	destname_ok

copy_into_dir_makedestname_3:
		movea.l	a0,a3
		*
		*  ここで，
		*       source:       A:/s1/s2/s3
		*                        |     |
		*                        A2    A2
		*                        (-P)
		*
		*       destination:  B:/t1/t2/t3/
		*                                 |
		*                                 A3
		*
copy_into_dir_makedestname_loop1:
		movea.l	a2,a0
		bsr	find_slashes
		exg	a0,a2
		move.b	d0,d3
		clr.b	(a2)
		movea.l	a0,a5
		move.l	a3,-(a7)
		lea	pathname_buf(pc),a3
		sf	d1
		movea.l	a0,a1
		bsr	isrel
		adda.l	d0,a0
		bne	makedestname_primary_ok

		bsr	find_dot
		tst.l	d0
		beq	makedestname_unadjustable_name

		cmp.l	#8,d0
		bls	makedestname_primary_ok

		moveq	#8,d0
		st	d1
makedestname_primary_ok:
		exg	a0,a3
		bsr	memmovi
		exg	a0,a3
		tst.b	(a0)+
		beq	makedestname_check

		bsr	find_dot
		tst.b	(a0)
		bne	makedestname_unadjustable_name

		tst.l	d0
		beq	makedestname_adjust_suffix

		move.b	#'.',(a3)+
		suba.l	d0,a0
		cmp.l	#3,d0
		bls	makedestname_suffix_ok

		moveq	#3,d0
makedestname_adjust_suffix:
		st	d1
makedestname_suffix_ok:
		movea.l	a0,a1
		exg	a0,a3
		bsr	memmovi
		exg	a0,a3
		bra	makedestname_check

makedestname_unadjustable_name:
		st	d1
		lea	pathname_buf(pc),a3
makedestname_check:
		clr.b	(a3)
		movea.l	(a7)+,a3
		lea	pathname_buf(pc),a1
		tst.b	d1
		beq	makedestname_next

		*  unfit name

		btst	#FLAG_D,d5
		bne	copy_into_dir_done

		btst	#FLAG_C,d5
		bne	unfit_name

		tst.b	(a1)
		bne	makedestname_next
unfit_name:
		movea.l	a5,a0
		bsr	werror_myname
		movea.l	copy_into_dir_sourceP,a0
		move.b	d3,(a2)
		bsr	werror
		clr.b	(a2)
		lea	msg_colon(pc),a0
		bsr	werror
ask_destname_1:
		movea.l	a5,a0
		bsr	werror
		btst	#FLAG_C,d5
		bne	ask_destname_2

		lea	msg_unadjustable_name(pc),a0
		bsr	werror
		bra	copy_into_dir_done

ask_destname_2:
		lea	msg_unfitname(pc),a0
		bsr	werror
		btst	#FLAG_n,d5
		beq	ask_destname_3

		lea	msg_will_ask(pc),a0
		bsr	werror
		movea.l	a5,a1
		bra	makedestname_next

ask_destname_3:
		bsr	werror_newline
ask_destname_4:
		lea	msg_destname(pc),a0
		bsr	werror
		tst.b	(a1)
		beq	ask_destname_5

		lea	msg_destname_1(pc),a0
		bsr	werror
		movea.l	a1,a0
		bsr	werror
ask_destname_5:
		lea	msg_destname_2(pc),a0
		bsr	werror
		lea	getsbuf(pc),a0
		move.b	#12,(a0)
		move.l	a0,-(a7)
		DOS	_GETS
		addq.l	#4,a7
		bsr	werror_newline
		moveq	#0,d0
		move.b	1(a0),d0
		bne	check_answered_destname

		tst.b	(a1)
		beq	ask_destname_4
		bra	makedestname_next

check_answered_destname:
		addq.l	#2,a0
		clr.b	(a0,d0.l)
		cmpi.b	#'.',(a0)
		beq	copy_into_dir_done

		movea.l	a0,a5
		sf	d1
check_answered_destname_loop:
		move.b	(a0)+,d0
		beq	check_answered_destname_done

		cmp.b	#'.',d0
		beq	check_answered_destname_dot

		cmp.b	#'?',d0
		beq	ask_destname_1

		cmp.b	#'*',d0
		beq	ask_destname_1

		cmp.b	#'<',d0
		beq	ask_destname_1

		cmp.b	#'>',d0
		beq	ask_destname_1

		cmp.b	#':',d0
		beq	ask_destname_1

		cmp.b	#'/',d0
		beq	ask_destname_1

		cmp.b	#'\',d0
		beq	ask_destname_1

		bsr	issjis
		bne	check_answered_destname_loop

		tst.b	(a0)+
		beq	check_answered_destname_done
		bra	check_answered_destname_loop

check_answered_destname_dot:
		tst.b	d1
		bne	ask_destname_1

		bsr	strlen
		subq.l	#3,d0
		bhi	ask_destname_1

		st	d1
		bra	check_answered_destname_1

check_answered_destname_done:
		tst.b	d1
		bne	answered_destname_ok
check_answered_destname_1:
		move.l	a0,d0
		subq.l	#1,d0
		sub.l	a5,d0
		beq	ask_destname_1

		subq.l	#8,d0
		bhi	ask_destname_1

		tst.b	d1
		bne	check_answered_destname_loop
answered_destname_ok:
		movea.l	a5,a1
makedestname_next:
		movea.l	a1,a0
		bsr	strlen
		sub.l	d0,d2
		bcs	copy_into_dir_too_long_path

		exg	a0,a3
		bsr	memmovi
		exg	a0,a3
		move.b	d3,(a2)+
		bne	copy_into_dir_makedestname_loop1

		clr.b	(a3)
destname_ok:
		*
		*  -U が指定されていれば大文字に変換する
		*
		btst	#FLAG_U,d5
		beq	copy_into_dir_destname_ok

		movea.l	copy_into_dir_destP,a0
copy_into_dir_toupper:
		move.b	(a0),d0
		beq	copy_into_dir_destname_ok

		bsr	issjis
		beq	copy_into_dir_toupper_sjis

		bsr	toupper
		move.b	d0,(a0)+
		bra	copy_into_dir_toupper

copy_into_dir_toupper_sjis:
		addq.l	#1,a0
		tst.b	(a0)+
		bne	copy_into_dir_toupper
copy_into_dir_destname_ok:
	*
	*  sourceをチェックする
	*
		movea.l	copy_into_dir_sourceP,a0
		move.l	source_mode,d0
		bmi	copy_into_dir_check_source

		btst	#MODEBIT_LNK,d0
		beq	copy_into_dir_source_ok

		btst	#FLAG_d,d5
		beq	copy_into_dir_check_source
copy_into_dir_source_ok:
		movea.l	a0,a1
		lea	source_pathname(pc),a0
		bsr	strcpy
		moveq	#-1,d1
		bra	copy_into_dir_ok

copy_into_dir_check_source:
		move.l	#-1,source_time			*  sourceのタイムスタンプは忘れる
		bsr	open_source			*  sourceをopenしてみる
		cmp.l	#-1,d0
		beq	copy_into_dir_done

		move.l	d0,d1				*  D1.L : handle
		tst.l	source_mode
		bpl	copy_into_dir_ok		*  ブロック・デバイス上のエントリ

		*  sourceはブロック・デバイス上のエントリではない
		tst.l	d1				*  handle
		bmi	copy_into_dir_cannot_open_source

		*  sourceはブロック・デバイス上のエントリではないがopenされた
		*  -> キャラクタ・デバイス -> エラー
		bsr	fclose
		lea	msg_is_device(pc),a2
		bsr	werror_myname_word_colon_msg
		bra	copy_into_dir_done

copy_into_dir_cannot_open_source:
		*  sourceは存在しない．-P ではエラー．
		btst	#FLAG_path,d5
		bne	copy_into_dir_perror
copy_into_dir_ok:
		btst	#FLAG_path,d5
		beq	copy_into_dir_go

		movea.l	copy_into_dir_destP,a1
make_path_loop:
		exg	a0,a1
		bsr	find_slashes
		exg	a0,a1
		beq	copy_into_dir_go

		move.b	d0,d2
		clr.b	(a1)
		lea	destination(a6),a0
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
		move.b	d2,(a1)+
		bra	make_path_loop

copy_into_dir_go:
		movea.l	copy_into_dir_sourceP,a0
		lea	destination(a6),a1
		st	intodirflag
		bsr	copy_file_or_directory_1
copy_into_dir_done:
		movem.l	(a7)+,d0-d3/d5/d7/a0-a3
		unlk	a6
copy_file_or_directory_return:
		rts

copy_into_dir_too_long_path:
		lea	msg_too_long_pathname(pc),a0
		bsr	werror_myname_and_msg
		bra	copy_into_dir_done
*****************************************************************
* copy_file_or_directory_0, copy_file_or_directory_1
*
*      A0 で示されるファイルまたはディレクトリを
*      A1 で示されるファイルまたはディレクトリとしてコピーする
*
* CALL
*      A0     source pathname
*      A1     destination pathname
*
*      copy_file_or_directory_1
*
*      既に open_source が行われて，source_pathname，source_mode，
*      source_time がセットされているものとする．
*
*      D1.L   sourceのファイル・ハンドル（-1 : 嘘open）
*      D7.L   再帰の深さ
*
* RETURN
*      D0-D3/D7/A0-A3  破壊
*      D5.L の FLAG_path bit はクリアされることがある
*****************************************************************
copy_directory_depth = -4
copy_directory_tableptr = copy_directory_depth-4
copy_directory_nentries = copy_directory_tableptr-4
copy_directory_pathbuf = copy_directory_nentries-((((MAXPATH+1)+1)>>1)<<1)
copy_directory_check_identical = copy_directory_pathbuf-1
copy_directory_auto_pad = copy_directory_check_identical-1
copy_directory_autosize = -copy_directory_auto_pad

copy_file_or_directory_0:
		sf	intodirflag
		move.l	#-1,drive
		moveq	#0,d7
		*
		*  sourceをopenしてみる
		*
		move.l	#-1,source_mode
		move.l	#-1,source_time
		st	do_check_identical
		bsr	open_source
		cmp.l	#-1,d0
		beq	copy_file_or_directory_return

		move.l	d0,d1				*  D1.L : source のファイル・ハンドル
copy_file_or_directory_1:
		*
		*  -S のチェック
		*
		btst	#FLAG_S,d5
		beq	copy_file_or_directory_S_ok

		move.l	source_mode,d0
		bmi	copy_file_or_directory_S_ok

		btst	#MODEBIT_SYS,d0
		beq	copy_file_or_directory_S_ok

		moveq	#-1,d2
		lea	msg_is_systemfile(pc),a2
		bra	copy_file_error

copy_file_or_directory_S_ok:
		cmp.l	#-1,d1
		bne	copy_file_or_directory_3

		*  sourceはブロック・デバイス上のエントリであり，
		*  source_mode も確定しているが，まだopenしていない．
		move.l	source_mode,d0
		btst	#MODEBIT_DIR,d0			*  ディレクトリか？
		bne	copy_file_or_directory_dir

		btst	#MODEBIT_VOL,d0			*  ボリュームラベルか？
		beq	copy_file

		moveq	#EDIRVOL,d1
		bra	copy_volumelabel

copy_file_or_directory_dir:
		link	a6,#copy_directory_auto_pad
		movem.l	d4/a4,-(a7)
		lea	copy_directory_pathbuf(a6),a2
		bsr	make_dirsearchpath
copy_directory_0:
		bmi	copy_directory_done		*  cat_pathname エラー
		bra	copy_directory

copy_file_or_directory_3:
		tst.l	d1
		bpl	copy_file

		*  sourceはopenできなかった
		*  ディレクトリか，ボリュームラベルか，openエラー
		link	a6,#copy_directory_auto_pad
		movem.l	d4/a4,-(a7)
		lea	copy_directory_pathbuf(a6),a2
		bsr	is_directory_2			*  ディレクトリか？
		bne	copy_directory_0

		movem.l	(a7)+,d4/a4
		unlk	a6
		move.l	d1,d0
		cmp.l	#EDIRVOL,d0			*  ボリュームラベルか？
		bne	perror
****************
*
*  ボリューム・ラベルをコピーする
*
copy_volumelabel:
	*
	*     -V が指定されていればコピーする．
	*     さもなくばエラー．
	*
		btst	#FLAG_V,d5
		bne	copy_file

		lea	msg_is_volumelabel(pc),a2
		bra	werror_myname_word_colon_msg
****************
*
*  ファイルをコピーする
*
copy_file:
		clr.b	source_fatchk_done
	*
	*  -x のチェック
	*
		btst	#FLAG_x,d5
		beq	copy_file_x_ok

		move.l	drive,d3
		bmi	copy_file_x_ok

		bsr	fatchk_source
		bmi	copy_file_x_ok

		move.w	(a2),d0
		cmp.w	d3,d0
		bne	copy_file_done
copy_file_x_ok:
	*
	*  -s のチェック
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
	*  destinationをopenしてみる
	*
		movem.l	d1/d5/a0-a1,-(a7)
		movea.l	a1,a0
		lea	realdest_pathname(pc),a1
		btst	#FLAG_s,d5
		beq	open_destination

		bset	#FLAG_d,d5
open_destination:
		moveq	#-1,d1
		move.l	d1,realdest_time
		bsr	xopen
		move.l	d1,realdest_mode
		movem.l	(a7)+,d1/d5/a0-a1
		move.l	d0,d2
		bpl	check_destination

		cmp.l	#EDIRVOL,d0
		beq	copy_file_check_dirvol

		cmp.l	#ENOFILE,d0
		beq	create_dest_with_source_mode

		cmp.l	#ENODIR,d0
		bne	copy_file_perror_1

		btst	#FLAG_n,d5
		beq	copy_file_perror_1

		tst.b	intodirflag
		beq	copy_file_perror_1
		bra	create_dest_with_source_mode

copy_file_check_dirvol:
		move.l	realdest_mode,d0
		btst	#MODEBIT_VOL,d0
		bne	copy_file_check_identical

		lea	msg_cannot_overwrite_dir(pc),a2
copy_file_destination_error:
		movea.l	a1,a0
copy_file_error:
		bsr	werror_myname_word_colon_msg
		bra	copy_file_done

check_destination:
		tst.l	realdest_mode
		bpl	copy_file_check_identical
		*
		*  destinationはopenできた．それはキャラクタ・デバイスである．
		*
		moveq	#EBADNAME,d0
		tst.b	intodirflag
		bne	copy_file_perror_1

		btst	#FLAG_d,d5
		bne	copy_file_perror_1

		btst	#FLAG_s,d5
		bne	copy_file_perror_1

		bsr	verbose
		btst	#FLAG_n,d5
		bne	copy_file_done

		*  destinationを書き込みモードで再オープンする．
		move.w	d2,d0				*  destinationを
		bsr	fclose				*  一旦closeし，
		move.w	#1,-(a7)			*  書き込みモードで
		pea	realdest_pathname(pc)		*  destinationを
		DOS	_OPEN				*  オープンする
		addq.l	#6,a7
		bra	copy_file_contents

copy_file_check_identical:
	*
	*  destinationはopenできた．それはブロック・デバイスである．
	*  source と同一でないかをチェックする．
	*
		tst.b	do_check_identical
		beq	copy_file_check_u

		*  まずタイムスタンプを調べる．
		*  これが同一でなければエントリも同一でない筈である．
		bsr	compare_timestamp
		bmi	copy_file_perror
		beq	copy_file_u_ok

		cmp.l	d0,d3
		bne	copy_file_check_u

		*  FATCHKで調べる．
		bsr	fatchk_source
		bmi	copy_file_check_u		*  おそらく特殊デバイス

		lea	dest_fatchkbuf(pc),a3
		exg	a1,a3
		move.l	a0,-(a7)
		lea	realdest_pathname(pc),a0
		bsr	fatchk
		movea.l	(a7)+,a0
		exg	a1,a3
		bmi	copy_file_check_u		*  おそらく特殊デバイス

		cmpm.w	(a2)+,(a3)+
		bne	copy_file_check_u

		cmpm.l	(a2)+,(a3)+
		bne	copy_file_check_u

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

copy_file_check_u:
	*
	*  -u のチェック
	*
		btst	#FLAG_u,d5
		beq	copy_file_u_ok

		bsr	compare_timestamp
		bmi	copy_file_perror
		beq	copy_file_u_ok

		cmp.l	d0,d3
		bhs	copy_file_done
copy_file_u_ok:
		moveq	#0,d0
		bsr	confirm_overwrite
		bne	copy_file_done

		move.w	d2,d0
		bsr	fclose
		moveq	#-1,d2
		btst	#FLAG_f,d5
		bne	remove_and_create_dest_with_source_mode

		move.l	realdest_mode,d3
		bmi	create_dest_with_source_mode_ok

		btst	#FLAG_p,d5
		bne	create_dest_with_source_mode_ok

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
		bne	create_dest_4

.if 0
		*  GNU fileutils 3.3 の cp では，destinationがシンボリック・
		*  リンクであろうと何であろうとdestinationそのものが削除される
		exg	a0,a1
		bsr	unlink
		exg	a0,a1
		*  これはおかしい
.else
.if 0
		*  real destination を削除する
		move.l	a0,-(a7)
		lea	realdest_pathname(pc),a0
		bsr	unlink
		movea.l	(a7)+,a0
		*  これが正しいと思う
.else
		*  削除する代わりに属性を変更して削除したふりをする．
		move.l	realdest_mode,d0
		and.w	#MODEVAL_LNK|MODEVAL_VOL|MODEVAL_SYS|MODEVAL_RDO,d0
		beq	remove_dest_ok

		move.l	a0,-(a7)
		lea	realdest_pathname(pc),a0
		moveq	#MODEVAL_ARC,d0
		bsr	lchmod
		movea.l	(a7)+,a0
remove_dest_ok:
		*  この方が速い．
.endif
		move.l	#-1,realdest_mode
.endif
		bra	create_dest_with_source_mode_ok

create_dest_with_source_mode:
		moveq	#0,d0
		bsr	confirm_copy
		bne	copy_file_done
create_dest_with_source_mode_ok:
		move.l	source_mode,d3
		bpl	create_dest_1

		move.w	#MODEVAL_ARC,d3
create_dest_1:
		btst	#FLAG_s,d5
		beq	create_dest_2

		move.w	#(MODEVAL_LNK|MODEVAL_ARC),d3
create_dest_2:
		move.l	realdest_mode,d0
		bmi	create_dest_3

		lea	msg_cannot_create_link(pc),a2
		btst	#MODEBIT_LNK,d3			*  シンボリック・リンクを
		bne	copy_file_destination_error	*  上書き作成することはできない

		lea	msg_cannot_overwrite_symlink(pc),a2
		btst	#MODEBIT_LNK,d0			*  シンボリック・リンクに
		bne	copy_file_destination_error	*  上書きすることはできない
create_dest_3:
		move.l	source_mode,d0
		bmi	create_dest_4

		btst	#MODEBIT_VOL,d0
		beq	create_dest_4

		*  source がボリューム・ラベルである
		*  ターゲットにボリューム・ラベルが無いかどうかをチェックする

		movem.l	a0-a1,-(a7)
		movea.l	a1,a0
		bsr	headtail
		movea.l	a0,a1
		cmp.l	#MAXHEAD,d0
		bhi	check_volumelabel_ok

		lea	pathname_buf(pc),a0
		bsr	memmovi
		lea	dos_wildcard_all(pc),a1
		bsr	strcpy
		move.w	#MODEVAL_VOL,-(a7)
		pea	pathname_buf(pc)
		pea	filesbuf(pc)
		DOS	_FILES
		lea	10(a7),a7
		tst.l	d0
		bmi	check_volumelabel_ok

		btst	#FLAG_f,d5
		bne	remove_volumelabel_loop

		movem.l	(a7)+,a0-a1
		lea	msg_volume_label_exists(pc),a2
		bra	copy_file_error

remove_volumelabel_loop:
		lea	filesbuf+ST_NAME(pc),a1
		bsr	strcpy
		move.l	a0,-(a7)
		lea	pathname_buf(pc),a0
		bsr	unlink
		movea.l	(a7)+,a0
remove_volumelabel_continue:
		pea	filesbuf(pc)
		DOS	_NFILES
		addq.l	#4,a7
		tst.l	d0
		bpl	remove_volumelabel_loop
check_volumelabel_ok:
		movem.l	(a7)+,a0-a1
create_dest_4:
		bsr	verbose
		btst	#FLAG_n,d5
		bne	copy_file_done

		move.w	d3,d0
		bsr	newmode
		move.w	d0,-(a7)
		move.l	a1,-(a7)			*  destinationを
		DOS	_CREATE				*  作成する
		addq.l	#6,a7				*  （ドライブの検査は済んでいる）
copy_file_contents:
		move.l	d0,d2
		bmi	copy_file_perror_1
	*
	*  sourceが未openであればここで本当にopenする
	*
		bsr	do_open_source			*  sourceが未openであれば本当にopenする
		bmi	copy_file_perror
	*
	*  ファイルの内容をコピーする
	*
		tst.l	d1
		bmi	copy_file_contents_done

		btst	#FLAG_s,d5
		beq	copy_loop

		bsr	strlen
		move.l	a0,d3
		bra	copy_write

copy_loop:
		tst.l	d4
		beq	insufficient_memory

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
	*  -p が指定されていれば、ファイルのタイムスタンプをコピーする
	*
		btst	#FLAG_p,d5
		beq	copy_file_date_done

		bsr	get_source_time
		beq	copy_file_date_done

		move.l	d0,-(a7)
		move.w	d2,-(a7)
		DOS	_FILEDATE
		addq.l	#6,a7
			* エラー処理省略 (無視)
copy_file_date_done:
copy_file_done:
		move.l	d2,d0
		bsr	fclosex
		move.l	d1,d0
		bra	fclosex


copy_file_or_directory_disk_full:
		moveq	#EDISKFULL,d0
copy_file_perror_1:
		movea.l	a1,a0
copy_file_perror:
		cmp.l	#-1,d0
		beq	copy_file_done

		bsr	perror
		bra	copy_file_done
****************
*
*  ディレクトリをコピーする
*
copy_directory:
	*
	*  -r が指定されているなら，再帰的にコピーする
	*  さもなくばエラー
	*
		btst	#FLAG_r,d5
		beq	cannot_copy_directory
		*
		*  A2 : copy_directory_pathbuf : source/*.*
		*                                       |
		*                                       A3
	*
	*  再帰レベルチェック
	*
		addq.l	#1,d7				*  ディレクトリの深さをインクリメント
		cmp.l	#MAXRECURSE,d7
		bhi	dir_too_deep

		move.l	d7,copy_directory_depth(a6)
	*
	*  -x のためのドライブのチェック
	*
		sf	d2
		btst	#FLAG_x,d5
		beq	do_copy_directory		*  チェック不要

		tst.l	drive
		bmi	copy_directory_get_drive

		st	d2
		move.l	a0,-(a7)
		lea	source_pathname(pc),a0
		bsr	getdno
		movea.l	(a7)+,a0
		move.l	d0,d1
		bmi	do_copy_directory

		cmp.l	drive,d0
		beq	do_copy_directory
		bra	copy_directory_done

copy_directory_get_drive:
		bsr	getdno
		move.l	d0,drive
do_copy_directory:
	*
	*  内容のそれぞれについて，同一性をチェックする必要があるかどうか
	*
		sf	copy_directory_check_identical(a6)
		exg	a0,a1
		bsr	getdno
		exg	a0,a1
		bmi	do_copy_directory_3		*  dest dir が新規 .. チェック不要

		btst	#FLAG_d,d5
		beq	do_copy_directory_2		*  リンクの可能性がある .. 要チェック

		exg	d0,d1
		tst.b	d2
		bne	do_copy_directory_1

		move.l	a0,-(a7)
		lea	source_pathname(pc),a0
		bsr	getdno
		movea.l	(a7)+,a0
do_copy_directory_1:
		tst.l	d0
		bmi	do_copy_directory_3		*  src dir が fatchk 不可 .. チェック不要

		cmp.l	d0,d1
		bne	do_copy_directory_3		*  src と dest は別ドライブ .. チェック不要
do_copy_directory_2:
		st	copy_directory_check_identical(a6)
do_copy_directory_3:
	*
	*  ソース・ディレクトリ下のファイルを検索する
	*
		move.l	a4,copy_directory_tableptr(a6)
		clr.l	copy_directory_nentries(a6)
		movem.l	a0-a1,-(a7)
		move.w	#MODEVAL_ALL,-(a7)		*  すべてのエントリを検索する
		move.l	a2,-(a7)
		pea	filesbuf(pc)
		DOS	_FILES
		lea	10(a7),a7
scan_directory_contents_loop:
		tst.l	d0
		bmi	scan_directory_contents_done

		btst	#FLAG_V,d5
		bne	scan_directory_contents_vol_ok

		btst.b	#MODEBIT_VOL,filesbuf+ST_MODE(pc)
		bne	scan_directory_contents_continue	*  ボリューム・ラベルはコピーしない
scan_directory_contents_vol_ok:
		btst	#FLAG_S,d5
		beq	scan_directory_contents_sys_ok

		btst.b	#MODEBIT_SYS,filesbuf+ST_MODE(pc)
		bne	scan_directory_contents_continue
scan_directory_contents_sys_ok:
		lea	filesbuf+ST_NAME(pc),a0
		bsr	isrel
		bne	scan_directory_contents_continue

		bsr	strlen
		addq.l	#6,d0
		sub.l	d0,d4
		bcs	insufficient_memory

		move.w	filesbuf+ST_DATE(pc),d0
		ror.w	#8,d0
		move.b	d0,(a4)+
		ror.w	#8,d0
		move.b	d0,(a4)+

		move.w	filesbuf+ST_TIME(pc),d0
		ror.w	#8,d0
		move.b	d0,(a4)+
		ror.w	#8,d0
		move.b	d0,(a4)+

		move.b	filesbuf+ST_MODE(pc),d0
		move.b	d0,(a4)+

		movea.l	a0,a1
		exg	a0,a4
		bsr	strmove
		exg	a0,a4
		addq.l	#1,copy_directory_nentries(a6)
scan_directory_contents_continue:
		pea	filesbuf(pc)
		DOS	_NFILES
		addq.l	#4,a7
		bra	scan_directory_contents_loop

scan_directory_contents_done:
		movem.l	(a7)+,a0-a1
	*
	*  destinationをチェックする
	*
		bclr	#31,d5
		exg	a0,a1
		movem.l	a1,-(a7)
		lea	realdest_pathname(pc),a1
		moveq	#-1,d1
		moveq	#0,d2
		bsr	xopen
		movem.l	(a7)+,a1
		cmp.l	#-1,d0
		beq	copy_directory_done

		move.l	d0,d3
		bsr	fclosex
		tst.l	d1
		bmi	copy_directory_dest_is_not_link

		btst	#MODEBIT_LNK,d1
		bne	copy_directory_dest_is_nondir
copy_directory_dest_is_not_link:
		bsr	is_directory
		bmi	copy_directory_done		*  エラー
		bne	copy_directory_dest_is_dir	*  ディレクトリかまたは
							*  ディレクトリへのシンボリック・リンク
		*  destinationはディレクトリではない

		tst.l	d1
		bpl	copy_directory_dest_is_nondir

		*  destinationのパスが無効
		*  destinationがエントリとして存在しない
		*  destinationはシンボリック・リンクで，その参照ファイルが存在しない

		btst	#FLAG_n,d5
		beq	copy_directory_do_mkdir

		moveq	#EBADNAME,d0
		tst.l	d3
		bpl	copy_directory_perror		*  デバイス..エラー

		move.l	d3,d0
		cmp.l	#ENOFILE,d0
		beq	copy_directory_mkdir_done	*  存在しない..mkdir

		cmp.l	#ENODIR,d0
		bne	copy_directory_perror		*  パスが存在しない..エラー

		tst.b	intodirflag
		bne	copy_directory_mkdir_done
copy_directory_perror:
		bsr	perror
		bra	copy_directory_done

copy_directory_dest_is_dir:
		exg	a0,a1
		moveq	#MODEVAL_DIR,d0
		bsr	confirm_copy
		exg	a0,a1
		bne	copy_directory_done
		bra	copy_directory_attributes

copy_directory_dest_is_nondir:
		*  real destination が non-directory
		exg	a0,a1
		moveq	#MODEVAL_DIR,d0
		bsr	confirm_overwrite
		exg	a0,a1
		bne	copy_directory_done

		moveq	#EMKDIREXISTS,d0
		btst	#FLAG_f,d5
		beq	copy_directory_perror

		btst	#FLAG_n,d5
		bne	copy_directory_mkdir_done

		*  real destination を削除する
		move.l	a0,-(a7)
		lea	realdest_pathname(pc),a0
		bsr	unlink
		movea.l	(a7)+,a0
		bra	copy_directory_do_mkdir_ok

copy_directory_do_mkdir:
		exg	a0,a1
		moveq	#MODEVAL_DIR,d0
		bsr	confirm_copy
		exg	a0,a1
		bne	copy_directory_done
copy_directory_do_mkdir_ok:
		move.l	a0,-(a7)
		lea	realdest_pathname(pc),a0
		bsr	do_mkdir
		movea.l	(a7)+,a0
		bmi	copy_directory_perror
copy_directory_mkdir_done:
		exg	a0,a1
		bsr	verbose
		exg	a0,a1
		bset	#31,d5				*  real destinaiton は new
		moveq	#MODEVAL_DIR,d1
copy_directory_attributes:
		exg	a0,a1
		btst	#FLAG_n,d5
		bne	copy_directory_contents

		btst	#31,d5				*  destination がもともと存在していた
		beq	copy_directory_contents		*  場合には、その時刻と属性は保存する

		btst	#FLAG_p,d5
		beq	copy_directory_mode
	*
	*  タイムスタンプをコピーする
	*
		moveq	#EDIRVOL,d1
		bsr	get_source_time
		beq	copy_directory_mode

		move.l	d0,d3
		lea	realdest_pathname(pc),a0
		move.w	#MODEVAL_ARC,d0
		bsr	lchmod
		bmi	copy_directory_mode

		move.w	#1,-(a7)
		move.l	a0,-(a7)
		DOS	_OPEN
		addq.l	#6,a7
		move.l	d0,d1
		bmi	copy_directory_mode

		move.l	d3,-(a7)
		move.w	d1,-(a7)
		DOS	_FILEDATE			*  タイムスタンプを設定する
		addq.l	#6,a7
			* エラー処理省略 (無視)
		move.w	d1,d0
		bsr	fclose
copy_directory_mode:
	*
	*  属性をコピーする
	*
		move.l	source_mode,d0
		bpl	copy_directory_mode_1

		moveq	#MODEVAL_DIR,d0
copy_directory_mode_1:
		lea	realdest_pathname(pc),a0
		bsr	newmode
		bsr	lchmod				*  属性を設定する
			* エラー処理省略 (無視)
copy_directory_contents:
	*
	*  ソース・ディレクトリ下のファイルをコピーする
	*
		bclr	#FLAG_path,d5
copy_directory_contents_loop:
		subq.l	#1,copy_directory_nentries(a6)
		bcs	copy_directory_done

		move.l	a1,-(a7)
		movea.l	copy_directory_tableptr(a6),a1
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		lsl.l	#8,d0
		move.b	(a1)+,d0
		lsl.l	#8,d0
		move.b	(a1)+,d0
		move.l	d0,source_time
		moveq	#0,d0
		move.b	(a1)+,d0
		move.l	d0,source_mode
		movea.l	a3,a0
		bsr	strmove
		move.l	a1,copy_directory_tableptr(a6)
		movea.l	(a7)+,a1
		movea.l	a2,a0
		move.b	copy_directory_check_identical(a6),d0
		move.b	d0,do_check_identical
		move.l	copy_directory_depth(a6),d0
		bsr	copy_into_dir_1
		bra	copy_directory_contents_loop

dir_too_deep:
		lea	msg_dir_too_deep(pc),a2
		bsr	werror_myname_word_colon_msg
		bra	copy_directory_done

cannot_copy_directory:
		lea	msg_is_directory(pc),a2
		bsr	werror_myname_word_colon_msg
copy_directory_done:
		movem.l	(a7)+,d4/a4
		unlk	a6
		rts
*****************************************************************
* compare_timestamp - sourceとdestinationのタイムスタンプを得る
*
* CALL
*      D1.L                sourceをopenした結果
*                          openが成功したならファイル・ハンドル
*                          失敗したならDOSエラー・コード
*                          未openならば -1
*
*      D2.L                destinationをopenした結果
*                          openが成功したならファイル・ハンドル
*                          失敗したならDOSエラー・コード
*
*      source_time         sourceのタイムスタンプ
*      realdest_time       destinationのタイムスタンプ
*
*                          不明ならば -1．その場合はここでタイム
*                          スタンプを取得して帰る．
*                          そうでなければ，この値がそのまま戻り値
*                          になる．
*
*                          不明ならば -1．その場合はここでタイム
*                          スタンプを取得して帰る．
*                          そうでなければ，この値がそのまま戻り値
*                          になる．
*
*      source_pathname     sourceの実体のパス名
*      realdest_pathname   destinationの実体のパス名
*
* RETURN
*      source_time    sourceのタイムスタンプ
*                     取得できなかった場合は 0
*
*      D0.L           source_time の値
*                     エラーの場合はDOSエラー・コード
*
*      realdest_time  destinationのタイムスタンプ
*                     取得できなかった場合は 0
*
*      D3.L           realdest_time の値
*
*      CCR            エラーなら MI
*                     sourceとdestinationのどちらかのタイムスタン
*                     プの取得に失敗したなら EQ
*
* NOTE
*      CALL の D1.L が -1 の場合にのみエラーが起こり得る
*****************************************************************
compare_timestamp:
	*
	*  destinationのタイムスタンプを得る
	*
		move.l	realdest_time,d3
		cmp.l	#-1,d3
		bne	compare_timestamp_dest_ok	*  realdest_time は確定している

		*  realdest_time は確定していない
		move.w	d2,d0				*  destinationのopenが成功していれば
		bpl	compare_timestamp_get_dest	*  ファイル・ハンドルからタイムスタンプを取得する

		*  destinationのopenには失敗している
		*  （ディレクトリかボリュームラベル）
		*  FILES でタイムスタンプを得る
		move.w	#MODEVAL_ALL,-(a7)
		pea	realdest_pathname(pc)
		pea	filesbuf(pc)
		DOS	_FILES
		lea	10(a7),a7
		tst.l	d0
		bmi	compare_timestamp_dest_fail

		move.l	filesbuf+ST_TIME(pc),d0
		swap	d0
		bra	compare_timestamp_set_dest

compare_timestamp_dest_fail:
		moveq	#0,d0
		bra	compare_timestamp_set_dest

compare_timestamp_get_dest:
		bsr	get_filedate			*  ファイル・ハンドルからタイムスタンプを取得する
compare_timestamp_set_dest:
		move.l	d0,realdest_time
		move.l	d0,d3
compare_timestamp_dest_ok:
		tst.l	d3
		beq	compare_timestamp_return	*  CCR : EQ
	*
	*  sourceのタイムスタンプを得る
	*
*bsr	get_source_time
*rts
*****************************************************************
* get_source_time - source のタイムスタンプを得る
*
* CALL
*      D1.L                sourceをopenした結果
*                          openが成功したならファイル・ハンドル
*                          失敗したならDOSエラー・コード
*                          未openならば -1
*
*      source_time         sourceのタイムスタンプ
*                          不明ならば -1．その場合はここでタイム
*                          スタンプを取得して帰る．
*                          そうでなければ，この値がそのまま戻り値
*                          になる．
*
*      source_pathname     sourceの実体のパス名
*
* RETURN
*      source_time    sourceのタイムスタンプ
*                     取得できなかった場合は 0
*
*      D0.L           source_time の値
*                     エラーの場合はDOSエラー・コード
*
*      CCR            エラーなら MI
*                     タイムスタンプが取得できなければ EQ
*
* NOTE
*      CALL の D1.L が -1 の場合にのみエラーが起こり得る
*****************************************************************
get_source_time:
		move.l	source_time,d0
		cmp.l	#-1,d0
		bne	get_source_time_2		*  source_time は確定している

		*  source_time は確定していない
		bsr	do_open_source			*  sourceが未openならばsourceをopenする
		bmi	get_source_time_return		*  openエラー

		tst.l	d1
		bmi	get_source_time_3		*  sourceはopenできない..FILES で得る

		move.w	d1,d0				*  sourceのファイル・ハンドルから
		bsr	get_filedate			*  タイムスタンプを得る
get_source_time_1:
		move.l	d0,source_time
get_source_time_2:
		tst.l	d0
get_source_time_return:
compare_timestamp_return:
		rts

get_source_time_3:
		*  sourceはディレクトリかボリューム・ラベル
		*  FILES でタイムスタンプを得る
		move.w	#MODEVAL_ALL,-(a7)
		pea	source_pathname(pc)
		pea	filesbuf(pc)
		DOS	_FILES
		lea	10(a7),a7
		tst.l	d0
		bmi	get_source_time_fail

		move.l	filesbuf+ST_TIME(pc),d0
		swap	d0
		bra	get_source_time_1

get_source_time_fail:
		moveq	#0,d0
		bra	get_source_time_1
*****************************************************************
confirm_overwrite:
		movem.l	a0/a2,-(a7)
		lea	msg_confirm_overwrite(pc),a2
		btst	#FLAG_i,d5
		bne	do_confirm
		bra	confirm_I

confirm_copy:
		movem.l	a0/a2,-(a7)
		lea	msg_confirm_copy(pc),a2
confirm_I:
		btst	#FLAG_I,d5
		beq	confirm_yes
do_confirm:
		btst	#FLAG_n,d5
		bne	confirm_yes

		move.l	a0,-(a7)
		move.l	d0,-(a7)
		bsr	werror_myname
		move.l	(a7)+,d0
		bne	do_confirm_1

		lea	msg_device(pc),a0
		move.l	source_mode,d0
		bmi	do_confirm_2
do_confirm_1:
		lea	msg_volumelabel(pc),a0
		btst	#MODEBIT_VOL,d0
		bne	do_confirm_2

		lea	msg_directory(pc),a0
		btst	#MODEBIT_DIR,d0
		bne	do_confirm_2

		lea	msg_file(pc),a0
do_confirm_2:
		bsr	werror
		movea.l	(a7)+,a0
		bsr	werror
		lea	msg_wo(pc),a0
		bsr	werror
		movea.l	a1,a0
		bsr	werror
		movea.l	a2,a0
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
		movem.l	(a7)+,a0/a2
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
isrel:
		moveq	#0,d0
		cmpi.b	#'.',(a0)
		bne	isrel_return

		moveq	#1,d0
		tst.b	1(a0)
		beq	isrel_return

		moveq	#0,d0
		cmpi.b	#'.',1(a0)
		bne	isrel_return

		tst.b	2(a0)
		bne	isrel_return

		moveq	#2,d0
isrel_return:
		tst.l	d0
		rts
*****************************************************************
* find_dot
*
* CALL
*      A0     name
*
* RETURN
*      A0     name に . があるなら，最初の . の位置
*             name に . が無ければ，最後の \0 の位置
*
*      D0.L   name に . があるなら，最初の . の直前までのバイト数
*             name に . が無ければ，name のバイト数
*****************************************************************
find_dot:
		move.l	a0,-(a7)
find_dot_loop:
		move.b	(a0)+,d0
		beq	find_dot_return

		cmp.b	#'.',d0
		bne	find_dot_loop
find_dot_return:
		subq.l	#1,a0
		move.l	a0,d0
		sub.l	(a7)+,d0
		rts
*****************************************************************
getdno:
		movem.l	d1/a0-a1,-(a7)
		bsr	getdno_sub
		bpl	getdno_ok

		lea	nameck_buffer(pc),a1
		move.l	a1,-(a7)
		move.l	a0,-(a7)
		DOS	_NAMECK
		addq.l	#8,a7
		tst.l	d0
		bmi	getdno_return

		moveq	#-1,d0
		tst.b	67(a1)
		bne	getdno_return

		movea.l	a1,a0
		bsr	strip_excessive_slashes
		bsr	getdno_sub
		bpl	getdno_ok

		tst.b	3(a0)
		bne	getdno_return

		moveq	#0,d1
		move.b	(a0),d1
		sub.w	#'A',d1
getdno_ok:
		move.l	d1,d0
getdno_return:
		movem.l	(a7)+,d1/a0-a1
		tst.l	d0
		rts

getdno_sub:
		lea	tmp_fatchkbuf(pc),a1
		bsr	fatchk
		bne	getdno_sub_ok

		moveq	#0,d0
getdno_sub_ok:
		moveq	#0,d1
		move.w	(a1),d1
		subq.w	#1,d1
		tst.l	d0
		rts
*****************************************************************
fatchk_source:
		lea	source_fatchkbuf(pc),a2
		tst.b	source_fatchk_done
		bne	fatchk_source_return

		move.b	#1,source_fatchk_done
		exg	a1,a2
		move.l	a0,-(a7)
		lea	source_pathname(pc),a0
		bsr	fatchk
		movea.l	(a7)+,a0
		exg	a1,a2
		bpl	fatchk_source_return

		move.b	#-1,source_fatchk_done
fatchk_source_return:
		rts
*****************************************************************
fatchk:
		move.l	a1,d0
		bset	#31,d0
		move.w	#14,-(a7)
		move.l	d0,-(a7)
		move.l	a0,-(a7)
		DOS	_FATCHK
		lea	10(a7),a7
		cmp.l	#EBADPARAM,d0
		beq	fatchk_return

		tst.l	d0
fatchk_return:
		rts
*****************************************************************
newmode:
		bchg	#MODEBIT_RDO,d0
		and.b	mode_mask,d0
		or.b	mode_plus,d0
		bchg	#MODEBIT_RDO,d0
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
do_open_source:
		cmp.l	#-1,d1
		bne	do_open_source_return

		bsr	open_source
		move.l	d0,d1
		rts

do_open_source_return:
		cmp.l	d1,d1
		rts
*****************************************************************
open_source:
		movem.l	d1/a1,-(a7)
		lea	source_pathname(pc),a1
		move.l	source_mode,d1
		bsr	xopen
		move.l	d1,source_mode
		movem.l	(a7)+,d1/a1
		tst.l	d0
		rts
*****************************************************************
* xopen - ファイル（またはデバイス）をオープンする
*
* CALL
*      A0     オープンするファイル（またはデバイス）名
*      A1     実際にオープンしたファイル（またはデバイス）名を格納するバッファ
*             （128バイト必要）
*      D1.L   ファイルのモード．不明ならば -1．
*      D5.B   FLAG_dビットが立っていれば、ファイルがシンボリック・リンクであるとき
*             リンク・ファイル自身をオープンする
*
* RETURN
*      D0.L   オープンしたファイルハンドル．またはDOSエラー・コード
*      D1.L   実際のファイルのモード．またはDOSエラー・コード
*****************************************************************
xopen:
		movem.l	d4/a2-a3/a6,-(a7)
		tst.l	d1
		bpl	xopen_1

		bsr	lgetmode
		move.l	d0,d1
		bmi	xopen_normal			*  ファイルは無い -> 通常の OPEN
							*  （デバイスかも知れない）
xopen_1:
		btst	#MODEBIT_LNK,d1
		beq	xopen_normal			*  SYMLINKではない -> 通常の OPEN

		*  ファイルはシンボリック・リンクである

		btst	#FLAG_d,d5			*  -dフラグが指定されているなら
		bne	xopen_link_on_lndrv		*  指定ファイルそのものをopenする

		moveq	#-1,d1				*  modeは忘れる
		moveq	#LNDRV_getrealpath,d0
		tst.l	lndrv
		bne	xopen_on_lndrv			*  リンクが参照するファイルをopenする

		lea	msg_cannot_access_link(pc),a2
		bsr	werror_myname_word_colon_msg
		moveq	#-1,d0
		bra	xopen_done

xopen_link_on_lndrv:
		tst.l	lndrv				*  lndrvが常駐していないなら
		beq	xopen_normal			*  通常の OPEN

		moveq	#LNDRV_realpathcpy,d0
xopen_on_lndrv:
		movea.l	lndrv,a2
		movea.l	(a2,d0.l),a3
		clr.l	-(a7)
		DOS	_SUPER				*  スーパーバイザ・モードに切り換える
		addq.l	#4,a7
		move.l	d0,-(a7)			*  前の SSP の値
		movem.l	d1-d3/d5-d7/a0-a5,-(a7)
		move.l	a0,-(a7)
		move.l	a1,-(a7)
		jsr	(a3)
		addq.l	#8,a7
		movem.l	(a7)+,d1-d3/d5-d7/a0-a5
		tst.l	d0
		bmi	xopen_readlink_error

		exg	a0,a1
		bsr	strip_excessive_slashes
		exg	a0,a1

		tst.l	d1
		bpl	xopen_on_lndrv_1

		movem.l	d2-d3/d5-d7/a0-a5,-(a7)
		movea.l	LNDRV_O_CHMOD(a2),a3
		move.w	#-1,-(a7)
		move.l	a1,-(a7)
		movea.l	a7,a6
		jsr	(a3)
		addq.l	#6,a7
		movem.l	(a7)+,d2-d3/d5-d7/a0-a5
		move.l	d0,d1
xopen_on_lndrv_1:
		movem.l	d1-d3/d5-d7/a0-a5,-(a7)
		movea.l	lndrv,a2
		movea.l	LNDRV_O_OPEN(a2),a3
		clr.w	-(a7)
		move.l	a1,-(a7)
		movea.l	a7,a6
		jsr	(a3)
		addq.l	#6,a7
		movem.l	(a7)+,d1-d3/d5-d7/a0-a5
		move.l	d0,d4
		DOS	_SUPER				*  ユーザ・モードに戻す
		addq.l	#4,a7
		move.l	d4,d0
		bra	xopen_done

xopen_readlink_error:
		DOS	_SUPER				*  ユーザ・モードに戻す
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
		movem.l	(a7)+,d4/a2-a3/a6
		rts
*****************************************************************
fclosex:
		bmi	fclose_return
fclose:
		move.w	d0,-(a7)
		DOS	_CLOSE
		addq.l	#2,a7
fclose_return:
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
* get_filedate - ファイル・ハンドルからタイムスタンプを得る
*
* CALL
*      D0.W   ファイル・ハンドル
*
* RETURN
*      D0.L   タイムスタンプ
*             取得できなければ 0
*
*      CCR    TST.L D0
*****************************************************************
get_filedate:
		clr.l	-(a7)
		move.w	d0,-(a7)
		DOS	_FILEDATE
		addq.l	#6,a7
		cmp.l	#$ffff0000,d0
		bls	get_filedate_return

		moveq	#0,d0
get_filedate_return:
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
make_dirsearchpath:
		movem.l	a1-a2,-(a7)
		move.l	a0,-(a7)
		movea.l	a0,a1
		movea.l	a2,a0
		lea	dos_wildcard_all(pc),a2
		bsr	cat_pathname
		movea.l	(a7)+,a0
		bpl	make_dirsearchpath_return

		lea	msg_too_long_pathname(pc),a2
		bsr	werror_myname_word_colon_msg
		moveq	#-1,d0
make_dirsearchpath_return:
		movem.l	(a7)+,a1-a2
		rts
*****************************************************************
* is_directory, is_directory_2 - 名前がディレクトリであるかどうかを調べる
*
* CALL
*      A0     名前
*
*      is_directory_2
*      A2     名前/*.* を格納するバッファ
*
* RETURN
*      D0.L   名前/*.* が長すぎるならば -1．
*             このときエラーメッセージが表示され，D6.L には 2 がセットされる．
*
*             そうでなければ，名前がディレクトリならば 1，さもなくば 0
*
*      CCR    TST.L D0
*
*      is_directory_2
*      (A2)   名前/*.* が格納される
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
		tst.b	(a0)
		beq	is_directory_false

		bsr	make_dirsearchpath
		bmi	is_directory_return

		move.w	#MODEVAL_ALL,-(a7)		*  すべてのエントリを検索する
		move.l	a2,-(a7)
		pea	filesbuf(pc)
		DOS	_FILES
		lea	10(a7),a7
		tst.l	d0
		bpl	is_directory_true

		cmp.l	#ENOFILE,d0
		beq	is_directory_true
is_directory_false:
		moveq	#0,d0
		rts

is_directory_true:
		moveq	#1,d0
is_directory_return:
		rts
*****************************************************************
werror_myname:
		move.l	a0,-(a7)
		lea	msg_myname(pc),a0
		bsr	werror
		movea.l	(a7)+,a0
		rts

werror_myname_and_msg:
		bsr	werror_myname
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
	dc.b	'## cp 2.4 ##  Copyright(C)1992-93 by Itagaki Fumihiko',0

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
msg_error:		dc.b	'エラー',0
msg_nofile:		dc.b	'このようなファイルやディレクトリはありません',0
msg_nopath:		dc.b	'パスが存在していません',0
msg_too_many_openfiles:	dc.b	'オープンしているファイルが多すぎます',0
msg_bad_name:		dc.b	'名前が無効です',0
msg_bad_drive:		dc.b	'ドライブの指定が無効です',0
msg_write_disabled:	dc.b	'書き込みが許可されていません',0
msg_cannot_mkdir:	dc.b	'ディレクトリを作成できません: ファイルが存在しています',0
msg_directory_full:	dc.b	'ディレクトリが満杯です',0
msg_disk_full:		dc.b	'ディスクが満杯です',0

msg_myname:			dc.b	'cp'
msg_colon:			dc.b	': ',0
msg_dos_version_mismatch:	dc.b	'バージョン2.00以降のHuman68kが必要です',CR,LF,0
msg_no_memory:			dc.b	'メモリが足りません',CR,LF,0
msg_illegal_option:		dc.b	'不正なオプション -- ',0
msg_bad_arg:			dc.b	'引数が正しくありません',0
msg_too_few_args:		dc.b	'引数が足りません',0
msg_too_long_pathname:		dc.b	'パス名が長過ぎます',0
msg_not_a_directory:		dc.b	'ディレクトリではありません',0
msg_nodir:			dc.b	'このようなディレクトリはありません',0
msg_dir_too_deep:		dc.b	'ディレクトリが深過ぎて処理できません',0
msg_and:			dc.b	' と ',0
msg_are_identical:		dc.b	' とは同一のファイルです（コピーしません）',0
msg_is_directory:		dc.b	'ディレクトリです（コピーしません）',0
msg_is_volumelabel:		dc.b	'ボリューム・ラベルです（コピーしません）',0
msg_is_systemfile:		dc.b	'システム・ファイルです（コピーしません）',0
msg_is_device:			dc.b	'キャラクタ・デバイスです（コピーしません）',0
msg_unadjustable_name:		dc.b	': 調整できない名前です（コピーしません）',CR,LF,0
msg_unfitname:			dc.b	': 名前が不適格です',0
msg_will_ask:			dc.b	'（代わりの名前を尋ねます）',CR,LF,0
msg_destname:			dc.b	'代わりの名前（[.]:コピーしない',0
msg_destname_1:			dc.b	'; [CR]:',0
msg_destname_2:			dc.b	'）: ',0
msg_dont_make_symbolic_link:	dc.b	'相対シンボリック・リンクは‘.’にのみ作成可能です',0
msg_cannot_access_link:		dc.b	'lndrvが組み込まれていないためシンボリック・リンクの参照ファイルにアクセスできません',0
msg_device:			dc.b	'デバイス ',0
msg_volumelabel:		dc.b	'ボリューム・ラベル ',0
msg_directory:			dc.b	'ディレクトリ ',0
msg_file:			dc.b	'ファイル ',0
msg_confirm_overwrite:		dc.b	' に上書きしますか？ ',0
msg_wo:				dc.b	' を ',0
msg_confirm_copy:		dc.b	' にコピーしますか？ ',0
msg_cannot_overwrite_dir:	dc.b	'ディレクトリには書き込めません',0
msg_cannot_overwrite_symlink:	dc.b	'シンボリック・リンクには書き込めません',0
msg_cannot_create_link:		dc.b	'シンボリック・リンクを作成できません; ファイルが存在しています',0
msg_volume_label_exists:	dc.b	'ボリューム・ラベルをコピーしません; ボリューム・ラベルが存在しています',0
msg_usage:			dc.b	CR,LF,CR,LF
	dc.b	'使用法:  cp [-ISVadfinpsuv] [-m <属性変更式>] [--] f1 f2',CR,LF
	dc.b	'              f1: コピーするファイルまたは入力デバイス',CR,LF
	dc.b	'              f2: 複製ファイル名または出力デバイス',CR,LF,CR,LF

	dc.b	'         cp {-R|-r} [-BCDILUSVadefinpsuvx] [-m <属性変更式>] [--] d1 d2',CR,LF
	dc.b	'              d1: コピーするディレクトリ',CR,LF
	dc.b	'              d2: 複製ディレクトリ名（新規）',CR,LF,CR,LF

	dc.b	'         cp [-BCDILPRSUVadefinprsuvx] [-m <属性変更式>] [--] any ... targetdir',CR,LF
	dc.b	'              any: コピーするファイルやディレクトリ',CR,LF
	dc.b	'              targetdir: コピー先ディレクトリ',CR,LF,CR,LF

	dc.b	'         属性変更式: {[ugoa]{{+-=}[ashrwx]}...}[,...] または 8進数値表現'
msg_newline:		dc.b	CR,LF,0
msg_arrow:		dc.b	' -> ',0
msg_mkdir:		dc.b	'mkdir ',0
dos_wildcard_all:	dc.b	'*.*',0
str_question:		dc.b	'?',0
*****************************************************************
.bss

lndrv:			ds.l	1
source_mode:		ds.l	1
source_time:		ds.l	1
realdest_mode:		ds.l	1
realdest_time:		ds.l	1
drive:			ds.l	1
copy_into_dir_sourceP:	ds.l	1
copy_into_dir_destP:	ds.l	1
.even
source_fatchkbuf:	ds.b	14+8			* +8 : fatchkバグ対策
.even
dest_fatchkbuf:		ds.b	14+8			* +8 : fatchkバグ対策
.even
tmp_fatchkbuf:		ds.b	14+8			* +8 : fatchkバグ対策
.even
filesbuf:		ds.b	STATBUFSIZE
.even
getsbuf:		ds.b	2+GETSLEN+1
source_pathname:	ds.b	128
realdest_pathname:	ds.b	128
pathname_buf:		ds.b	128
nameck_buffer:		ds.b	91
intodirflag:		ds.b	1
do_check_identical:	ds.b	1
source_fatchk_done:	ds.b	1
mode_mask:		ds.b	1
mode_plus:		ds.b	1
.even
	ds.b	16384+(copy_into_dir_autosize+4*12+copy_directory_autosize+4*3)*(MAXRECURSE+1)
	*  必要なスタック量は，再帰の度に消費されるスタック量とその回数とで決まる．
	*  4*12 ... copy_into_dir でのセーブレジスタ D0-D3/D5/D7/A0-A3/A6/PC
	*  4*3 ... copy_directory でのセーブレジスタ A0/A6/PC
	*  この他にマージンとスーパーバイザ・スタックとを兼ねて16KB確保しておく．
.even
stack_bottom:
*****************************************************************

.end start
