
.data ; start of a data section
public g ; export variable g
g QWORD 4 ; declare global variable g initialised to 4
.code ; start of a code section

;t2.asm

; PARAMETERS rcx, rdx, r8, r9
; rcx	rdx		r8		r9
; a		b		c

public      min               ; make sure function name is exported

min:
		mov rax, rcx		; v = a
		cmp rdx, rax		; if (b < v)
		jge min0			: {
		mov rax, rdx		; v = b
min0						; }
		cmp r8, rax			; if (c < v)
		jge min1			: {
		mov rax, r8			; v = c
min1						; }	
		ret                 ; return v in rax	


_int64 p(_int64 i, _int64 j, _int64 k, _int64 l)
{
	return min(min(g, i, j), k, l);
}

; rcx	rdx		r8		r9
; i		j		k		l





END